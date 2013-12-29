#!/usr/bin/env coffee

int = (v) -> parseInt v
log = console.log
api = require("../src/qqapi")


log "testing..."

config = require '../config'
qq = config.account 
pass = config.password


test_check_qq = ->
    api.check_qq '123774072' , (result) ->
        log int result[0]
        log result[1]
        log result[2]


test_encode_password = ->
    log api.encode_password(pass,"!PYL",'\\x00\\x00\\x00\\x00\\x07\\x60\\xa4\\x78')
    # should equal to 7BB648B45C561A5F986DECCD94644A3E

test_login_full = ->

    log "验证帐号"
    api.check_qq qq , (result) ->
        log "验证帐号:", result
        is_need_verify_code = int result[0]
        if is_need_verify_code
            log "需要验证码 bye" 
            return
                
        new_pass = api.encode_password(pass,result[1],result[2])    
        log "生成加密密码" , new_pass 
        
        
        log "开始登录"
        api.login qq, new_pass , result[1], '', (ret)->
            log '登录结果'
            log ret

# test_check_qq()
# test_encode_password()
test_login_full()
