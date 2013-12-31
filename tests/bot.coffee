#!/usr/bin/env coffee

# qqbot相关的测试代码
int = (v) -> parseInt v
log = console.log
jsons = JSON.stringify

auth = require "../src/qqauth"
api  = require "../src/qqapi"
QQBot  = require "../src/qqbot"
defaults = require '../src/defaults'

config = require '../config'
qq = config.account 
pass = config.password

# 设置登录信息
api.cookies defaults.data 'cookie'
auth_opts = defaults.data 'auth'
###
auth_opts ={
    psessionid
    clientid
    ptwebqq
    uin
    vfwebqq
}
###


bot = new QQBot( api.cookies(), auth_opts ,config )


api.get_buddy_list auth_opts, (ret,e)->
    log e  if e
    log 'friend',jsons ret
    log ''
    bot.save_buddy_info ret.result if ret.retcode == 0
    

api.get_group_list auth_opts, (ret , e)->
    log e  if e
    log 'group',jsons ret
    log ''
    if ret.retcode == 0
      bot.save_group_info ret.result 
      bot.update_group_member({name:"qqbot群"})

    
api.long_poll auth_opts, (ret,e)->
    log e if e
    log jsons ret
    bot.handle_poll_responce(ret) 