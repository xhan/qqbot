#!/usr/bin/env coffee

int = (v) -> parseInt v
log = console.log
api = require("../src/qqapi")


log "testing..."





test_check_qq = ->
    api.check_qq '123774072' , (result) ->
        log int result[0]
        log result[1]
        log result[2]


test_encode_password = ->
    log api.encode_password("123","!GZH",'\\x00\\x00\\x00\\x00\\x07\\x60\\xa4\\x78')

# test_check_qq()
test_encode_password()



