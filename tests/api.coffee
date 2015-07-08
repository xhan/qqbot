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
  # api.long_poll auth_opts , (ret)->
  #     log ret


  # api.get_buddy_list auth_opts , (ret,e)->
  #   log auth_opts
  #   log 'friend',jsons ret
  #   log ''

  # api.get_friend_uin2 2967661734, 1, auth_opts, (ret, e) ->
  #   log 'get_friend_uin', ret

  # api.get_friend_uin2 1093099923, 4, auth_opts, (ret, e) ->
  #   log 'get group uin: ', ret

  # api.get_group_list auth_opts, (ret , e)->
  #   log "get_group_list: #{jsons ret}"
  #   log ''


  # api.get_group_member 1783828783, auth_opts , (ret,e)->
  #     log 'group_member' , ret
  #     log ''

  # api.send_msg_2buddy 2967661734, "Hello, world!#{Math.random()}" , auth_opts, (ret,e)->
  #   log "buddy send ret:",ret

  api.send_msg_2group 3600594460, "庆贺一郎 #{new Date()}" , auth_opts, (ret,e)->
    log "group send ret:",ret

  # api.get_discuss_list auth_opts, (ret, e) ->
  #   log "get_discuss_list: #{jsons ret}"
  #   log ''

  # api.get_discuss_member 979158546, auth_opts, (ret, e) ->
  #     log "get_discuss_member: #{jsons ret}"
  #     log ""

  # api.send_msg_2discuss 979158546, "hello", auth_opts, (ret, e) ->
  #     log "send_msg_2discuss: #{jsons ret}"
  #     log ""


test_api()
