###
  QQAPI 包含获取好友，群信息，发送消息，长轮询
  - 使用前需要设置 cookies()
###



all_cookies = []
fs = require 'fs'
jsons = JSON.stringify
client = require './httpclient'
log   = new (require 'log')('debug')

msg_id = 43690001 # 随机消息id，每次操作后需要增加
# 49760001



# 设置client cookie
#
cookies = (cookie)->
  if cookie
    all_cookies = cookie
    client.global_cookies(all_cookies)
  return all_cookies


###
# 长轮询，默认一分钟
#  @param : [clientid,psessionid]
#  @param callback: ret, e  callback 返回值 true 才会循环 loop poll
#  @return ret retcode 102，正常空消息
###
long_poll = (auth_opts, callback) ->
  log.debug "polling..."
  [clientid, psessionid, ptwebqq, uin, vfwebqq] = [auth_opts.clientid, auth_opts.psessionid, auth_opts.ptwebqq, auth_opts.uin, auth_opts.vfwebqq]
  url = "http://d.web2.qq.com/channel/poll2"
  r =
    ptwebqq: "#{ptwebqq}"
    clientid: "#{clientid}"
    psessionid: "#{psessionid}"
    key: ""
  params =
    r: jsons r
  log.debug "params: #{params.r}"
  client.post {url:url} , params , (ret,e)->
    need_next_runloop = callback(ret,e)
    long_poll( auth_opts , callback ) if need_next_runloop


# http://0.web.qstatic.com/webqqpic/pubapps/0/50/eqq.all.js
# uin, ptwebqq
hash_func =
`
function(x, K) {
  x += "";
  for (var N = [], T = 0; T < K.length; T++) N[T % 4] ^= K.charCodeAt(T);
  var U = ["EC", "OK"],
  V = [];
  V[0] = x >> 24 & 255 ^ U[0].charCodeAt(0);
  V[1] = x >> 16 & 255 ^ U[0].charCodeAt(1);
  V[2] = x >> 8 & 255 ^ U[1].charCodeAt(0);
  V[3] = x & 255 ^ U[1].charCodeAt(1);
  U = [];
  for (T = 0; T < 8; T++) U[T] = T % 2 == 0 ? N[T >> 1] : V[T >> 1];
  N = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
  V = "";
  for (T = 0; T < U.length; T++) {
    V += N[U[T] >> 4 & 15];
    V += N[U[T] & 15]
  }
  return V
}
`

################################################################################
#  好友

#  @param uin     : 登录后获得
#  @param ptwebqq : cookie
#  @param vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
get_buddy_list = (auth_opts, callback)->
  opt = auth_opts
  url = "http://s.web2.qq.com/api/get_user_friends2"
  r =
    hash: hash_func(opt.uin, opt.ptwebqq)
    vfwebqq: opt.vfwebqq
  client.post {url:url} , {r:jsons(r)} , (ret,e )->
    callback(ret,e)

#  @param tuin:      uin or gid
#  @param type:      获取 QQ 号码用 1 , 获取群号码用 4
#  @param auth_opts: [clientid,psessionid]
#  @param callback:  ret, e
#  retcode 0
get_friend_uin2 = (tuin, type, auth_opts, callback)->
  opt = auth_opts
  url = "http://s.web2.qq.com/api/get_friend_uin2"
  params =
    tuin: tuin
    type: type
    vfwebqq: opt.vfwebqq
    t: new Date().getTime()

  client.get url, params, (ret,e)->
    callback(ret, e)

#  @param to_uin: uin
#  @param msg, 消息
#  @param auth_opts: [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 0
send_msg_2buddy = (to_uin , msg , auth_opts ,callback)->
  url = "http://d.web2.qq.com/channel/send_buddy_msg2"
  opt = auth_opts
  r =
    to: to_uin
    face: 0
    msg_id: msg_id++
    clientid: "#{opt.clientid}"
    psessionid: opt.psessionid
    content: jsons ["#{msg}", ["font", {name:"宋体", size:"10", style:[0,0,0], color:"000000" }] ]

  params =
    r: jsons r

  # log params
  client.post {url:url} , params , (ret,e) ->
    log.debug 'send2user',jsons ret
    callback(ret , e) if callback

################################################################################
#  临时消息

