###
  send group|buddy|discuss name message
  reload
###



module.exports = (content ,send, robot, message)->
  if content.match /^reload$/i
    robot.dispatcher.reload_plugin()
    send "重新加载插件"
    
  ret = content.match /^send\s+(.*?)\s+(.*?)\s+(.*)/i
  if ret    
    [type,to,msg] = ret[1..3]
    switch type
      when 'group'
        group = robot.get_group {name:to}
        robot.send_message_to_group group, msg, (ret,e)->
          if e
            send "消息发送失败 #{e}"
          else
            send "消息已发送"
        
      when 'buddy' then ""
      when 'discuss' then ""
      
