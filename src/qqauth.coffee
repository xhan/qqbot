https = require "https"
http  = require 'http'
crypto = require 'crypto'
querystring  = require 'querystring'
Url = require('url')
all_cookies = []
int = (v) -> parseInt v
Path = require 'path'
Log = require 'log'
log = new Log('debug');

md5 = (str) ->
    md5sum = crypto.createHash 'md5'
    md5sum.update(str).digest('hex')




exports.cookies = ->
    all_cookies


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
              log.error e


# 获取验证码
# 记得call  finish_verify_code
exports.get_verify_code = (qq , host, port, callback) ->
    # url = "https://ssl.captcha.qq.com/getimage?aid=1003903&r=0.2509327069195215&uin=#{qq}"
    url = "http://captcha.qq.com/getimage?aid=1003903&r=0.2509327069195215&uin=#{qq}"
    body = ''

    http.get url , (resp) ->
        # log "verify code: #{resp.statusCode}"
        # log resp.headers
        all_cookies = all_cookies.concat resp.headers['set-cookie']
        resp.setEncoding 'binary'
        resp.on 'data', (chunk) ->
            body += chunk;
        resp.on 'end', ->
            create_img_server(host,port,body,resp.headers)
            callback()
    .on "error", (e) ->
       log.error e
       callback(e)

exports.finish_verify_code = -> stop_img_server()


img_server = null
create_img_server = (host, port, body ,origin_headers) ->
    return if img_server

    fs = require 'fs'
    file_path = Path.join __dirname, "..", "tmp", "verifycode.jpg"
    fs.writeFileSync file_path , body , 'binary'

    img_server = http.createServer (req, res) ->
      res.writeHead 200 , origin_headers
      res.end body, 'binary'

    img_server.listen port


stop_img_server = ->
   img_server.close() if img_server
   img_server = null





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

    ret = md5( hex2ascii(password) + hex2ascii(bits) ).toUpperCase() + token.toUpperCase()
    ret = md5( ret ).toUpperCase()

    return ret


# 登录 帐号密码验证码 校验
exports.login_step1 = (qq, encode_password, verifycode , callback) ->
    path = "/login?u=#{qq}&p=#{encode_password}&verifycode=#{verifycode}&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10&h=1&ptredirect=0&ptlang=2052&daid=164&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=3-15-72115&mibao_css=m_webqq&t=1&g=1&js_type=0&js_ver=10062&login_sig=qBpuWCs9dlR9awKKmzdRhV8TZ8MfupdXF6zyHmnGUaEzun0bobwOhMh6m7FQjvWA"
    options =
        host: 'ssl.ptlogin2.qq.com'
        path: path
        headers:
            'Cookie' : all_cookies

    body = '';
    https
        .get options  , (resp) ->
            # log "response: #{resp.statusCode}"
            # log all_cookies
            all_cookies = all_cookies.concat resp.headers['set-cookie']
            # log all_cookies
            resp.on 'data', (chunk) ->
                body += chunk
            resp.on 'end', ->

                ret = body.match(/\'(.*?)\'/g).map (i)->
                    last = i.length - 2
                    i.substr(1 ,last)
                callback( ret )

        .on "error", (e) ->
              log.error e

# 验证成功后继续获取cookie
exports.login_step2 = (url, callback) ->
    url = Url.parse(url)
    options =
        host: url.host
        path: url.path
        headers:
            'Cookie' : all_cookies

    body = '';
    http
        .get options  , (resp) ->
            log.debug "response: #{resp.statusCode}"
            all_cookies = all_cookies.concat resp.headers['set-cookie']
            callback( true )
            # 只需要获取cookie
        .on "error", (e) ->
              log.error e

# "http://d.web2.qq.com/channel/login2"
#  callback( ret , client_id , ptwebqq)
exports.login_token = (callback) ->
    # 97518388
    client_id = 97500000 + parseInt(Math.random() * 99999)
    ptwebqq   = all_cookies.filter( (item)->item.match /ptwebqq/ )
                           .pop()
                           .replace /ptwebqq\=(.*?);.*/ , '$1'
    # log all_cookies
    r =
        status: "online",
        ptwebqq: ptwebqq,
        passwd_sig: "",
        clientid: "#{client_id}",
        psessionid: null
    r = JSON.stringify(r)

    data = querystring.stringify {
        clientid: client_id,
        psessionid: 'null',
        r: r
    }
    # log data

    body = ''
    options =
        host: 'd.web2.qq.com',
        path: '/channel/login2',
        method: 'POST',
        headers:
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:27.0) Gecko/20100101 Firefox/27.0',
            'Referer': 'http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3',
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Content-Length': Buffer.byteLength(data),
            'Cookie' : all_cookies

    req = http.request options, (resp) ->
        log.debug "login token response: #{resp.statusCode}"
        resp.on 'data', (chunk) ->
            body += chunk
        resp.on 'end', ->
            ret = JSON.parse(body)
            callback( ret , client_id ,ptwebqq)

    req.write(data);
    req.end();

