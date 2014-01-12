api = require './qqapi'
Log = require 'log'
Dispatcher = require './dispatcher'

log = new Log('debug')
jsons = JSON.stringify

###
 cookie , auth 登录需要参数
 config:  配置信息，将 config.yaml
   plugins: 插件
###
class QQBot
    constructor: (@cookies, @auth, @config) ->
        @buddy_info = {}
        @group_info = {}
        @groupmember_info = {}

        api.cookies @cookies
        @api = api
        @dispatcher = new Dispatcher(@config.plugins)

    # @format PROTOCOL `用户分组信息格式`
    save_buddy_info: (@buddy_info)->

    # @format PROTOCOL `群分组信息格式`
    save_group_info: (@group_info) ->

    # @format PROTOCOL `群用户信息`
    save_group_member: (group,info)->
        @groupmember_info[group.gid] = info

    # 获取用户信息
    # @return {nick,uin,flag,face}
    get_user: (uin) ->
        # TODO:加速查询
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

    # 获取群列表
    # @callback {ret:bool,error}
    update_group_list: (callback)->
      @api.get_group_list @auth, (ret , e)=>
          log.error e  if e
          @save_group_info ret.result if ret.retcode == 0
          callback( ret.retcode == 0, e || 'retcode isnot 0' ) if callback

    # 获取好友列表
    # @callback (ret:bool, error)
    update_buddy_list: (callback)->
        @api.get_buddy_list @auth , (ret,e)=>
            @save_buddy_info ret.result if ret.retcode == 0
            callback( ret.retcode == 0, e || 'retcode isnot 0' ) if callback

    # 更新群成员， 似乎获取不到群ID
    # @options {key:value} or group obj
    # @callback (ret:bool , error)
    update_group_member: (options, callback)->
        group = if options.code then options else @get_group(options)
        api.get_group_member group.code , @auth , (ret,e)=>
            if ret.retcode == 0
                @save_group_member(group,ret.result)
            callback(ret.retcode == 0 , e) if callback

    # 更新所有群成员
    # @callback (success,total_count,success_count)
    update_all_group_member: (callback)->
      finished = successed = 0
      groups = @group_info.gnamelist || []
      all = groups.length
      for group in groups
        @update_group_member group , (ret,error)->
          finished += 1; successed += ret
          log.debug "groupmember all#{all} fin#{finished} succ#{successed}"
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


    # 长轮询
    # @callback
    runloop: (callback)->
      @api.long_poll @auth , (ret,e)=>
          @handle_poll_responce ret,e
          callback(ret,e) if callback

    # 回复消息
    # @param message 收到的message
    # @param content:string 回复信息
    # @callback ret, error
    reply_message: (message, content, callback)->
        log.info "发送消息：",content
        if message.type == 'group'
            @api.send_msg_2group  message.from_gid , content , @auth, (ret,e)->
                callback(ret,e) if callback
        else if message.type == 'buddy'
            @api.send_msg_2buddy message.from_uin , content , @auth , (ret,e)->
                callback(ret,e) if callback

    # 发送群消息
    # @param gid_or_group 
    # @callback (ret,e)
    send_message_to_group: (gid_or_group, content, callback)->
      gid = if typeof gid_or_group is 'object' then gid_or_group.gid else gid_or_group
      log.info "send msg #{content} to group#{gid}"
      api.send_msg_2group  gid , content , @auth, (ret,e)->
        callback(ret,e) if callback

    # 自杀
    die: (message,info)->
      #TODO: 这里 log.error 似乎看不到日志输出，试试console
        console.log "QQBot die! message: #{message}" if message
        console.log "QQBot die! info #{JSON.stringify info}" if info
        process.exit(1)

    # 处理poll返回的内容
    handle_poll_responce: (resp,e)->
      log.error "poll with error #{e}" if e
      code = if resp then resp.retcode else -1
      switch code
        when -1  then log.error "resp is null"
        when 0   then @_handle_poll_event(event) for event in resp.result
        when 102 then 'nothing happened'
        when 103 then '应该是token失效了，但是偶尔也有情况返回' ; @die("登录异常 #{code}",resp)
        when 116 then @_update_ptwebqq(resp)
        when 121 then @die("登录异常 #{code}",resp)
        else log.debug resp

    # token改变后的通知
    # callback( @auth )
    on_token_changed: (callback)->
      @cb_token_changed = callback
      
    # 更新token ptwebqq的值，返回值{116 ,p=token}
    # TODO 看看cookie是否也需要修改
    _update_ptwebqq: (ret)->
      log.info 'need to update ptwebqq ',ret
      @auth['ptwebqq'] = ret.p
      @cb_token_changed(@auth)


    _handle_poll_event : (event) ->
        switch event.poll_type
          when 'group_message' then @_on_message(event)
          when 'message'       then @_on_message(event)
          # sys_g_msg
          # when 'input_notify'  then ""
          # when 'buddies_status_change' then ""
          else log.warning "unimplemented event",event.poll_type , "content: ", jsons event

    _on_message : (event)->
        msg = @_create_message event
        try
          if msg.type == 'group'
            update_group_member msg.from_group unless msg.from_user  #更新新用户
            log.debug "[群消息]","[#{msg.from_group.name}] #{msg.from_user.nick}:#{msg.content} #{msg.time}"
          else if msg.type == 'buddy'
            log.debug "[好友消息]","#{msg.from_user.nick}:#{msg.content} #{msg.time}"
        catch error
          log.error "on_message #{error}"
          log.debug "on_message #{msg}"


        # 消息处理
        replied = false
        reply = (content)=>
            @reply_message(msg,content) unless replied
            replied = true

        @dispatcher.dispatch(msg.content ,reply, @ , msg)


    _create_message : (event)->
        value = event.value
        msg =
            content : value.content.slice(-1).pop().trim()
            time    : new Date(value.time * 1000)
            from_uin: value.from_uin
            type    : if value.group_code then 'group' else 'buddy'
            uid     : value.msg_id

        if msg.type == 'group'
            msg.from_gid = msg.from_uin
            msg.group_code = value.group_code
            msg.from_uin = value.send_uin # 这才是用户,group消息中 from_uin 是gid
            msg.from_group = @get_group( {gid:msg.from_gid} )
            msg.from_user  = @get_user_ingroup( msg.from_uin ,msg.from_gid )
        else if msg.type == 'buddy'
            msg.from_user = @get_user( msg.from_uin )
        msg


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