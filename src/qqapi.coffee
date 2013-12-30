https = require "https"
http  = require 'http'
crypto = require 'crypto'
querystring  = require 'querystring'
Url = require('url')
all_cookies = []
defaults    = {}
fs = require 'fs'
jsons = JSON.stringify
client = require './httpclient'

md5 = (str) ->
    md5sum = crypto.createHash 'md5'
    md5sum.update(str).digest('hex')

# TODO: logger 分级控制
log   = console.log

exports.cookies = (cookie)->    
    if cookie
        all_cookies = cookie 
        client.global_cookies(all_cookies)
    return all_cookies

exports.defaults = (key,value)-> 
    if key and value
        defaults[key] = value
    else if key
        defaults[key]
    else
        defaults

exports.defaults_save = ->
    defaults.cookie = all_cookies
    fs.writeFileSync 'tmp/store.json' ,  jsons(defaults)

exports.defaults_read = ->
    try
        defaults = JSON.parse( fs.readFileSync  'tmp/store.json' )
        all_cookies  = defaults.cookie
        client.global_cookies(all_cookies)
    catch error
        log error        


# 长轮训，默认一分钟
#  @param : [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 102，正常空消息
long_poll = (auth_opts, callback) ->
    log "polling..."
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
    
    client.post {url:url} , params , (ret,e)->
        long_poll( auth_opts , callback )
        callback(ret,e)
            
exports.long_poll = long_poll

# http://0.web.qstatic.com/webqqpic/pubapps/0/50/eqq.all.js
# uin, ptwebqq
hash_func = 
`
function(b, i) {
                for (var a = [], s = 0; s < i.length; s++) a[s % 4] ^= i.charCodeAt(s);
                var j = ["EC", "OK"],
                    d = [];
                d[0] = b >> 24 & 255 ^ j[0].charCodeAt(0);
                d[1] = b >> 16 & 255 ^ j[0].charCodeAt(1);
                d[2] = b >> 8 & 255 ^ j[1].charCodeAt(0);
                d[3] = b & 255 ^ j[1].charCodeAt(1);
                j = [];
                for (s = 0; s < 8; s++) j[s] = s % 2 == 0 ? a[s >> 1] : d[s >> 1];
                a = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
                d = "";
                for (s = 0; s < j.length; s++) d += a[j[s] >> 4 & 15], d += a[j[s] & 15];
                return d
}
`


#  @param uin     : 登录后获得
#  @param ptwebqq : cookie
#  @param vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
exports.get_buddy_list = (auth_opts, callback)->
    opt = auth_opts
    url = "http://s.web2.qq.com/api/get_user_friends2"
    r = 
      h: "hello"
      hash: hash_func(opt.uin, opt.ptwebqq)
      vfwebqq: opt.vfwebqq

    client.post {url:url} , {r:jsons(r)} , (ret,e )->
        callback(ret,e)


#  @param auth_opts vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
exports.get_group_list = ( auth_opts, callback)->
    aurl = "http://s.web2.qq.com/api/get_group_name_list_mask2"    
    r    = vfwebqq:  auth_opts.vfwebqq
    
    client.post {url:aurl} , {r:jsons(r)} , (ret, e )->
            callback(ret,e) 


#  @param group_code: code
#  @param auth_opts vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
exports.get_group_member = (group_code, auth_opts, callback)->
    url = "http://s.web2.qq.com/api/get_group_info_ext2"
    url += "?gcode=#{group_code}&cb=undefined&vfwebqq=#{auth_opts.vfwebqq}&t=#{new Date().getTime()}"
    client.get {url:url}, (ret,e)->
        callback(ret,e)
    

#  @param to_uin: uin
#  @param msg, 消息
#  @param auth_opts: [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 0    
exports.send_msg_2buddy = (to_uin , msg , auth_opts ,callback)->    
    url = "http://d.web2.qq.com/channel/send_buddy_msg2"    
    opt = auth_opts
    r = 
      to: to_uin
      face: 0
      msg_id: 1000001 #随机msgid
      clientid: "#{opt.clientid}"
      psessionid: opt.psessionid        
      content: jsons ["#{msg}" , ["font", {name:"宋体", size:"10", style:[0,0,0], color:"000000" }] ]
        
    params = 
        r: jsons r
        clientid: opt.clientid
        psessionid: opt.psessionid

    # log params
    client.post {url:url} , params , (ret,e) ->
        callback( ret , e )
    
#  @param gid: gid
#  @param msg, 消息
#  @param auth_opts: [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 0    
exports.send_msg_2group = (gid, msg , auth_opts, callback)->
    url = 'http://d.web2.qq.com/channel/send_qun_msg2'
    opt = auth_opts
    r = 
      group_uin:  gid
      msg_id:     1000001   #随机msgid
      clientid:   "#{opt.clientid}"
      psessionid: opt.psessionid
      content:    jsons ["#{msg}" , ["font", {name:"宋体", size:"10", style:[0,0,0], color:"000000" }] ]
    params =
        r:         jsons r
        clientid:  opt.clientid
        psessionid:opt.psessionid
    client.post {url:url} , params , (ret,e)->
        callback(ret,e)
        
    