#  @param to_uin: uin
#  @param msg, 消息
#  @param auth_opts: [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 0
send_msg_2sess = (to_gid , to_uin , msg , auth_opts ,callback)->
  opt = auth_opts

  url = "http://d.web2.qq.com/channel/get_c2cmsg_sig2?id="+to_gid+"&to_uin="+to_uin+"&clientid="+opt.clientid+"&psessionid="+opt.psessionid+"&service_type=0&t="+new Date().getTime()

  client.get url , (ret,e) ->
    if !e
      url = "http://d.web2.qq.com/channel/send_sess_msg2"

      r =
      to: to_uin
      face: 594
      msg_id: msg_id++
      clientid: "#{opt.clientid}"
      psessionid: opt.psessionid
      group_sig: ret.result.value
      content: jsons ["#{msg}", ["font", {name:"宋体", size:"10", style:[0,0,0], color:"000000" }] ]

      params =
      r: jsons r

      # log params
      client.post {url:url} , params , (ret,e) ->
        log.debug 'send2user',jsons ret
        callback(ret , e) if callback

################################################################################
#  群

#  获取群列表
#  @param auth_opts vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
get_group_list = ( auth_opts, callback)->
  aurl = "http://s.web2.qq.com/api/get_group_name_list_mask2"
  r    =
    vfwebqq:  auth_opts.vfwebqq
    hash: hash_func(auth_opts.uin, auth_opts.ptwebqq)

  client.post {url:aurl} , {r:jsons(r)} , (ret, e )->
    callback(ret,e) if callback


#  @param group_code: code
#  @param auth_opts vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
get_group_member = (group_code, auth_opts, callback)->
  url = "http://s.web2.qq.com/api/get_group_info_ext2"
  params =
    gcode : group_code
    vfwebqq: auth_opts.vfwebqq
    t     : new Date().getTime()
  client.get url, params, callback


#  @param gid: gid
#  @param msg, 消息
#  @param auth_opts: [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 0
send_msg_2group = (gid, msg , auth_opts, callback)->
  url = 'http://d.web2.qq.com/channel/send_qun_msg2'
  opt = auth_opts
  r =
    group_uin:  gid
    content:    jsons ["#{msg}" , ["font", {name:"宋体", size:10, style:[0,0,0], color:"000000" }] ]
    face: 573
    clientid:   "#{opt.clientid}"
    msg_id:     msg_id++
    psessionid: opt.psessionid
  params =
    r:         jsons r
  client.post {url:url} , params , (ret,e)->
    log.debug 'send2group',jsons ret
    callback(ret,e) if callback


################################################################################
#  讨论组


get_discuss_list = (auth_opts, callback)->
  url = "http://s.web2.qq.com/api/get_discus_list"
  params =
    clientid: auth_opts.clientid
    psessionid: auth_opts.psessionid
    vfwebqq: auth_opts.vfwebqq
    t: new Date().getTime()

  client.get url, params, callback

# @discuss_id 讨论组id (did)
get_discuss_member = (discuss_id, auth_opts, callback)->
  url = "http://d.web2.qq.com/channel/get_discu_info"
  params =
    did: discuss_id
    clientid: auth_opts.clientid
    psessionid: auth_opts.psessionid
    vfwebqq: auth_opts.vfwebqq
    t: new Date().getTime()
  client.get url, params , callback

send_msg_2discuss = (discuss_id, msg, auth_opts, callback)->
  url = "http://d.web2.qq.com/channel/send_discu_msg2"
  opt = auth_opts
  r =
    did:  "#{discuss_id}"   #字符串
    msg_id:     msg_id++
    face: 573
    clientid:   "#{opt.clientid}"
    psessionid: opt.psessionid
    content:    jsons ["#{msg}" , ["font", {name:"宋体", size:10, style:[0,0,0], color:"000000" }] ]
  params =
    r:         jsons r
    clientid:  opt.clientid
    psessionid:opt.psessionid

  client.post {url:url} , params , (ret,e)->
    log.debug 'send2discuss',jsons ret
    callback(ret,e) if callback


change_status = (status, auth_opts, callback)->
  # nothing


module.exports = {
  cookies
  long_poll
  get_buddy_list
  get_friend_uin2
  send_msg_2buddy
  send_msg_2sess
  get_group_list
  get_group_member
  send_msg_2group
  get_discuss_list
  get_discuss_member
  send_msg_2discuss
}
