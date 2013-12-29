https = require "https"

crypto = require 'crypto'

all_cookies = null

md5 = (str) ->
    md5sum = crypto.createHash 'md5'
    md5sum.update(str).digest('hex')

# TODO: logger 分级控制
log   = console.log

# 是否需要 验证码
# @param qq
# @param callback -> [是否需要验证码 , token , bits ]
exports.check_qq = (qq, callback) ->
    # TODO: random -> r

    options = 
        host: 'ssl.ptlogin2.qq.com'
        path: "/check?uin=#{qq}&appid=1003903&js_ver=10062&js_type=0&r=0.6569391019121522"
        headers:
            'Cookie' : "chkuin=#{qq}"

    body = '';
    https
        .get options  , (resp) ->
            # log "response: #{resp.statusCode}"
            all_cookies = resp.headers['set-cookie']
            resp.on 'data', (chunk) ->
                body += chunk;
            resp.on 'end', ->
                # log body
                ret = body.match(/\'(.*?)\'/g).map (i)->
                    last = i.length - 2
                    i.substr(1 ,last)
                # log ret
                callback( ret )
            
        .on "error", (e) ->
              log e
              

# 获取验证码url
exports.get_verify_code_url = (qq) ->
    "https://ssl.captcha.qq.com/getimage?aid=1003903&r=0.2509327069195215&uin=#{qq}"



# 生成加密密码
# @param password 密码
# @param token    check_qq 参数1 !UGX 
# @param bits     check_qq 参数2 \x00\x11\x00\x11
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


# 登录
exports.login = (qq, encode_password, verifycode, cookies , callback) -> 
    # path = "/login?u=#{qq}&p=#{encode_password}&verifycode=#{verifycode}&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=http%3A%2F%2Fweb.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10&h=1&ptredirect=0&ptlang=2052&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=8-38-447467&mibao_css=m_webqq&t=3&g=1"
    path = "/login?u=#{qq}&p=#{encode_password}&verifycode=#{verifycode}&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10&h=1&ptredirect=0&ptlang=2052&daid=164&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=3-15-72115&mibao_css=m_webqq&t=1&g=1&js_type=0&js_ver=10062&login_sig=qBpuWCs9dlR9awKKmzdRhV8TZ8MfupdXF6zyHmnGUaEzun0bobwOhMh6m7FQjvWA"
    log path
    options = 
        host: 'ssl.ptlogin2.qq.com'
        path: path 
        headers:
            'Cookie' : all_cookies.join('')

    body = '';
    https
        .get options  , (resp) ->
            log "response: #{resp.statusCode}"
            resp.on 'data', (chunk) ->
                body += chunk;
            resp.on 'end', ->
                ret = body.match(/\'(.*?)\'/g).map (i)->
                    last = i.length - 2
                    i.substr(1 ,last)
                callback( ret )
            
        .on "error", (e) ->
              log e
        