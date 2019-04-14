---
title: 搭建自己的ngrok服务器
date: 2019-04-13 19:48:36
categories:
- operationAndMaintenance
- net
- ngrok
tags:
- ngrok
---

转自[centos下自己假设ngrok服务器(内网测试神器)](https://segmentfault.com/a/1190000010338848)

# 场景使用

> 因为做开发很多程度需要不断同步git服务器或者其他操作来做一些外部对接的测试
每次更新都要push到远端, 而且有时候代码还未必正式写完, 不仅影响git提交不美观, 而且麻烦
所以ngrok的内网穿透就显神威了
网上有ngrok的国内服务了, 不过有时候不稳定
下面来和我一起架设自己的ngrok服务吧

<!--more-->
# 你需要的物料

* 云服务器或vps

> 如: 阿里云等云服务器最好, 不过阿里云记得用备案域名哦

* 一个域名

> 解析到云服务器或vps的ip
因为以下测试启动了子域名自动部署, 需要域名做泛解析, CNAME填写"*"解析到云服务器的ip

# 环境准备

centos的基础环境

```shell
yum -y install zlib-devel openssl-devel perl hg cpio expat-devel gettext-devel curl curl-devel perl-ExtUtils-MakeMaker hg wget gcc gcc-c++ git
```

# go语言环境

```shell
//请下载合适自己的go语言包  我是centos 6.8 64位 所以选择以下包
wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz
vim /etc/profile
//添加以下内容：
export PATH=$PATH:/usr/local/go/bin
source /etc/profile
//检测是否安装成功go
go version
```

# 安装服务器

下载

```shell
mkdir /ngrok
cd /ngrok
git clone https://github.com/inconshreveable/ngrok.git
```

# 生成证书

```shell
cd /ngrok
mkdir cert
cd cert
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=myngork.com" -days 5000 -out rootCA.pem
openssl genrsa -out device.key 2048
openssl req -new -key device.key -subj "/CN=myngork.com" -out device.csr
openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000
```

# 覆盖原本证书

```shell
yes|cp rootCA.pem /ngrok/ngrok/assets/client/tls/ngrokroot.crt
yes|cp device.crt /ngrok/ngrok/assets/server/tls/snakeoil.crt
yes|cp device.key /ngrok/ngrok/assets/server/tls/snakeoil.key
```

# 编译生成ngrok

```shell
go env //查看环境
GOOS=linux GOARCH=amd64 make release-server
```

# 运行测试

```shell
./bin/ngrokd -tlsKey="assets/server/tls/snakeoil.key" -tlsCrt="assets/server/tls/snakeoil.crt" -domain="myngrok.com"  -httpAddr=":8081" -httpsAddr=":8082" -tunnelAddr=":8083"

#参数说明：
#-domain 访问ngrok是所设置的服务地址生成证书时那个
#-httpAddr http协议端口 默认为80
#-httpsAddr https协议端口 默认为443 （可配置https证书）
#-tunnelAddr 通道端口 默认4443
```

# 后台运行

```shell
cd /ngrok/ngrok
setsid ./bin/ngrokd -tlsKey="assets/server/tls/snakeoil.key" -tlsCrt="assets/server/tls/snakeoil.crt" -domain="myngrok"  -httpAddr=":8081" -httpsAddr=":8082" -tunnelAddr=":8083"
```

# 客户端编译和使用

## 编译生成win64位客户端 (其他自行编译测试)

```shell
GOOS=windows GOARCH=amd64 make release-client
#编译成功后会在ngrok/bin/下面生成一个windows_amd64目录下面有ngrok.exe

#Linux 平台 32 位系统：GOOS=linux GOARCH=386
#Linux 平台 64 位系统：GOOS=linux GOARCH=amd64
#Windows 平台 32 位系统：GOOS=windows GOARCH=386
#Windows 平台 64 位系统：GOOS=windows GOARCH=amd64
#MAC 平台 32 位系统：GOOS=darwin GOARCH=386
#MAC 平台 64 位系统：GOOS=darwin GOARCH=amd64
#ARM 平台：GOOS=linux GOARCH=arm
```

## 简单配置ngrok.cfg


```shell
server_addr: "myngrok.com:8083"
trust_host_root_certs: false
```

## 使用链接测试

```shell
ngrok -config=ngrok.cfg -subdomain=test 80

//出现以下内容表示成功链接：
ngrok

Tunnel Status                 online
Version                       1.7/1.7
Forwarding                    http://test.myngrok.com:8081 -> 127.0.0.1:80
Forwarding                    https://test.myngrok.com:8081 -> 127.0.0.1:80
Web Interface                 127.0.0.1:4040
# Conn                        0
Avg Conn Time                 0.00ms
```

## 复杂配置ngrok.cfg

```shell
erver_addr: "myngrok.com:8083"
trust_host_root_certs: false

tunnels:
    http:
        subdomain: "www"
        proto:
            http: "8081"

    https:
        subdomain: "www"
        proto:
            https: "8082"

    web:
        proto:
            http: "8050"

    tcp:
        proto:
            tcp: "8001"
        remote_port: 5555

    ssh:
        remote_port: 2222
        proto:
            tcp: "22"
```

## 启动服务

```shell
ngrok -config=ngrok.cfg start web  #启动web服务
ngrok -config=ngrok.cfg start tcp  #启动tcp服务

ngrok -config=ngrok.cfg start web tcp  #同时启动两个服务
ngrok -config=ngrok.cfg start-all  #启动所有服务

//出现以下内容表示成功链接：
ngrok

Tunnel Status                 online
Version                       1.7/1.7
Forwarding                    http://web.myngrok.com:8081 -> 127.0.0.1:8050
Forwarding                    tcp://myngrok.com:5555 -> 127.0.0.1:8001
Web Interface                 127.0.0.1:4040
# Conn                        0
Avg Conn Time                 0.00ms
```

## 附上一个bat, 可以部署不同自动启动子域名

```bat
@echo OFF
color 0a
Title ngrok启动
Mode con cols=109 lines=30
:START
ECHO.
Echo                  ==========================================================================
ECHO.
Echo                                         ngrok启动
ECHO.
Echo                                         作者: https://segmentfault.com/u/object
ECHO.
Echo                  ==========================================================================
Echo.
echo.
echo.
:TUNNEL
Echo               输入需要启动的域名前缀，如“test” ，即分配给你的穿透域名为：“test.myngrok.com”
ECHO.
ECHO.
ECHO.
set /p clientid=   请输入：
echo.
ngrok -config=ngrok.cfg -subdomain=%clientid% 80
PAUSE
goto TUNNEL
```

# 附录

> 在编译过程中有可能出现如下情况:

问题1: 

```shell
GOOS="" GOARCH="" go get github.com/jteeuwen/go-bindata/go-bindata
bin/go-bindata -nomemcopy -pkg=assets -tags=release \
-debug=false \
-o=src/ngrok/client/assets/assets_release.go \
assets/client/...
make: bin/go-bindata: Command not found
make: * [client-assets] Error 127
```

解决办法: 前往go安装目录的bin目录下找到go-bindata，将他移动到ngrok/bin下 （没有bin，可新建一个)

问题2:

```shell
package code.google.com/p/log4go: Get https://code.google.com/p/log4go/source/checkout?repo=: dial tcp 216.58.197.110:443: i/o timeout
```

因为google被墙，如果服务器不在墙外或者没有FQ则无法访问到code.google.com.

解决办法: 在 ngrok/src/ngrok/log 目录下找到 logger.go 文件，修改其中第4或5行的：

```
log "code.google.com/p/log4go”为
log "github.com/keepeye/log4go"
```

问题3:

```shell
GOOS="" GOARCH="" go get github.com/jteeuwen/go-bindata/go-bindata
     # github.com/jteeuwen/go-bindata
             src/github.com/jteeuwen/go-bindata/toc.go:47: function ends without a return statement
                     make: *** [bin/go-bindata] Error 2
```

解决办法： https://github.com/inconshreveable/ngrok/issues/237 

问题4:

客户端启动之后, 总是reconnecting

解决办法: 配置一级域名@的解析, 配置上就好了
