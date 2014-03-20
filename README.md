QQBot
------
A Hubot adapter for QQ! And also A independence robot lives on the real world.  
FYI: QQ is a instant messaging service widely used in china provided by Tencent.  

基于[WebQQ协议](https://github.com/xhan/qqbot/blob/master/protocol.md)的QQ机器人。命令行工具，由不可思议的IcedCoffeeScript提供支持。  

>DEMO 调戏用(测试和交流)QQ群：346167134

功能 Features
-----
* :muscle:  登录和验证码支持
* :muscle:  插件化，目前支持消息的派发（你可以编写各种QA形式的插件，做个小黄鸡完全是可以的！欢迎提交有趣的插件）
* :muscle:  可作为hubot adapter使用
* :muscle:  提供HTTP API支持（比如群通知什么的都能做哦）

用途
-----
* 辅助管理群成员，比如自动清理刷屏用户啊（请自己实现）
* 聊天机器人（请自己实现AI）
* 部署机器人（请了解hubot的概念）
* 通知机器人（监控报警啊什么的，对于天天做电脑前报警还得通过邮件短信提醒多不直接呢）


Acts as Hubot Adapter
------
* Add `hubot-qq` as a dependency in your hubots `package.json`
* Run `npm install` in your hubots directory
* Run hubot with `bin/hubot -a qq`

Configurable Variables

	HUBOT_QQ_ID			#QQ ID
	HUBOT_QQ_PASS		#password
	HUBOT_QQ_GROUP		#group name that hubot listens to
	HUBOT_QQ_IMGPORT    #the port to serve verify-codes
	#for more debug variables plz check src/hubot-qq source file

On LINUX or OSX use `export VARIABLE=VALUE` to set environment variables.


独立作为机器人运行
-----
* Install `CoffeeScript` in global by `sudo npm install -g coffee-script`
* Run `npm install` to update dependencies
* Make your own copy of `config.yaml`
* Run `./main.coffee` to keep your bot alive!

部署
-----
部署环境中一般没法操作`STDIN`和机器人交互，所以现在提供了 `Http Api` 提供验证码输入:
>  GET http://localhost:port/stdin?token=(token)&value=(value)  
我常用的命令 `./main.coffee nologin &>> tmp/dev.log &`


改动
----
https://github.com/xhan/qqbot/blob/master/CHANGELOG.md

资料
----
* WebQQ协议     https://github.com/xhan/qqbot/blob/master/protocol.md
* WebQQ协议专题  http://www.10qf.com/forum-51-1.html
* 开源的webqq协议的win客户端 https://code.google.com/p/mingqq/
* http://webqq-core.googlecode.com/
* https://github.com/im-qq/webqq-core

TODO
---
* 机器人响应前缀
* 支持讨论组
* 图片发送支持
* plugin try-catch , reload on the run


FAQ
---
* QQ纯数字密码的同学，yaml里用 "123456" 代替
