jsons = JSON.stringify

class QQBot
    
    constructor: (@name) ->
        @buddy_info = {}
        @group_info = {}
        @groupmember_info = {}
    
    # @format PROTOCOL `用户分组信息格式`
    save_buddy_info = (@buddy_info)->

    # @format PROTOCOL `群分组信息格式`
    save_group_info = (@group_info) ->
    
    # 获取用户信息
    # @return {nick,uin,flag,face}
    get_user = (uin) ->
        # TODO:加速查询
        users = @buddy_info.info.filter (item)-> item.uin == uin            
        users.pop()
        
    

    # 获取群信息，只支持群 ，支持多关键词搜索
    # @options {key:value} 
    # @return {gid,code,name,flag}
    get_group = (options)->
        groups = @group_info.gnamelist.filter (item)-> 
            for key ,value of options
                return item[key] == value

        