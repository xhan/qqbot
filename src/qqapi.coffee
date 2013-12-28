https = require "https"

crypto = require 'crypto'


md5 = (str) ->
    md5sum = crypto.createHash 'md5'
    md5sum.update(str).digest('hex')

# TODO: logger 分级控制
log   = console.log

# 是否需要 验证码
# @param qq
# @param result -> [是否需要验证码 , token , bits ]
exports.check_qq = (qq, result) ->
    # TODO: random -> r
    url = "https://ssl.ptlogin2.qq.com/check?uin=#{qq}&appid=1003903&js_ver=10062&js_type=0&r=0.6569391019121522"
    body = '';
    https
        .get url , (resp) ->
            log "response: #{resp.statusCode}"
            resp.on 'data', (chunk) ->
                body += chunk;
            resp.on 'end', ->
                log body
                ret = body.match(/\'(.*?)\'/g).map (i)->
                    last = i.length - 2
                    i.substr(1 ,last)
                log ret
                result( ret )
            
        .on "error", (e) ->
              log e
        

exports.encode_password = (password , token , bits) ->

    password = md5(password)
    bits = bits.replace(/\\x/g,'')

    hex2ascii = (hexstr) -> 
        hexstr.match(/\w{2}/g)
              .map (byte_str) ->
                  String.fromCharCode parseInt(byte_str,16)
              .join('')    

    ret = md5( hex2ascii(password) + hex2ascii(bits) ).toUpperCase() + token
    ret = md5( ret ).toUpperCase()

    return ret

