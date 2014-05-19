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


# 长轮询，默认一分钟
#  @param : [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 102，正常空消息
long_poll = (auth_opts, callback) ->
    log.debug "polling..."
    [clientid, psessionid] = [auth_opts.clientid, auth_opts.psessionid]
    url = "http://d.web2.qq.com/channel/poll2"
    r =
        clientid: "#{clientid}"
        psessionid: psessionid
        key:0
        ids:[]
    params =
        clientid: clientid
        psessionid: psessionid
        r: jsons r

    client.post {url:url,debug:true} , params , (ret,e)->
        long_poll( auth_opts , callback )
        callback(ret,e)


# http://0.web.qstatic.com/webqqpic/pubapps/0/50/eqq.all.js
# uin, ptwebqq
hash_func =
`
function(i, a) {
  b = function(b, i) {
          this.s = b || 0;
          this.e = i || 0
  };

  var j = [];
  j[0] = i >> 24 & 255;
  j[1] = i >> 16 & 255;
  j[2] = i >> 8 & 255;
  j[3] = i & 255;
  for (var s = [], e = 0; e < a.length; ++e) s.push(a.charCodeAt(e));
  e = [];
  for (e.push(new b(0, s.length - 1)); e.length > 0;) {
    var c = e.pop();
    if (!(c.s >= c.e || c.s < 0 || c.e >= s.length))
      if (c.s + 1 == c.e) {
        if (s[c.s] > s[c.e]) {
          var J = s[c.s];
          s[c.s] = s[c.e];
          s[c.e] = J
        }
      } else {
        for (var J = c.s, l = c.e, f = s[c.s]; c.s < c.e;) {
          for (; c.s < c.e && s[c.e] >= f;) c.e--, j[0] = j[0] + 3 & 255;
          c.s < c.e && (s[c.s] = s[c.e], c.s++, j[1] = j[1] * 13 + 43 & 255);
          for (; c.s < c.e && s[c.s] <= f;) c.s++, j[2] = j[2] - 3 & 255;
          c.s < c.e && (s[c.e] = s[c.s], c.e--, j[3] = (j[0] ^ j[1] ^ j[2] ^ j[3] + 1) & 255)
        }
        s[c.s] = f;
        e.push(new b(J, c.s - 1));
        e.push(new b(c.s + 1, l))
      }
  }
  s = ["0", "1", "2", "3", "4",
    "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
  ];
  e = "";
  for (c = 0; c < j.length; c++) e += s[j[c] >> 4 & 15], e += s[j[c] & 15];
  return e
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
      h: "hello"
      hash: hash_func(opt.uin, opt.ptwebqq)
      vfwebqq: opt.vfwebqq

    client.post {url:url} , {r:jsons(r)} , (ret,e )->
        callback(ret,e)

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
        clientid: opt.clientid
        psessionid: opt.psessionid

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
    r    = vfwebqq:  auth_opts.vfwebqq

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
      cb    : 'undefined'
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
      msg_id:     msg_id++
      clientid:   "#{opt.clientid}"
      psessionid: opt.psessionid
      content:    jsons ["#{msg}" , ["font", {name:"宋体", size:"10", style:[0,0,0], color:"000000" }] ]
    params =
        r:         jsons r
        clientid:  opt.clientid
        psessionid:opt.psessionid
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
    clientid:   "#{opt.clientid}"
    psessionid: opt.psessionid
    content:    jsons ["#{msg}" , ["font", {name:"宋体", size:"10", style:[0,0,0], color:"000000" }] ]
  params =
      r:         jsons r
      clientid:  opt.clientid
      psessionid:opt.psessionid
      
  client.post {url:url} , params , (ret,e)->
      log.debug 'send2discuss',jsons ret
      callback(ret,e) if callback




module.exports = {
  cookies
  long_poll
  get_buddy_list
  send_msg_2buddy
  get_group_list
  get_group_member
  send_msg_2group
  get_discuss_list
  get_discuss_member
  send_msg_2discuss
}