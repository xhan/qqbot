{Robot, Adapter, EnterMessage, LeaveMessage, TextMessage} = require('hubot')

auth = require "../src/qqauth"
api  = require "../src/qqapi"
QQBot= require "../src/qqbot"

class QQHubotAdapter extends Adapter
    
  send: (envelope, strings...) ->
    @group.send str for str in strings
            
  reply: (user, strings...) ->
    @send user, strings...

  run: ->
    self = @
    
    options =
      account:   process.env.HUBOT_QQ_ID or   2769546520
      password:  process.env.HUBOT_QQ_PASS or 'qqbot123'
      groupname: process.env.HUBOT_QQ_GROUP or 'qqbot群'
      port:      process.env.HUBOT_QQ_IMGPORT or 3000
      host:      process.env.HUBOT_QQ_IMGHOST or 'localhost'
      plugins:   ['help']

    unless options.account? and options.password? and options.groupname?
      @robot.logger.error "请配置qq 密码 和监听群名字，具体查阅帮助"
      process.exit(1)


    # TODO: login failed callback
    auth.login options , (cookies,auth_info)=>
      @bot = new QQBot(cookies,auth_info,options)
      @bot.listen_group options.groupname , (@group,error)=>
                          
        @robot.logger.info "enter long poll mode, have fun"
        @bot.runloop()  
        @emit "connected"
        
        @group.on_message (content ,send, robot, message)=>
            
            # uin changed every-time
            user = @robot.brain.userForId message.from_uin , name:message.from_user.nick , room:options.groupname
            @receive new TextMessage user, message.content, message.uid
        
        

exports.use = (robot) ->
  new QQHubotAdapter robot
