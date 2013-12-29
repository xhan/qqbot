Web qq 协议
===============
更新时间： 2013.12.29

1.第一次握手，获取加密信息以及是否需要验证码
-----
qqapi.verify_qq

2.获取验证码图片
-----


3.账户密码以及验证码的校验
-----
`https://ssl.ptlogin2.qq.com/login?u=123774072&p=85FA589B0DA90C0563B9333E8AFCFCA7&verifycode=!CBW&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10&h=1&ptredirect=0&ptlang=2052&daid=164&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=2-24-30502&mibao_css=m_webqq&t=1&g=1&js_type=0&js_ver=10062&login_sig=qBpuWCs9dlR9awKKmzdRhV8TZ8MfupdXF6zyHmnGUaEzun0bobwOhMh6m7FQjvWA`

	ptuiCB('7','0','','0','很遗憾，网络连接出现异常，请您稍后再试。(2220884626)', '123774072'); `参数不对就出现这个`
	ptuiCB('4','0','','0','您输入的验证码不正确，请重新输入。', '123774072');	
	ptuiCB('24','0','','0','很遗憾，网络连接出现异常，请您检查是否禁用cookies。(3972006392)', '123774072'); 
	ptuiCB('4','2','','0','页面过期，请重试。*', '123774072');
	ptuiCB('0','0','link,'0','登录成功！', '呼吸 (糗百)');
	[ '3', '0', '', '0', '您输入的帐号或密码不正确，请重新输入。', '2769546520' ]


4.获取登录token
-----
{ retcode: 108, errmsg: '' } `缺少cookie`
{ retcode: 103, errmsg: '' } `缺少cookie`

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