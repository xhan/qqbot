https = require "https"
http  = require 'http'
crypto = require 'crypto'
querystring  = require 'querystring'
Url = require('url')
all_cookies = []

md5 = (str) ->
    md5sum = crypto.createHash 'md5'
    md5sum.update(str).digest('hex')

# TODO: logger 分级控制
log   = console.log

exports.cookies = (cookie)->
    all_cookies = cookie if cookie
    return all_cookies

# 长轮训，默认一分钟
# r:	{"clientid":"25837476","psessionid":"8368046764001d636f6e6e7365727665725f77656271714031302e3133392e372e31363000007190000001d4036e040018ed13a56d0000000a4041353967594271316a6d000000285fad9f4675c403717de10022eb43ebc95a147b5fa5bf1f24efcbf8f07f40c7f58cd3a3bca74b10ae","key":0,"ids":[]}
# psessionid : id
# clientid:    id
# 
long_poll = (client_id, psessionid, callback) ->
    log "polling..."
    url = Url.parse "http://d.web2.qq.com/channel/poll2"
    r =
        clientid: "#{client_id}",
        psessionid: psessionid,
        key:0,
        ids:[]
    r = JSON.stringify(r)
    
    data = querystring.stringify {
        clientid: client_id,
        psessionid: psessionid,
        r: r
    }
        
    body = ''
    options = 
        host: url.host,
        path: url.path,
        method: 'POST',
        headers: 
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:27.0) Gecko/20100101 Firefox/27.0',
            'Referer': 'http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3',
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Content-Length': Buffer.byteLength(data),
            'Cookie' : all_cookies
    
    req = http.request options, (resp) ->
        log "response: #{resp.statusCode}"
        resp.on 'data', (chunk) ->
            body += chunk
        resp.on 'end', ->
            ret = JSON.parse(body)
            callback( ret )
            long_poll(client_id , psessionid , callback)
    req.write(data);
    req.end();
    
exports.long_poll = long_poll





