QQBot 
------
A Hubot adapter for QQ! And also A independence robot lives on the real world.  
FYI: QQ is a instant messaging service widely used in china provided by Tencent.  

基于[WebQQ协议](https://github.com/xhan/qqbot/blob/master/protocol.md)的QQ机器人。命令行工具，由不可思议的CoffeeScript提供支持。  

>DEMO 测试用QQ群：346167134


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


Acts as independence robot
-----
* Install `CoffeeScript` in global by `npm install coffeescript -g`
* Run `npm install` to update dependencies
* Make your own copy of `config.yaml`
* Run `./main.coffee` to keep your bot alive!


功能 Features
-----
* :muscle:  登录（支持验证码）
* :muscle:  监听并派发收到的qq消息，支持群，好友消息
* :muscle:  插件化，目前支持消息的派发
* :muscle:  可作为hubot adapter使用


关于
----
不久前在一个比特币群中发现了有QQ机器人的存在，顿时我就震惊了！管理员可以通过它管理其他成员，群成员也可通过各种指令了解各平台比特币的市场行情。另外惊奇的是居然能自动踢掉刷屏的人，潜力无限，骚动不止！

> 2013.12.28  

* 19:43 搜索了下果然已有好多轮子，但几乎所有的都是闭源付费以及是基于win系统。所以决定测试下基于webQQ协议的可能性。  
* 20:13 有点急功近利了，直接用coffeescript编码有点搞不定的感觉。看会Coffee和node的语法和api  
* 21:18 基本语法和http测试完成 :smile:  

> 2013.12.29   

* 10:23 昨晚一直卡在登录账户验证处，调试到凌晨终于通过登录验证的第一个环节。PS.使用coffee写代码还真是蛮清爽的
* 15:07 去了趟医院，怎么就突然感冒咳嗽头晕了。成功搞定node http post以及获取到qq登录最后一步token。睡会会。  
* 19:43 发现了一款开源的webqq协议的win客户端MingQQ，看截图完成度相当高。对了增加了验证码的支持
* 20:44 增加在线（轮训功能），进度比预期的慢了些。但又发现了些资料和文档，补充在底部。分离qqauth和qqapi

> 2013.12.30

* 08:37 有了第三方的资料文档后进展快了不少，增加获取群信息，发消息接口，抽离了httpclient功能，分离测试脚本auth,api
* 13:11 学习Coffee Class的简单用法，提供了QQBot对象来处理各种接口信息。现已支持简单的poll事件解析
* 18:05 增加回复响应功能，同时写了个比较挫的插件机制，但是至少似乎运作的还算正常！后续得看下hubot的代码学习下设计

> 2014.01.01

* 支持hubot，现已加入豪华午餐！

资料
----
* WebQQ协议     https://github.com/xhan/qqbot/blob/master/protocol.md
* WebQQ协议专题  http://www.10qf.com/forum-52-1.html
* 开源的webqq协议的win客户端 https://code.google.com/p/mingqq/