# ReverseProxyYCTU
# 反向代理教务管理系统

反向代理教务管理系统的目的，就是方便在外网（学校外部网络）使用教务管理系统。

## 使用条件

1. 一台可以在公网环境访问的机器（通常就是云虚拟机），安装系统为Centos 7.4;

2. 一个学生或老师账号，总之要能访问 vpn.yctu.edu.cn;

## 虚拟机环境配置
1. Nginx
2. pptp

## 用到的脚本
1. connect.sh (通过pptp连接vpn)
2. nginx.conf (nginx 的配置文件，很重要)

## 脚本执行顺序
1. 安装Nginx，配置对jwgl.yctu.edu.cn 的反向代理，nginx安装完成后会生成/etc/nginx/nginx.conf 配置文件，参考nginx/nginx.conf，完成反向代理设置

2. 安装PPTP

    0.先安装PPTP VPN客户端 

        yum install -y ppp pptp pptp-setup
    
    1.新建yctu vpn启动服务项

        vim /etc/rc.d/init.d/yctu
 
    2.复制以下文本内容进/etc/rc.d/init.d/yctu
 
        #!/bin/bash
        #chkconfig: 2345 80 90
        #description: Starts and stops the yctu vpn daemon
        pptpsetup -create yctu -server vpn.yctu.edu.cn -username USERNAME -password PASSWORD --start #USERNAME=your student id,PASSWORD=your password of your vpn.yctu.edu.cn
        sleep 3 #just wait for connecting to vpn.yctu.edu.cn successfully
        route add -net 210.28.176.107 netmask 255.255.255.255 dev ppp0 #change the route table,let the address use ssl-vpn channel.
    
    3.添加执行权限
    
        chmod +x /etc/rc.d/init.d/yctu
    
    4.添加yctu vpn服务项

        chkconfig --add yctu
    
    5.设置yctu vpn开机启动
    
        chkconfig yctu on
    
    6.启动yctu VPN服务
    
        service yctu start 
    

3. 添加定时任务，定时重启是因为学校的vpn连接会24小时自动断开，所以就需要添加一个重启脚本，每天00:00重启我们的主机

    1.创建定时

        crontab -e
    
    2.增加以下语句

        00 00 * * * /sbin/reboot  #每天00:00点自动重启服务器

## 结束

至此，我们就完成了反向代理出教务系统的的全部操作.

## 仅限技术研究
