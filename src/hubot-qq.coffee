{Robot, Adapter, EnterMessage, LeaveMessage, TextMessage} = require('hubot')

auth = require "../src/qqauth"
api  = require "../src/qqapi"
QQBot= require "../src/qqbot"
defaults = require "../src/defaults"

class QQHubotAdapter extends Adapter

  send: (envelope, strings...) ->
    @robot.logger.info "hubot is sending #{strings}"
    @group.send str for str in strings

  reply: (user, strings...) ->
    @send user, strings...

  emote: (envelope, strings...) ->
    @send envelope, "* #{str}" for str in strings

  run: ->
    self = @

    options =
      account:   process.env.HUBOT_QQ_ID or   2769546520
      password:  process.env.HUBOT_QQ_PASS
      groupname: process.env.HUBOT_QQ_GROUP or 'qqbot群'
      port:      process.env.HUBOT_QQ_IMGPORT or 3000
      host:      process.env.HUBOT_QQ_IMGHOST or 'localhost'
      plugins:   ['help']

    skip_login = process.env.HUBOT_QQ_SKIP_LOGIN is 'true'

    unless options.account? and options.password? and options.groupname?
      @robot.logger.error "请配置qq 密码 和监听群名字，具体查阅帮助"
      process.exit(1)

    # TODO: login failed callback
    @login_qq skip_login,options,(cookies,auth_info)=>
      @qqbot = new QQBot(cookies,auth_info,options)
      @qqbot.update_buddy_list (ret,error)->
          log.info '√ buddy list fetched' if ret
      @qqbot.listen_group options.groupname , (@group,error)=>

        @robot.logger.info "enter long poll mode, have fun"
        @qqbot.runloop()
        @emit "connected"

        @group.on_message (content ,send, robot, message)=>

            @robot.logger.info "#{message.from_user.nick} : #{content}"
            # uin changed every-time
            user = @robot.brain.userForId message.from_uin , name:message.from_user.nick , room:options.groupname
            @receive new TextMessage user, content, message.uid



  #  @callback (cookies,auth_info)
  login_qq: (skip_login, options,callback)->
    defaults.set_path '/tmp/store.json'
    if skip_login
      cookies = defaults.data 'qq-cookies'
      auth_info = defaults.data 'qq-auth'
      @robot.logger.info "skip login",auth_info
      callback(cookies , auth_info )
    else
      auth.login options , (cookies,auth_info)=>
        if process.env.HUBOT_QQ_DEBUG?
          defaults.data 'qq-cookies', cookies
          defaults.data 'qq-auth'   , auth_info
          defaults.save()

        callback(cookies,auth_info)


exports.use = (robot) ->
  new QQHubotAdapter robot
