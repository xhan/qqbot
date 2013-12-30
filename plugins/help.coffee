HELP_INFO = """
    version         #版本信息和关于
    plugins         #查看载入的插件
    time            #显示时间    
    echo            #重复后面的话
    help            #本内容    
"""

VERSION_INFO = """
    v1.0.0 qqbot
    http://github.com/xhan/qqbot
    本工具还由 糗事百科 热血赞助！
"""

###
 @param content 消息内容
 @param send(content)  回复消息
 @param robot qqbot instance
 @param message 原消息对象
###

# 问题：方式不优雅，应该是一个模式识别成功，别的就不应调用到
module.exports = (content ,send, robot, message)->
    
    
    if content.match /^help$/i
        send HELP_INFO 
        
    if content.match /^VERSION$/i
        send VERSION_INFO
        
    if content.match /^plugins$/i
        send "插件列表：\n" + robot.plugin_control.plugins.join('\r\n')
        
    if content.match /^time$/i
        send "冥王星引力精准校时：" + new Date()
    
    if content.match /^杰杰$/
        send "你说的是传说中的杰杰大美女吗，没错她和你想的一样！"

    ret = content.match /^echo (.*)/i
    if ret 
        send "哈哈，" + ret[1]
        
        