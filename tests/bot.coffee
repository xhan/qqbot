#!/usr/bin/env coffee
# qqbot相关的测试代码

log = new (require 'log')('debug')
jsons = JSON.stringify


api  = require "../src/qqapi"
QQBot  = require "../src/qqbot"
defaults = require '../src/defaults'

config = require '../config'


# 设置登录信息
cookies = defaults.data 'cookie'
auth_info = defaults.data 'auth'


bot = new QQBot(cookies,auth_info,config)
group = null


bot.listen_group "qqbot群" , (_group,error)->
                    
  log.info "enter long poll mode, have fun"
  bot.runloop()  

  group = _group
  group.on_message (content ,send, robot, message)->
    log.info 'received',content
    if content.match /^wow/
      send 'mom'
