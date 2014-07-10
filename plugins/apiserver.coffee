###
 QQBot Api Plugin
 ----------------
 通过HTTP API 方式和QQBot通信
 
 配置依赖：config.yaml
   api_port:  3000
   api_token: '' 设置为 '' 为不需要密码
 
 请求：GET/POST 方法都支持， 参数中token为必备字段
   exp:  GET api/reload_plugin?token=values

 返回：JSON { err:0 , msg:'error msg' } 
   err:0 为成功响应，否则请看错误信息
  
 
 接口：
 ----------------
  1. 发送消息 /send
    type = [buddy,group,discuss]
    to   = 目标名字(不支持空格)
    msg  = 消息文本

  2. 发送图片验证码  /stdin
    value = 验证码

  3. 重新加载插件 /reload

###


URL   = require 'url'
http  = require('http')
jsons = JSON.stringify
log   = new (require 'log')('debug')
querystring = require('querystring')


# 处理post的信息，来自网络
processPost = (request, response, callback) ->
    queryData = ""
    return null if typeof callback isnt 'function'
    request.on 'data', (data)->
      queryData += data
      if queryData.length > 1e6
        queryData = ""
        response.writeHead(413, {'Content-Type': 'text/plain'}).end();
        request.connection.destroy();

    request.on 'end', ->
      data = querystring.parse(queryData)
      callback(data)

    request.on 'error', (error)->
      callback(null, error)


class APIServer
  constructor:(@qqbot)->
    config = @qqbot.config
    @http_server = null
    [@port, @token] = [config.api_port, config.api_token]

  start: ->
    @http_server = @create_server(@port)
  stop: ->
    @http_server.close() if @http_server
    @http_server = null
    log.info "aip server stoped"
    
  create_server: (port)->
    server = http.createServer (req, res) =>
      log.debug '[api]' , req.url
      url = URL.parse req.url
      path = url.pathname
      if req.method == 'POST'
        processPost req, res, (body) =>
          @handle_request(req, res, path, body)
      else if req.method == 'GET'
        query = querystring.parse url.query
        @handle_request(req, res, path, query)

    server.listen port
    log.info 'api server started at port',port
    return server
  
  
  handle_request: (req,res,path,params)->
    res.endjson = (dict={})->
      ret_dict =
        err: 0
        msg: 'ok'
      for key,value of dict
        ret_dict[key] = value

      res.writeHead 200
      res.end jsons ret_dict

    if @token and params.token isnt @token
      res.endjson {err:503,msg:'token failed'}
      return

    func =
      switch path
        when '/stdin' then @on_stdin(req, res, params)
        when '/send'  then @on_sendmsg(req, res, params)
        when '/reload'then @on_reload_plugin(req, res, params)
        else res.endjson {err:404,msg:'request not fits'}


  on_stdin : (req,res,params)->
    value = params.value.trim()
    log.info 'stdin value',value
    process.emit 'data', value
    res.endjson()

  on_reload_plugin : (req,res,params)->
    res.endjson {err:1, msg:"method unimplemented"}
  
  on_sendmsg : (req,res,params)->
    log.info "will send #{params.type} #{params.to} : #{params.msg}"
    if params.type == 'buddy'
      msg =  "unimplement type #{params.type}"
      log.warning msg
      res.endjson {err:100,msg:msg}
      
    else if params.type == 'group'
      group = @qqbot.get_group {name:params.to}
      @qqbot.send_message_to_group group, params.msg, (ret,e)->
        resp_ret = {result:ret}
        if e
          resp_ret.err = 1
          resp_ret.msg = "#{e}"
        res.endjson resp_ret

    else if params.type == 'discuss'
      discuss_group = @qqbot.get_dgroup {name:params.to}
      unless discuss_group
        res.endjson {err:501, msg:"can't find discuss by name #{params.to}"}
        return
      @qqbot.send_message_to_discuss discuss_group.did, params.msg, (ret,e)->
        resp_ret = {result:ret}
        if e
          resp_ret.err = 1
          resp_ret.msg = "#{e}"
        res.endjson resp_ret


    else
      msg =  "unimplement type #{params.type}"
      log.warning msg
      res.endjson {err:100,msg:msg}


################################################
# QQBot Plugin 接口
api_server = null
exports.init = (qqbot)->  
  api_server = new APIServer(qqbot)
  api_server.start();

exports.stop = (qqbot)->
  api_server.stop()
    
