auth = require './qqauth'
api = require './qqapi'
Log = require 'log'
Request = require 'request'
Dispatcher = require './dispatcher'

log = new Log('debug')
jsons = JSON.stringify

MsgType =
  Default:'message'
  Sess:'sess_message'
  Group:'group_message'
  Discuss:'discu_message'

###
 cookie , auth 登录需要参数
 config:  配置信息，将 config.yaml
   plugins: 插件
###
class QQBot
  constructor: (@cookies, @auth, @config) ->
    # PROTOCOL `用户分组信息格式`
    @buddy_info = {}
    # PROTOCOL `群分组信息格式`
    @group_info = {}
    # PROTOCOL `群用户信息`
    @groupmember_info = {}

    # discuss group
    @dgroup_info = {}
    @dgroupmember_info = {}

    # 账户表
    @user_account_table = {}
    @group_account_table = {}

    api.cookies @cookies
    @api = api
    @dispatcher = new Dispatcher(@config.plugins,@)
    @started = true
    @request = Request

  # @format PROTOCOL `群用户信息`
  save_group_member: (group,info)->
    @groupmember_info[group.gid] = info

  # 获取用户信息
  # @return {nick,uin,flag,face}
  get_user: (uin) ->
    users = @buddy_info.info.filter (item)-> item.uin == uin
    users.pop()

  # 获取群用户信息
  get_user_ingroup: (uin, gid)->
    info = @groupmember_info[gid]
    users = info.minfo.filter (item)-> item.uin == uin
    users.pop()

  # 获取群信息，只支持群 ，支持多关键词搜索
  # @options {key:value}
  # @return {gid,code,name,flag}
  get_group: (options)->
      groups = @group_info.gnamelist.filter (item)->
          for key ,value of options
              return item[key] == value
      groups.pop()

  # @options {key:value}
  # @return {name, did}
  get_dgroup: (options)->
    try
      groups = @dgroup_info.dnamelist.filter (item)->
        for key,value of options
          return item[key] == value
      groups.pop()


  get_user_in_dgroup: (uin, did)->
    try
      info = @dgroupmember_info[did]
      users = (user for user in info.mem_info when user.uin == uin)
      users.pop()


  # 获取群列表
  # @callback {ret:bool,error}
  update_group_list: (callback)->
    @api.get_group_list @auth, (ret , e)=>
        log.error e  if e
        @group_info = ret.result if ret.retcode == 0
        callback( ret.retcode == 0, e || 'retcode isnot 0' ) if callback

  # 获取好友列表
  # @callback (ret:bool, error)
  update_buddy_list: (callback)->
      @api.get_buddy_list @auth , (ret,e)=>
          @buddy_info = ret.result if ret.retcode == 0
          callback( ret.retcode == 0, e || 'retcode isnot 0' ) if callback

  # 更新群成员
  # @options {key:value} or group obj
  # @callback (ret:bool , error)
  update_group_member: (options, callback)->
    group = if options.code then options else @get_group(options)
    @api.get_group_member group.code , @auth , (ret,e)=>
        if ret.retcode == 0
          @save_group_member(group,ret.result)
        callback(ret.retcode == 0 , e) if callback

  update_dgroup_list: (callback)->
    log.info "update discuss group list"
    @api.get_discuss_list @auth, (ret,e)=>
      log.error e if e
      @dgroup_info = ret.result if ret.retcode == 0
      # log.info jsons @dgroup_info
      callback(ret.retcode == 0, e||'retcode isnot 0') if callback

  update_dgroup_member: (dgroup,callback)->
    log.info "update discuss group member #{dgroup.did}"
    did = dgroup.did
    @api.get_discuss_member did, @auth, (ret,e)=>
      if ret.retcode == 0
        @dgroupmember_info[did] = ret.result
        # log.info jsons ret.result
      callback(ret.retcode == 0 , e) if callback


  # 更新所有群成员
  # @callback (success,total_count,success_count)
  update_all_group_member: (callback)->
    finished = successed = 0
    groups = @group_info.gnamelist || []
    all = groups.length
    callback(true,0,0) if all == 0
    for group in groups
      @update_group_member group , (ret,error)->
        finished += 1; successed += ret
        log.debug "groupmember all#{all} fin#{finished} succ#{successed}"
        log.debug error if error
        callback(successed == all, finished ,successed) if finished == all

  # 更新好友和群成员
  # @callback (ret?,actions) 是否全部更新成功 , actions每个状态
  update_all_members: (callback)->
    # [0,0] -> [finished,success]
    actions= buddy:[0,0],group:[0,0],groupmember:[0,0]
    check = ->
      finished = successed = 0 ; all = Object.keys(actions).length
      stats = (value for key,value of actions)
      for item in stats
        finished += item[0] ; successed += item[1]
      log.debug("updating all: all #{all} finished #{finished} success #{successed}")
      callback(successed==all) if finished == all

    # fetching...
    log.info 'fetching buddy list...'
    @update_buddy_list (ret)->
      actions.buddy = [1, ret]
      check()

    log.info 'fetching group list...'
    @update_group_list (ret)=>
      actions.group = [1, ret]
      unless ret
        callback(false)
        return

      log.info 'fetching all groupmember...'
      @update_all_group_member (ret,all,successed)->
        actions.groupmember = [1,ret]
        check()

    log.info 'fetching discuss group list'
    @update_dgroup_list()

  # 获取号码信息的通用方法
  # @param table
  # @param uin    uin 或 gid
  # @param type   QQ号码 1, 群号码 4
  # @callback (error, account)
  get_account_info_general: (table, uin, type, callback)->
    key = "uin" + uin

    if info = table[key]
      if acc = info.account
        callback null, acc
      else
        info.callbacks.push callback

    else
      callbacks = [callback]
      table[key] = callbacks: callbacks

      call_callbacks = (err, account)->
        func err, account for func in callbacks

      log.info "fetching account info: type#{type}, uin#{uin}"
      @api.get_friend_uin2 uin, type, @auth, (ret, e)=>
        delete table[key]

        unless ret?
          call_callbacks {}, null
          return

        if ret.retcode == 0
          result = table[key] = ret.result

          # 不知道为什么，群号码总要减掉这个数才正确……
          result.account -= 3890000000 if type == 4

          account = result.account
          account_key = "acc" + account

          funcs = table[account_key]?.callbacks
          table[account_key] = result

          func null, uin for func in funcs if funcs

          call_callbacks null, account
        else
          call_callbacks ret, null

  # 通过号码反向获取 uin/gid 的通用方法
  # @param table
  # @param account
  # @callback (error, account)
  # @return uin
  get_uin_general: (table, account, callback)->
    key = "acc" + account
    if info = table[key]
      if uin = info.uin
        callback null, uin if callback
        return uin
      else
        info.callbacks.push callback
        return null
    else
      table[key] = callbacks: [callback] if callback
      return null

  # 获取 QQ 号码
  # @param uin_or_user
  # @callback (error, account)
  get_user_account: (uin_or_user, callback)->
    uin = if typeof uin_or_user is 'object' then uin_or_user.uin else uin_or_user
    @get_account_info_general @user_account_table, uin, 1, callback

  # 根据 QQ 号码获取 uin，目前必须调用过 get_user_account 才可以获取到对应 uin，
  # 如果不使用 callback 参数的话将会直接返回 uin （不可用时为 null），
  # 否则将会一直等到可用才会调用 callback
  # @param account QQ 号码
  # @callback (error, uin)
  # @return uin
  get_user_uin: (account, callback)->
    return @get_uin_general @user_account_table, account, callback

  # 获取群号码
  # @param gid_or_group
  # @callback (error, account)
  get_group_account: (gid_or_group, callback)->
    uin = if typeof gid_or_group is 'object' then gid_or_group.gid else gid_or_group
    @get_account_info_general @group_account_table, uin, 4, callback

  # 根据群号码获取 gid，目前必须调用过 get_group_account 才可以获取到对应 gid，
  # 如果不使用 callback 参数的话将会直接返回 gid （不可用时为 null），
  # 否则将会一直等到可用才会调用 callback
  # @param account 群号码
  # @callback (error, gid)
  # @return gid
  get_group_gid: (account, callback)->
    return @get_uin_general @group_account_table, account, callback

  # die callback
  on_die: (callback)->
    @cb_die = callback

  # 长轮询
  # @callback
  runloop: (callback)->
    @api.long_poll @auth , (ret,e)=>
      if @started
        @handle_poll_responce ret,e
        callback(ret,e) if callback
      return @started


  # 回复消息
  # @param message 收到的message
  # @param content:string 回复信息
  # @callback ret, error
  reply_message: (message, content, callback)->
      log.info "发送消息：",content
      switch message.type
        when MsgType.Group
          @api.send_msg_2group  message.from_gid , content , @auth, callback
        when MsgType.Default
          @api.send_msg_2buddy message.from_uin , content , @auth , callback
        when MsgType.Discuss
          @api.send_msg_2discuss message.from_did, content, @auth, callback
        when MsgType.Sess
          @api.send_msg_2sess  message.from_gid , message.from_uin , content , @auth, callback

  # 发送消息
  # @param uin
  # @callback (ret,e)
  send_message: (uin_or_user, content, callback)->
    uin = if typeof uin_or_user is 'object' then uin_or_user.uin else uin_or_user
    log.info "send msg #{content} to user#{uin}"
    api.send_msg_2buddy uin, content, @auth, callback

  # 发送群消息
  # @param gid_or_group
  # @callback (ret,e)
  send_message_to_group: (gid_or_group, content, callback)->
    gid = if typeof gid_or_group is 'object' then gid_or_group.gid else gid_or_group
    log.info "send msg #{content} to group#{gid}"
    api.send_msg_2group  gid , content , @auth, callback

  send_message_to_discuss: (did, content, callback)->
    log.info "send msg #{content} to discuss#{did}"
    api.send_msg_2discuss did, content, @auth, callback

  # 自杀
  die: (message,info)->
    @dispatcher.stop_plugin()
    @started = false

    #TODO: 这里 log.error 似乎看不到日志输出，试试console
    log.error "QQBot will die! message: #{message}" if message
    console.log "QQBot will die! message: #{message}" if message

    log.error "QQBot will die! info #{JSON.stringify info}" if info
    console.log "QQBot will die! info #{JSON.stringify info}" if info

    if @cb_die
      @cb_die()
    else
      process.exit(1)

  # 处理poll返回的内容
  handle_poll_responce: (resp,e)->
    log.error "poll with error #{e}" if e
    code = if resp then resp.retcode else -1
    switch code
      when -1  then log.error "resp is null, error on parse ret",resp
      when 0   then @_handle_poll_event(event) for event in resp.result
      when 102 then 'nothing happened, waiting for next loop'
      when 116 then @_update_ptwebqq(resp)
      when 103,121 then @die("登录异常 #{code}",resp)
      else log.debug resp

  ###
  重新登录获取token
  @callback success:bool
  ###
  relogin: (callback)->
    log.info "relogin..."
    auth.cookies @cookies

    auth.login_token @auth.clientid, @auth.psessionid, (ret,client_id,ptwebqq) =>
      if ret.retcode != 0
        log.error "relogin failed"
        log.info ret
        callback(false) if callback
        return

      log.debug 'before',@auth
      auth_new =
        psessionid: ret.result.psessionid
        clientid  : client_id
        ptwebqq   : ptwebqq
        uin       : ret.result.uin
        vfwebqq   : ret.result.vfwebqq

      @auth = auth_new
      log.debug 'after',@auth
      callback(true) if callback


  # 更新token ptwebqq的值，返回值{116 ,p=token}
  _update_ptwebqq: (ret)->
    log.debug 'need to update ptwebqq ',ret
    @auth['ptwebqq'] = ret.p

  _handle_poll_event : (event) ->
    switch event.poll_type
      when MsgType.Default, MsgType.Sess, MsgType.Group, MsgType.Discuss
        @_on_message(event, event.poll_type)
      when 'input_notify'  then ""
      when 'buddies_status_change' then ""
      else log.warning "unimplemented event",event.poll_type , "content: ", jsons event

  _on_message : (event, msg_type)->
    value = event.value
    msg =
      content : value.content.slice(-1).pop().trim()
      time    : new Date(value.time * 1000)
      from_uin: value.from_uin
      type    : msg_type
      uid     : value.msg_id

    if msg_type == MsgType.Group
      msg.from_gid = msg.from_uin
      msg.group_code = value.group_code
      msg.from_uin = value.send_uin # 这才是用户,group消息中 from_uin 是gid
      msg.from_group = @get_group( {gid:msg.from_gid} )
      msg.from_user  = @get_user_ingroup( msg.from_uin ,msg.from_gid )
      # 更新
      @update_group_list unless msg.from_group
      @update_group_member {gid:msg.from_gid} unless msg.from_user

      msg.from_group ?= {}
      msg.from_user  ?= {}
      try log.debug "[群组消息]","[#{msg.from_group.name}] #{msg.from_user.nick}:#{msg.content} #{msg.time}"
    else if msg_type == MsgType.Discuss
      msg.from_did = value.did
      msg.from_uin = value.send_uin
      msg.from_dgroup = @get_dgroup({did:value.did})
      msg.from_user = @get_user_in_dgroup(msg.from_uin,msg.from_did)

      # 更新
      @update_dgroup_list() unless msg.from_dgroup
      @update_dgroup_member {did:value.did} unless msg.from_user
      msg.from_dgroup ?= {}
      msg.from_user  ?= {}

      try log.debug "[讨论组消息]","[#{msg.from_dgroup.name}] #{msg.from_user.nick}:#{msg.content} #{msg.time}"
    else if msg_type == MsgType.Default
      msg.from_user = @get_user( msg.from_uin )
      #  更新
      @update_buddy_list unless msg.from_user
      try log.debug "[好友消息]","#{msg.from_user.nick}:#{msg.content} #{msg.time}"
    else if msg_type == MsgType.Sess
      msg.from_gid = value.id
      msg.from_uin = value.from_uin
      msg.from_group = @get_group( {gid:msg.from_gid} )
      msg.from_user  = @get_user_ingroup( msg.from_uin ,msg.from_gid )
      # 更新
      @update_group_list unless msg.from_group
      @update_group_member {gid:msg.from_gid} unless msg.from_user

      msg.from_group ?= {}
      msg.from_user  ?= {}

      try log.debug "[临时消息]","#{msg.from_user.nick}:#{msg.content} #{msg.time}"


    # 消息和插件处理
    if @config.offline_msg_keeptime and new Date().getTime() - msg.time.getTime() > @config.offline_msg_keeptime * 1000
      return

    replied = false
    reply = (content)=>
        @reply_message(msg,content) unless replied
        replied = true

    @dispatcher.dispatch(msg.content ,reply, @ , msg)



  # 监听特定群并返回群对象
  # @callback (group对象, error = null)

  listen_group : (name , callback) ->
    log.info 'fetching group list'
    @update_group_list (ret, e) =>
      log.info '√ group list fetched'

      log.info "fetching groupmember #{name}"
      @update_group_member {name:name} ,(ret,error)=>
        log.info '√ group memeber fetched'

        groupinfo = @get_group {name:name}
        group = new Group(@, groupinfo.gid)
        @dispatcher.add_listener [group,"dispatch"]
        callback group


###
 为hubot专门使用，提供两个方法
 - send
 - on_message (content,send_fun, bot , message_info) ->
###
class Group
  constructor: (@bot,@gid)->
  send: (content , callback)->
    @bot.send_message_to_group  @gid , content , (ret,e)->
        callback(ret,e) if callback

  on_message: (@msg_cb)->
  dispatch: (content ,send, robot, message)->
    # log.debug 'dispatch',params[0],@msg_cb
    if message.from_gid == @gid and @msg_cb
        @msg_cb(content ,send, robot, message)


module.exports = QQBot
