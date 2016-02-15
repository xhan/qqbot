#!/usr/bin/env coffee
###
 QQBot 独立运行入口
 启动命令：./main.coffee (nologin)
 @params nologin - 跳过登录模块，方便调试和测试
###


log       = new (require 'log')('debug')
auth      = require "./src/qqauth_qrcode"
api       = require "./src/qqapi"
QQBot     = require "./src/qqbot"
defaults  = require './src/defaults'
config    = require './config'

KEY_COOKIES = 'qq-cookies'
KEY_AUTH    = 'qq-auth'

###
# 获取接口需要的cookie和token
# @param isneedlogin : 是否需要登录，or本地获取
# @param options     : 配置文件涉及的内容
# @callback (cookies,auth_info)
###
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
  "start qqbot..."
  params = process.argv.slice(-1)[0] or ''
  isneedlogin = params.trim() isnt 'nologin'
  get_tokens isneedlogin , config , (cookies,auth_info)->
    bot = new QQBot(cookies,auth_info,config)
    
    # if config.keepalive 
    bot.on_die -> run() if isneedlogin
      
    bot.update_all_members (ret)->
      unless ret
        log.error "获取信息失败"
        process.exit(1)

      console.log "Group List:"
      console.log "    #{v.name} (#{v.gid})" for k, v of bot.group_info.gnamelist

      console.log "Buddy List:"
      console.log "    #{v.nick} (#{v.uin})" for k, v of bot.buddy_info.info

      log.info "Entering runloop, Enjoy!"
      bot.runloop()

run()
