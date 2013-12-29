Web qq 协议
===============
更新时间： 2013.12.30
> 后来发现以及有几个专门的论坛（见首页）在讨论WebQQ接口，所以这里不再更新具体协议，而是调试过程中的问题记录
> 是否有需要的cookie，请求参数，以及http header 比如refer 都可能导致请求失败，最好的办法就是抓包后复制所有信息:D

1.第一次握手，获取加密信息以及是否需要验证码
-----
ptui_checkVC('1','4GJSgm18Bw-8yw5JGKpSOXH-0idqvaCU','\x00\x00\x00\x00\xa5\x13\xed\x18');
* @param1 是否需要验证码
* @param2 默认验证码，如果 @param1 为1 此字段没用 ，密码加密需要
* @param2 密码加密需要

> 这里会取得一些 cookie


2.获取验证码图片（非必要）
-----
> 这里会取得一些 cookie



3.账户密码以及验证码的校验
-----
密码加密方式，略

	ptuiCB('7','0','','0','很遗憾，网络连接出现异常，请您稍后再试。(2220884626)', '123774072'); `参数不对就出现这个`
	ptuiCB('4','0','','0','您输入的验证码不正确，请重新输入。', '123774072');	
	ptuiCB('24','0','','0','很遗憾，网络连接出现异常，请您检查是否禁用cookies。(3972006392)', '123774072'); 
	ptuiCB('4','2','','0','页面过期，请重试。*', '123774072');
	ptuiCB('0','0','link','0','登录成功！', '呼吸 (糗百)');
	[ '3', '0', '', '0', '您输入的帐号或密码不正确，请重新输入。', '2769546520' ]


4.获取额外的cookie
-------
步骤3中 @param3 需要请求一次，并得到登录所需要的所有cookie ，最简单的一步


5.获取登录token
-----        
需要保存的几个参数，当然之前获得的cookie是必要的     
                       
	psessionid : 本次返回值 
	client_id  : 步骤@4 自己生成
	ptwebqq    : 步骤@4 来源cookie
	uin        : 本次返回值
	vfwebqq    : 本次返回值

错误码：  

	{ retcode: 108, errmsg: '' } `缺少cookie`
	{ retcode: 103, errmsg: '' } `缺少cookie`


6.长轮训
-----
错误码 108 应该也是 cookie



7.获取用户，群分组
-----
群分组非常简单，用户接口有个hash的字段。相传这个加密函数更新的比较及时。  
用js写的好处就不用每次跟着重新实现一套了，复制过来执行就好  
http://0.web.qstatic.com/webqqpic/pubapps/0/50/eqq.all.js  搜索 P=function

	{"retcode":100101} `没cookie` or `ua 未设置好`











{"retcode":0,"result":{"uin":123774072,"cip":3698387524,"index":1075,"port":60213,"status":"online","vfwebqq":"ef219df9a83ccf1b694e1dda5d6bc354411858941b2560b312ed3124ce869b6982b0ec3229bb718b","psessionid":"8368046764001d636f6e6e7365727665725f77656271714031302e3133332e34312e38340000777c000001d102620760a4786d0000000a405256786255617870636d00000028ef219df9a83ccf1b694e1dda5d6bc354411858941b2560b312ed3124ce869b6982b0ec3229bb718b","user_state":0,"f":0}}


curl --cookie "ptvfsession=4ed78c502c3e3253909baadf4e5ca7ad470ae151209264bb2365b45c3b8d6129311c06b36419d6bd365dcb0f7a4127b6;  confirmuin=12366550; ptisp=; verifysession=h02a6HFTBV3vTV4HI73fn3DXpby9Eco0Ls28EB5IVvRgRMv5V0HsaH1gC5pT1TR8kKXAXhC7lcFBO7OhLFfetk1Cw**" "https://ssl.ptlogin2.qq.com/login?u=1953024456&p=D7EF36B6308BC20698A4C3A8CB882F6C&verifycode=atzt&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10&h=1&ptredirect=0&ptlang=2052&daid=164&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=9-7-82251&mibao_css=m_webqq&t=1&g=1&js_type=0&js_ver=10062&login_sig=V0rPh-Ek7s1uNtzdq1dzhnWVfSElUMVBpuvjFQm1oXnwpVLJ93xWCkFCExJ4qWp4"


ptvfsession=4ed78c502c3e3253909baadf4e5ca7ad470ae151209264bb2365b45c3b8d6129311c06b36419d6bd365dcb0f7a4127b6;
pgv_pvid=1724504990; chkuin=12366550;
confirmuin=12366550; ptisp=;
verifysession=h02a6HFTBV3vTV4HI73fn3DXpby9Eco0Ls28EB5IVvRgRMv5V0HsaH1gC5pT1TR8kKXAXhC7lcFBO7OhLFfetk1Cw**



confirmuin=0; PATH=/; DOMAIN=ptlogin2.qq.com;
ptvfsession=4ed78c502c3e3253909baadf4e5ca7ad470ae151209264bb2365b45c3b8d6129311c06b36419d6bd365dcb0f7a4127b6; PATH=/; DOMAIN=ptlogin2.qq.com;ptisp=; PATH=/; DOMAIN=qq.com;



confirmuin=0;
ptvfsession=4ed78c502c3e3253909baadf4e5ca7ad470ae151209264bb2365b45c3b8d6129311c06b36419d6bd365dcb0f7a4127b6;
ptisp=;





curl "https://ssl.ptlogin2.qq.com/login?u=123774072&p=85FA589B0DA90C0563B9333E8AFCFCA7&verifycode=!CBW&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10&h=1&ptredirect=0&ptlang=2052&daid=164&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=2-24-30502&mibao_css=m_webqq&t=1&g=1&js_type=0&js_ver=10062&login_sig=qBpuWCs9dlR9awKKmzdRhV8TZ8MfupdXF6zyHmnGUaEzun0bobwOhMh6m7FQjvWA"