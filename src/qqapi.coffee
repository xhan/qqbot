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
    all_cookies = cookie if cookie
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
        # 设置httpclient cookie
        client.global_cookies(all_cookies)
    catch error
        log error        

# 长轮训，默认一分钟
# r:	{"clientid":"25837476","psessionid":"8368046764001d636f6e6e7365727665725f77656271714031302e3133392e372e31363000007190000001d4036e040018ed13a56d0000000a4041353967594271316a6d000000285fad9f4675c403717de10022eb43ebc95a147b5fa5bf1f24efcbf8f07f40c7f58cd3a3bca74b10ae","key":0,"ids":[]}
# psessionid : id
# clientid:    id
# 
long_poll = (client_id, psessionid, callback) ->
    log "polling..."
    aurl = Url.parse "http://d.web2.qq.com/channel/poll2"
    r =
        clientid: "#{client_id}"
        psessionid: psessionid
        key:0
        ids:[]
    
    data = querystring.stringify {
        clientid: client_id,
        psessionid: psessionid,
        r: jsons r
    }
        
    body = ''
    options = 
        host: aurl.host
        path: aurl.path
        method: 'POST'
        headers: 
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:27.0) Gecko/20100101 Firefox/27.0'
            'Referer': 'http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3'
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            'Content-Length': Buffer.byteLength(data)
            'Cookie' : all_cookies
    
    req = http.request options, (resp) ->
        log "response: #{resp.statusCode}"
        resp.on 'data', (chunk) ->
            body += chunk
        resp.on 'end', ->
            log body
            ret = JSON.parse(body)
            callback( ret )
            long_poll(client_id , psessionid , callback)
    req.on "error" , (e)->
        log e
        long_poll(client_id , psessionid , callback)
    req.write(data);
    req.end();
    
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
exports.get_friend_list = (uin, ptwebqq, vfwebqq, callback)->
    aurl = "http://s.web2.qq.com/api/get_user_friends2"
    r = 
      h: "hello"
      hash: hash_func(uin, ptwebqq)
      vfwebqq: vfwebqq

    client.post {url:aurl} , {r:jsons(r)} , (ret,e )->
        callback(ret,e)


#  @param vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
exports.get_group_list = ( vfwebqq, callback)->
    aurl = "http://s.web2.qq.com/api/get_group_name_list_mask2"    
    r    = vfwebqq:  vfwebqq     
    r    = JSON.stringify r
    
    client.post {url:aurl} , {r:r} , (ret,e )->
        callback(ret,e)

#  @param group_code: code
#  @param vfwebqq : 登录后获得
#  @param callback: ret, e
#  retcode 0
exports.get_group_member = (group_code, vfwebqq, callback)->
    url = "http://s.web2.qq.com/api/get_group_info_ext2"
    url += "?gcode=#{group_code}&cb=undefined&vfwebqq=#{vfwebqq}&t=#{new Date().getTime()}"
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
    
#  @param group_code: gid
#  @param msg, 消息
#  @param auth_opts: [clientid,psessionid]
#  @param callback: ret, e
#  @return ret retcode 0    
exports.send_msg_2group = (group_code, msg , auth_opts, callback)->
    url = 'http://d.web2.qq.com/channel/send_qun_msg2'
    opt = auth_opts
    r = 
      group_uin:  group_code
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
        
    