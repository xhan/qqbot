###
  # 设置api server
  apiserver.run(config['api-port'], config['api-token'])

      apiserver.on_groupmessage (name,message,res)->
        group = bot.get_group {name:name}
        bot.send_message_to_group group, message, (ret,e)->
          resp_ret = {bot:ret}
          if e
            resp_ret.err = 1
            resp_ret.msg = "#{e}"
          res.endjson resp_ret
###



###
  QQBot的API Server，支持通过http方式调用Bot功能
  注意：响应 http get/post 参数可设置在url query 或 http body ，两者选其一。 token为必备字段

  @发送消息                /send   type    = [buddy,group]
                                  to  = 目标名字
                                  msg  = 消息(文本)

  @发送STDIN(图片验证码)      /stdin {value = 需要传入的stdin值}

  @更新插件  /reload

  返回值 JSON
  {
    err:0
    msg:'error msg'
  }
###


URL   = require 'url'
http  = require('http')
jsons = JSON.stringify
log   = new (require 'log')('debug')
querystring = require('querystring')

#global variables
server = null
config_token = null
config_port  = null
cb_sendmessage = null

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
      callback(post)

    request.on 'error', (error)->
      callback(null, error)

on_stdin = (req,res,params)->
  value = params.value.trim()
  log.info 'stdin value',value
  process.emit 'data', value
  res.endjson()

on_sendmsg = (req,res,params)->
  log.info "will send #{params.type} #{params.to} : #{params.msg}"
  if params.type == 'buddy'
    msg =  "unimplement type #{params.type}"
    log.warning msg
    res.endjson {err:100,msg:msg}
  else if params.type == 'group'
      cb_sendmessage params.to, params.msg, res
  else
    msg =  "unimplement type #{params.type}"
    log.warning msg
    res.endjson {err:100,msg:msg}

on_reload_plugin = (req,res,params)->
  res.endjson {err:1, msg:"method unimplemented"}

handle_request = (req,res,path,params)->
  res.endjson = (dict={})->
    ret_dict =
      err: 0
      msg: 'ok'
    for key,value of dict
      ret_dict[key] = value

    res.writeHead 200
    res.end jsons ret_dict

  if config_token and params.token isnt config_token
    res.endjson {err:503,msg:'token failed'}
    return

  switch path
    when '/stdin' then on_stdin(req,res,params)
    when '/send'  then on_sendmsg(req,res,params)
    when '/reload'then on_reload_plugin(req,res,params)


create_server = (port)->
  server = http.createServer (req, res) ->
    log.debug '[api]' , req.url
    url = URL.parse req.url
    path = url.pathname
    if req.method == 'POST'
      processPost req, res, (body)->
        handle_request(req, res, path, body)
    else if req.method == 'GET'
      query = querystring.parse url.query
      handle_request(req, res, path, query)

  server.listen port
  log.info 'api server started at port',port


exports.run = (port,token)->
  config_port  = port or 3000
  config_token = token
  create_server config_port

exports.stop = ->
  server.close() if server
  server = null

# @callback group_name, message, res
# need call res.endjson {} to finish request
exports.on_groupmessage = (callback)->
  cb_sendmessage = callback
