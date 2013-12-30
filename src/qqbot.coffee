api = require './qqapi'
api.defaults_read()

log = console.log
jsons = JSON.stringify

# 名字起得太差了
Plugin = require './qqplugin'
config = require '../config'
plugin = new Plugin(config.plugins,config.listen)


class QQBot
    constructor: (@name ,@auth) ->
        @buddy_info = {}
        @group_info = {}
        @groupmember_info = {}
        @plugin_control = plugin
        
    
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
    
    # 更新群成员， 似乎获取不到群ID
    # @options {key:value} 
    # @callback (true/false , error)
    update_group_member: (options, callback)->
        group = @get_group(options)
        api.get_group_member group.code , @auth , (ret,e)=>
            if ret.retcode == 0
                @save_group_member(group,ret.result)
            callback(ret.retcode == 0 , e) if callback
    
    # 回复消息
    # @param message 收到的message
    # @param content:string 回复信息
    # @callback ret, error
    reply_message: (message, content, callback)->
        log "发送消息：",content
        if message.type == 'group'
            api.send_msg_2group  message.from_gid , content , @auth, (ret,e)->
                callback(ret,e) if callback
        else if message.type == 'buddy'            
            api.send_msg_2buddy message.from_uin , content , @auth , (ret,e)->
                callback(ret,e) if callback    
    
    
    # 处理poll返回的内容
    handle_poll_responce: (resp)->
        code = resp.retcode
        return if code != 0
        for idx,event of resp.result
            @_handle_poll_event(event)
        
    _handle_poll_event : (event) ->
        switch event.poll_type
          when 'group_message' then @_on_message(event)
          when 'message'       then @_on_message(event)
          else log "unimplemented event",event.poll_type
        
    _on_message : (event)->
        msg = @_create_message event
        if msg.type == 'group'
            log "[群消息]","[#{msg.from_group.name}] #{msg.from_user.nick}:#{msg.content} #{msg.time}"
        else if msg.type == 'buddy'
            log "[好友消息]","#{msg.from_user.nick}:#{msg.content} #{msg.time}"
        
        # 消息处理 ，只操作群
        # if msg.type == 'group'
        
        content = msg.content.trim()
        replied = false
        reply = (content)=>
            @reply_message(msg,content) unless replied
            replied = true
            
        @plugin_control.dispatch(content ,reply, @ , msg)
            
        
        
    
    _create_message : (event)->
        value = event.value
        msg = 
            content : value.content.slice(-1).pop()
            time    : new Date(value.time * 1000)
            from_uin: value.from_uin
            type    : if value.group_code then 'group' else 'buddy'
            
        if msg.type == 'group'
            msg.from_gid = msg.from_uin
            msg.group_code = value.group_code
            msg.from_uin = value.send_uin # 这才是用户,group消息中 from_uin 是gid
            msg.from_group = @get_group( {gid:msg.from_gid} )
            msg.from_user  = @get_user_ingroup( msg.from_uin ,msg.from_gid )
        else if msg.type == 'buddy'
            msg.from_user = @get_user( msg.from_uin )
        msg
        
            
# class Message
#     constructor: (@struct)->
#         @content = @struct.content.slice(-1).pop
#         @time    = new Date(@struct.time * 1000)
            
            
module.exports = QQBot    