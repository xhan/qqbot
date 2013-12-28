https = require "https"
log   = console.log
# 是否需要 验证码
exports.check_qq = (qq) ->
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
            
        .on "error", (e) ->
              log e
        
