###

插件支持两个方法调用
 init(robot)
 received(content,send,robot,message)
 stop(robot)
 
 1.直接使用 
 module.exports = func 为快捷隐式调用 received 方法
 2.或
 module.exports = {
   init:      init_func       # 初始化调用
   received:  received_func   # 接受消息
   stop:      init_func       # 停止插件（比如端口占用）
 }
 
 
###

HELP_INFO = """
    version/about   #版本信息和关于
    plugins         #查看载入的插件
    time            #显示时间
    echo 爱你        #重复后面的话
    help            #本内容
    uptime          #服务运行时间
    roll            #返回1-100随机值
"""

fs = require 'fs'
Path = require 'path'
file_path = Path.join __dirname, "..", "package.json"
bundle = JSON.parse( fs.readFileSync file_path )

VERSION_INFO = """
    v#{bundle.version} qqbot
    http://github.com/xhan/qqbot
    本工具还由 糗事百科 热血赞助！
"""

###
 @param content 消息内容
 @param send(content)  回复消息
 @param robot qqbot instance
 @param message 原消息对象
###

# IMPROVE: 方式不优雅，应该是一个模式识别成功，别的就不应调用到
module.exports = (content ,send, robot, message)->

  if content.match /^help$/i
    send HELP_INFO

  if content.match /^VERSION|ABOUT$/i
    send VERSION_INFO

  if content.match /^plugins$/i
    send "插件列表：\n" + robot.dispatcher.plugins.join('\r\n')

  if content.match /^time$/i
    send "冥王星引力精准校时：" + new Date()

  if ret = content.match /^echo (.*)/i
    send ret[1]
      
  if content.match /^uptime$/i
    secs  = process.uptime()    
    [aday,ahour]  = [86400 ,3600]
    [day,hour,minute,second] = [secs/ aday,secs%aday/ ahour,secs%ahour/ 60,secs%60].map (i)-> parseInt(i)
    t = (i)-> "0#{i}"[-2..] # 让时间更漂亮
    memory = process.memoryUsage().rss / 1024 / 1024
    send "up #{day} days, #{t hour}:#{t minute}:#{t second} | mem: #{memory.toFixed(1)}M"
    
  if content.match /^roll$/i
    # TODO:who? , need a reply method
    send Math.round( Math.random() * 100)