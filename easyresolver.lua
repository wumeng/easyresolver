-- base on resty.dns.resolver,resty.lrucache
-- Copyright (C) wumeng(wu.meng.email@gmail.com)

local io_open = io.open
local ngx_gmatch = ngx.re.gmatch
local path = "/etc/resolv.conf"
local resolver = require "resty.dns.resolver"
local lrucache = require "resty.lrucache"
local ip_cache = lrucache.new(50)  -- allow up to 50 items in the cache
if not ip_cache then
	ngx.log(ngx.ERR,"##jimdb module##,failed to create the cache: " .. (err or "unknown"))
    return error("failed to create the cache: " .. (err or "unknown"))
end
local ip_list_cache_key = "ip_list_key"
local cache_time = 600



local _M = { _VERSION = '0.01' }

	-- read os dns config
	local function readOsDnsConfig()
		local file, err = io_open(path, "r")

		if not file or err then
			return nil, err
		end

		local result = file:read("*all")
		file:close()
		return result
	end

	-- match dns config
	local function matchDns()
		local nameserver = {}
		local dns_str = readOsDnsConfig()
	    local captures, it, err
		it, err = ngx_gmatch(dns_str, [[^nameserver\s+(\d+?\.\d+?\.\d+?\.\d+$)]], "jomi")

	    for captures, err in it do
	        if not err then
	            table.insert(nameserver,captures[1])
	        end
	    end

		return nameserver
	end

	-- resolve domain and return ipList
	function _M.getDomainIpList(domain)

		local list = ip_cache:get(ip_list_cache_key)
		if list ~= nil and list ~= "" then
	        ngx.log(ngx.ALERT,"##easyresolver module##,get ip_list from cache")
			return list
		end	

		local nameserver = matchDns()
		local ip_list = {}

	    local r, err = resolver:new{
	        nameservers = nameserver,
	        retrans = 5,  
	        timeout = 5000, 
	    }

	    if not r then
	        ngx.log(ngx.ERR,"##easyresolver module##,failed to instantiate the resolver,error: "..err)
	        return nil
	    end

	    local answers, err = r:query(domain)
	    if not answers then
	        ngx.log(ngx.ERR,"##easyresolver module##,failed to query the DNS server,error: "..err)
	        return nil
	    end

	    if answers.errcode then
	    	ngx.log(ngx.ERR,"##easyresolver module##,server returned error code: "..answers.errcode.." , "..answers.errstr)
	    	return nil
	    end

	    for i, ans in ipairs(answers) do
	    	if ans.address ~= nil then
	    		table.insert(ip_list,ans.address)
	    	end	
	    end

	    ip_cache:set(ip_list_cache_key,ip_list,cache_time)
	    return ip_list
	end

return _M