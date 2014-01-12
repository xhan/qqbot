#!/usr/bin/env coffee
###
 QQBot 独立运行入口
 启动命令：./main.coffee (nologin)
 @params nologin - 跳过登录模块，方便调试和测试
###


log       = new (require 'log')('debug')

auth      = require "./src/qqauth"
api       = require "./src/qqapi"
apiserver = require "./src/apiserver"
QQBot     = require "./src/qqbot"
defaults  = require './src/defaults'
config    = require './config'

KEY_COOKIES = 'qq-cookies'
KEY_AUTH    = 'qq-auth'


# 获取接口需要的cookie和token
# @param isneedlogin : 是否需要登录，or本地获取
# @param options     : 配置文件涉及的内容
# @callback (cookies,auth_info)
get_tokens = (isneedlogin, options,callback)->

  if isneedlogin
    auth.login options , (cookies,auth_info)->
      defaults.data KEY_COOKIES, cookies
      defaults.data KEY_AUTH   , auth_info
      defaults.save()
      callback(cookies,auth_info)
  else
    cookies = defaults.data KEY_COOKIES
    auth_info = defaults.data KEY_AUTH
    log.info "skip login"
    callback(cookies , auth_info )

# 启动bot
# 获取好友，群，群成员信息，然后进入守护模式
# TODO: 获取信息 + 守护模式 同步状态
run = ->
  # 设置api server
  apiserver.run(config['api-port'], config['api-token'])
  
  isneedlogin = process.argv.pop().trim() isnt 'nologin'    
  get_tokens isneedlogin , config , (cookies,auth_info)->
    bot = new QQBot(cookies,auth_info,config)

    bot.update_all_members (ret)->
      unless ret
        log.error "获取信息失败"
        process.exit(1)
      log.info "Entering runloop, Enjoy!"
      bot.runloop()
      
      apiserver.on_groupmessage (name,message,res)->
        group = bot.get_group {name:name}
        bot.send_message_to_group group, message, (ret,e)->
          resp_ret = {bot:ret}
          if e
            resp_ret.err = 1
            resp_ret.msg = "#{e}"
          res.endjson resp_ret
run()


# TODO: 有一定的概率导致不能发送部分消息，可能是 随机的clientID问题？ -> 修改了随机数范围