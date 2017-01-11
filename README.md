# easyresolver

**easyresolver** is an dns resolver for ngx_lua based on resty.dns.resolver and resty.lrucache.you can easily resolve domain and get the ip list.ip list default cached 600 secends by LRUCache. easyresolver only supports unix like system,eg: Linux，mac OS.

1.git clone code easyresolver.lua from https://github.com/wumeng/easyresolver.git.

2.copy easyresolver.lua file to your openresty library path.

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
---
---

**easyresolver** 是一个DNS解析器,基于resty.dns.resolver和resty.lrucache两个OpenResty的默认模块实现。你可以使用easyresolver很方便的解析域名获取这个域名的ip地址,域名解析的结果默认缓存10分钟，缓存使用LRUCache。easyresolver目前只支持类unix的系统，如：linux 、mac OS。

1、下载或从github clone代码 https://github.com/wumeng/easyresolver.git

2、将easyresolver.lua文件拷贝到你的OpenResty的resty库目录，（默认目录是：/usr/local/openresty/lualib/resty/）

``` shell
  cp easyresolver.lua /usr/local/openresty/lualib/resty/
```  
3、使用方法如下：

``` lua
-- require easyresolver module
local easyresolver = require "resty.reasyresolver"

-- resolver domain and return ip list table
local ip_list = easyresolver.getDomainIpList("www.google.com")

ngx.say(ip_list)
``` 