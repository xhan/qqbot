#!/usr/bin/env coffee

int = (v) -> parseInt v
log = console.log
auth = require "../src/qqauth"
api  = require "../src/qqapi"

config = require '../config'
qq = config.account 
pass = config.password

test_long_pull = ->
    api.defaults_read()

    psessionid = api.defaults 'psessionid' 
    client_id  = api.defaults 'clientid'   
    ptwebqq    = api.defaults 'ptwebqq'    
    uin        = api.defaults 'uin'
    vfwebqq    = api.defaults 'vfwebqq'

    log 'psessionid',psessionid 
    log 'client_id',client_id  
    log 'ptwebqq',ptwebqq    
    log 'uin',uin
    log 'vfwebqq',vfwebqq
    
    log "长轮训"
    api.long_poll client_id , psessionid , (ret)->
        log ret
    
test_long_pull()    