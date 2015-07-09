# 剥离出来的 HttpClient ，目前仅适合 qqapi 使用
# 返回值：已经解析的json

https = require "https"
http  = require 'http'
querystring  = require 'querystring'
URL  = require('url')
jsons = JSON.stringify




# 设置全局cookie
all_cookies = []
global_cookies = (cookie)->
    all_cookies = cookie if cookie
    return all_cookies

# options url:url
#         method: GET/POST
#         debug:false
# @params 请求参数
# @callback( ret, error)  ret为json序列对象
http_request = (options , params , callback) ->
    aurl = URL.parse( options.url )
    options.host = aurl.host
    options.path = aurl.path
    options.headers ||= {}

    client =  if aurl.protocol == 'https:' then https else http
    body = ''
    if params and options.method == 'POST'
      data = querystring.stringify params
      options.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8'
      options.headers['Content-Length']= Buffer.byteLength(data)
    if params and options.method == 'GET'
      query = querystring.stringify params
      append = if aurl.query then '&' else '?'
      options.path += append + query

    options.headers['Cookie'] = all_cookies
    options.headers['Referer'] = 'http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3'

    req = client.request options, (resp) ->
      if options.debug
        console.log "response: #{resp.statusCode}"
        console.log "cookie: #{resp.headers['set-cookie']}"
      resp.on 'data', (chunk) ->
        body += chunk
      resp.on 'end', ->
        handle_resp_body(body, options, callback)

    req.on "error" , (e)->
        callback(null,e)

    if params and options.method == 'POST'
        req.write(data);
    req.end();

handle_resp_body = (body , options , callback) ->
    err = null
    try
        ret = JSON.parse body
    catch error
        console.log "解析出错", options.url, body
        console.log error
        err = error
        ret = null
    callback(ret,err)


# 2 ways to call it
# url, params, callback or
# url, callback
#
http_get  = (args...) ->
  [url,params,callback] = args
  [params,callback] = [null,params] unless callback
  options =
    method : 'GET'
    url    : url
  http_request( options , params , callback)

http_post = (options , body, callback) ->
    options.method = 'POST'
    http_request( options , body , callback)

# 导出方法
module.exports =
    global_cookies: global_cookies
    request: http_request
    get:     http_get
    post:    http_post
