#!/usr/bin/env coffee

# qqbot相关的测试代码
int = (v) -> parseInt v
log = console.log
jsons = JSON.stringify

auth = require "../src/qqauth"
api  = require "../src/qqapi"
QQBot  = require "../src/qqbot"

config = require '../config'
qq = config.account 
pass = config.password


api.defaults_read()

psessionid = api.defaults 'psessionid' 
clientid  = api.defaults 'clientid'   
ptwebqq    = api.defaults 'ptwebqq'    
uin        = api.defaults 'uin'
vfwebqq    = api.defaults 'vfwebqq'

auth_opts ={
    psessionid
    clientid
    ptwebqq
    uin
    vfwebqq
}

bot = new QQBot("叫我小可爱")

api.get_buddy_list auth_opts, (ret,e)->
    log e  if e
    log 'friend',ret
    log ''
    bot.save_buddy_info ret.result if ret.retcode == 0
    

api.get_group_list auth_opts, (ret , e)->
    log e  if e
    log 'group',ret
    log ''
    bot.save_group_info ret.result if ret.retcode == 0
    
api.long_poll auth_opts, (ret,e)->
    log e if e
    log ret
    bot.handle_poll_responce(ret) 