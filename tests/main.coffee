#!/usr/bin/env coffee
v = 78
console.log "The value of v is '#{v}'"



test_net_request = ->
    "123"
console.log test_net_request()


http = require('http')
# test net request
http.get "http://www.baidu.com", (res) ->
    console.log "response: #{res.statusCode}"
    