###
    全局登录函数，如果有验证码会建立一个 http-server ，同时写入 tmp/*.jpg (osx + open. 操作)
    http-server 的端口和显示地址可配置
    @param options {account,password,port,host}
    @callback( cookies , auth_options ) if login success
###
exports.login = (options, callback) ->
    [auth,opt] = [exports,options]
    [qq,pass] = [opt.account,opt.password]

    log.info '登录 step0 验证码检测'
    auth.check_qq qq , (result) ->
      # log.debug "验证帐号:", result
      [need_verify,verify_code,bits] = result
      if int need_verify
        log.info "登录 step0.5 获取验证码"
        auth.get_verify_code qq, opt.host, opt.port, (error) ->
          # open image folder
          require('child_process').exec 'open tmp' if process.platform is 'darwin'

          log.notice "打开该地址->", "http://#{opt.host}:#{opt.port}"
          auth.prompt "输入验证码:" , (code) ->
              auth.finish_verify_code()
              verify_code  = code
              log.notice '验证码：' , verify_code
              pass_encrypted = auth.encode_password(pass, verify_code , bits)
              login_next( qq , pass_encrypted , verify_code , callback)
      else
        log.info "- 无需验证码"
        pass_encrypted= auth.encode_password(pass, verify_code , bits)
        login_next( qq , pass_encrypted , verify_code , callback)

# login 函数的步骤2
#  TODO:各种回调的 error 处理
login_next = (account , pass_encrypted , verify_code , callback)->
  auth = exports
  log.info "登录 step1 密码校验"
  auth.login_step1 account, pass_encrypted , verify_code , (ret)->

    if not ret[2].match /^http/
      log.error "登录 step1 failed", ret
      return

    log.info "登录 step2 cookie获取"
    auth.login_step2 ret[2] , (ret) ->
      log.info "登录 step3 token 获取"
      auth.login_token (ret,client_id,ptwebqq) ->
        if ret.retcode == 0
            log.info '登录成功',account

            auth_options =
              psessionid: ret.result.psessionid
              clientid  : client_id
              ptwebqq   : ptwebqq
              uin       : ret.result.uin
              vfwebqq   : ret.result.vfwebqq

            callback( all_cookies, auth_options)

        else
          log.info "登录失败"
          log.error ret


# prompt user to input something
# and also listen for process event data
# @param title : prompt title
# @callback(content)
exports.prompt = (title, callback) ->
    process.stdin.resume()
    process.stdout.write(title)
    process.on "data" , (data) ->
      if data
        callback data
        process.stdin.pause()
    process.stdin.on "data",  (data) ->
      data = data.toString().trim()
      # 过滤无效内容
      if data
        callback data
        process.stdin.pause()
    # control + d to end
    process.stdin.on 'end', ->
      process.stdout.write('end')
      callback()