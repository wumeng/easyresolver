# easyresolver

**easyresolver** is an dns resolver for ngx_lua based on resty.dns.resolver and resty.lrucache.you can easily resolve domain and get the ip list. easyresolver only supports unix like system,eg: Linux，mac OS.


git: https://github.com/wumeng/easyresolver.git


1.git clone code easyresolver.lua from https://github.com/wumeng/easyresolver.git

2.copy easyresolver.lua file to your openresty library path

``` shell
  cp easyresolver.lua /usr/local/openresty/lualib/resty/
```  
  
3.use easyresolver like this:

``` lua
-- require easyresolver module
local easyresolver = require "resty.reasyresolver"

-- resolver domain and return ip list table
local ip_list = easyresolver.getDomainIpList("www.google.com")

ngx.say(ip_list)
``` 
