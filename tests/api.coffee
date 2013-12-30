#!/usr/bin/env coffee

# api相关的测试代码
int = (v) -> parseInt v
log = console.log
auth = require "../src/qqauth"
api  = require "../src/qqapi"

config = require '../config'
qq = config.account 
pass = config.password

test_api = ->
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


    
    api.get_friend_list uin, ptwebqq, vfwebqq, (ret,e)->
        log 'friend',ret
        log ''
    
    api.get_group_list vfwebqq, (ret , e)->
        log 'group',ret
        log ''
    

    # api.get_group_member 86784314, vfwebqq , (ret,e)->
    #     log 'group_member' , ret
    #     log ''
    
    # api.send_msg_2buddy 2440652742, "你好啊" , auth_opts, (ret,e)->
    #     log "buddy send ret:",ret
    
    # api.send_msg_2group 2559225925, "系统提示：hahha" , auth_opts, (ret,e)->
    #     log "group send ret:",ret
        
    # log "长轮训"
    # api.long_poll auth_opts , (ret)->
    #     log ret
    
test_api()    
