###
  sendp people message
  sendg group  message  
  reload   
###


qqbot = null
exports.init = (robot)->
  console.log "plugin 'debug' inited"
  qqbot = bot
  

module.exports = (content ,send, robot, message)->
  if content.match /^reload$/i
    robot.dispatcher.reload_plugin()
    send "重新加载插件"
    
  if content.match /^xhan$/i
    send "oh works"
