#!/usr/bin/env coffee

# api相关的测试代码
int = (v) -> parseInt v
log = console.log
auth = require "../src/qqauth"
api  = require "../src/qqapi"

defaults = require '../src/defaults'
config = require '../config'
qq = config.account 
pass = config.password
jsons = JSON.stringify


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

test_api = ->
    # log "长轮训"
    api.long_poll auth_opts , (ret)->
        log ret

###    
    api.get_buddy_list auth_opts , (ret,e)->
        log 'friend',jsons ret
        log ''
    
    api.get_group_list auth_opts, (ret , e)->
        log 'group',ret
        log ''
###    

    # api.get_group_member 86784314, vfwebqq , (ret,e)->
    #     log 'group_member' , ret
    #     log ''
    
    # api.send_msg_2buddy 2440652742, "你好啊" , auth_opts, (ret,e)->
    #     log "buddy send ret:",ret
    
    # api.send_msg_2group 2559225925, "系统提示：hahha" , auth_opts, (ret,e)->
    #     log "group send ret:",ret
        

    
test_api()    
