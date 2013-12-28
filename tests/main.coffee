#!/usr/bin/env coffee
v = 78
console.log "The value of v is '#{v}'"



test_net_request = ->
    "123"
console.log test_net_request()


# http = require('http')
# 
# 
# 
# http
#   .get 'http://localhost/blog/archives-404/', (resp)->
#       console.log "response: #{resp.statusCode}"
#       resp.on 'data', (chunk) ->
#           console.log chunk   
#   .on "error", (e) ->
#         console.log e

api = require("../src/qqapi")

api.check_qq '123774072'