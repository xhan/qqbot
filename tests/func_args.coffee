#!/usr/bin/env coffee


# 2 ways to call it
# url, params, callback or
# url, callback
# 
http_get  = (args...) ->
  [url,params,callback] = args
  [params,callback] = [null,params] unless callback
  console.log url
  console.log params
  console.log callback



http_get(1,2,3)