VERSION_INFO = """
    v1.0.0 qqbot
    http://github.com/xhan/qqbot
"""

module.exports = (robot,message)->
    if message.content.trim().match /^VERSION/i
        robot.reply_message(message, VERSION_INFO)
        return
        
    if message.content.trim().match /^杰杰/
        robot.reply_message(message, "你说的是传说中的杰杰大美女吗，没错她和你想的一样！")