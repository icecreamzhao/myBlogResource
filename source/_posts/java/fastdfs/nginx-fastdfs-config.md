---
title: fastDFS和ngnix的配置 
date: 2019-07-07 09:13:55
categories:
- Java
- fastdfs
- 配置
tags:
- fastdfs
- nginx
---

# 前言

根据[这篇博客](https://blog.csdn.net/qq_34301871/article/details/80060235), 我也是花了半天时间才配置好fastDFS和nginx, 那么话不多说, 开始吧。

<!--more-->

# 下载物料

首先下载[fastDFS的 5.11](https://github.com/happyfish100/fastdfs/releases)版本。

接着下载[fastdfs-nginx-module](https://github.com/happyfish100/fastdfs-nginx-module/releases)

接着下载[libfastcommon](https://github.com/happyfish100/libfastcommon/releases)

接着下载[nginx](http://nginx.org/download/)

**注意, fastdfs 5.11版本对应fastdfs-nginx-module的1.20版本 **

**fastdfs 5.10版本对应fastdfs-nginx-module的1.19版本**

# 系统环境准备

下载所需工具的运行命令:

```shell
yum -y install zlib zlib-devel pcre pcre-devel gcc gcc-c++ openssl openssl-devel libevent libevent-devel perl unzip net-tools wget
```

# 安装libfastcommon

> 约定: 之前的物料的下载路径是 `/home/littleboy/programmingTools/fastdfs`
nginx的下载的路径是 `/home/littleboy/programmingTools/nginx`

首先跳转到物料所在路径:

```shell
cd /home/littleboy/programmingTools/fastdfs
```

解压 libfastcommon:

```
unzip libfastcommon-1.0.39.zip
cd  libfastcommon-1.0.39
ll
```

可以看到一个make.sh。

开始安装:

```shell
./make.sh
./make.sh install
```

不出意外是不会报错的, 然后可以建立软连接:

```shell
ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so
ln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so
```

libfastcommon 安装完毕。

# 安装fastdfs

现在的工作目录是: `/home/littleboy/programmingTools/fastdfs/libcommon-1.0.39`

回到上一级目录, 然后解压fastdfs:

```shell
cd ..
unzip fastdfs-5.11.zip
cd fastdfs-5.11
ll
```

同样的, 执行 make.sh:

```shell
./make.sh
./make.sh install
```

不出意外应该也不会报错, 成功之后可以查看安装目录:

```shell
ll /etc/fastdfs
```

可以看到:

```
-rw-r--r--. 1 root root  1461 7月   6 11:10 client.conf.sample
-rw-r--r--. 1 root root  7927 7月   6 11:10 storage.conf.sample
-rw-r--r--. 1 root root  7389 7月   6 11:10 tracker.conf.sample
```

我们需要所有的文件都复制一份, 去掉sample:

```shell
cp client.conf.sample client.conf
cp storage.conf.sample storage.conf
cp tracker.conf.sample tracker.conf
```

fastDFS安装完毕。

# 安装tracker

首先创建tracker工作目录。

这个目录可以自定义, 用来保存tracker的data和log, 我将它保存在了: `/home/littleboy/programmingTools/fastdfs/fastdfs_tracker`

```
cd ..
mkdir fastdfs_tracker
```

配置tracker:

```
vi /etc/fdfs/tracker.conf
```

找到下面几处修改:

```
line4: disabled=false # 默认开启tracker
line11: port=22122 # 默认端口号
line22: base_path=/home/littleboy/programmingTools/fastdfs/fastdfs_tracker/ # tracker工作目录
line260:  http.server_port=6666 # tracker 服务器端口号, 默认8080
```

保存修改。

启动tracker:

```
service fdfs_trackerd start
```

如果不能启动则试试:

```
systemctl start fdfs_trackerd
```

成功后可以看见:

```
Starting fdfs_trackerd (via systemctl):                    [  OK  ]
```

跳转到 tracker 工作目录下可以看到多了data和log文件夹, 然后我们需要将这个加入开机启动, 首先需要给执行权限:

```
chmod +x /etc/rc.d/rc.total
vi /etc/rc.d/rc.total
```

在这个文件最后加上一句话即可:

```
service fdfs_trackerd start
```

然后我们查看一下tracker端口监听的情况:

```
netstat -unltp|grep fdfs
```

可以看到22122端口监听成功。

# 安装storage

为storage配置工作目录, 由于storage还需要一个目录来存储数据, 所以需要另外多建立一个目录: `fastdfs_storage_data`。

修改 storage 的配置文件——storage.conf:

```
vi /etc/fdfs/storage.conf
```

找到下面几处修改即可:

```
line4: disabled=false # 默认开启
line11: group_name=group1 # 组名
line24: port=23000 # storage端口, 同一个组的stroage的端口号必须一致
line41: base_path=/home/littleboy/programmingTools/fasdfs/fastdfs_storage # 配置storage的工作目录 
line105: store_path_count=1 # 存储路径个数, 这里要和store_path的个数相匹配
line109: store_path0=/home/littleboy/programmingTools/fasdfs/fastdfs_storage_data # 配置storage的存储路径
line118: tracker_server=192.168.1.3:22122 # 配置tracker服务器的ip
line284: http.server_port=8888 # 配置http的端口号, 可以通过这个段口访问stroage
```

保存之后, 创建软连接:

```
ln -s /usr/bin/fdfs_storaged /usr/local/bin
```

启动storage:

```
service fdfs_storaged start
# 如果不能启动可以试试:
systemctl start fdfs_storaged
```

可以看到:

```
Starting fdfs_storaged (via systemctl):                    [  OK  ]
```

同样, 在`/etc/rc.d/rc.local`加上启动语句就可以开机自启。

查看storage是否启动:

```
netstat -unltp | grep fdfs
```

至此, fastdfs配置完成, 最后我们可以查看storage是否被注册到了tracker里去:

```
/usr/bin/fdfs_monitor /etc/fdfs/storage.conf
```

如果成功可以看到 `ip_addr = 192.168.1.3 (localhost.localdomain)  ACTIVE` 字样。

torage安装配置完毕。

# 测试

先修改一下客户端配置文件:

```
vi /etc/fdfs/client.conf

line10: base_path=/home/littleboy/programmingTools/fasdfs/fastdfs_tracker # tracker服务器文件路径

line13: tracker_server=192.168.1.3:22122 # tracker服务器ip和端口号

line57: http.tracker_server_port=6666 # tracker http端口号
```

接下来上传一张图片到centos7测试。

```
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf /root/测试1.png
```

成功之后会返回图片的路径。

> wheel/M00/00/00/wKgBA10ipjGAT1AHAABd0Kc3bLM592.jpg

我们可以去刚才的路径查看是否上传成功:

```
cd /home/littleboy/programmingTools/fasdfs/fastdfs_storage_data/data/00/00
ll
```

data下有256个1级目录, 每级目录下又有256个2级子目录, 总共65536个文件, 新文件会以hash的方式被路由到其中某个子目录下, 然后将文件数据直接作为一个本地文件存储到该目录中。

# FastDFS的nginx模块安装

如果我们直接使用 `http://127.0.0.1:9999/wheel/M00/00/00wKgBA10ipjGAT1AHAABd0Kc3bLM592.jpg`去访问图片, 会发现访问不到, 因为在fastDFS 4.05的时候, 就已经 remove embed HTTP support:

```
Version 4.05  2012-12-30
 * client/fdfs_upload_file.c can specify storage ip port and store path index
 * add connection pool
 * client load storage ids config
 * common/ini_file_reader.c does NOT call chdir
 * keep the mtime of file same
 * use g_current_time instead of call time function
 * remove embed HTTP support
```

我们在使用fastDFS部署一个分布式文件系统的时候, 通过fastDFS的客户端API来进行文件的上传, 下载和删除等操作。同时通过fastDFS的HTTP服务器来提供HTTP访问服务。但是fastDFS的HTTP服务较为简单, 无法提供负载均衡等高性能的服务, 所以fastDFS的开发者——淘宝的架构师余庆同学, 为我们提供了nginx上使用的fastDFS模块。

fastDFS通过tracker服务器, 将文件放在storage服务器存储, 但是同组之间的服务器需要复制文件, 有延迟的问题。假设tracker服务器将文件上传到了192.168.1.3, 文件ID已经返回给客户端, 这时, 后台会将这个文件复制到192.168.1.3, 如果复制没有完成, 客户端就用这个ID在这台服务器上获取文件, 肯定会出现错误。这个fastdfs-nginx-module可以重定向连接到源服务器获取文件, 避免客户端由于复制延迟的问题, 出现错误。

## nginx安装

在安装nginx之前要安装nginx所需要的依赖:

```
yum -y install pcre pcre-devel
yum -y install zlib zlib-devel
yum -y install openssl openssl-devel
```

解压nginx和fastdfs-nginx-module:

```
tar -zxf nginx-1.12.0.tar.gz
unzip fastdfs-nginx-module-1.20.zip
```

然后进入nginx安装目录, 添加fastdfs-nginx-module:

```
./configure --prefix=/usr/local/nginx --add-module=/home/littleboy/programmingTools/fastdfs/fastdfs-nginx-module-1.20/src
```

OK, 大家注意, 这里如果继续make的话, 大概率会报`fdfs_define.h:15:27: 致命错误：common_define.h：没有那个文件或目录` 这个错, 那么就要感谢[这篇博客](https://blog.csdn.net/zzzgd_666/article/details/81911892)的作者了, 那么总是解决办法就是:
修改`fastdfs-nginx-module-1.20/src/config`文件:

```
vi fastdfs-nginx-module-1.20/src/config

line6: ngx_module_incs="/usr/include/fastdfs /usr/include/fastcommon/"
line15: CORE_INCS="$CORE_INCS /usr/include/fastdfs /usr/include/fastcommon/"
```

改了这两行之后, 重新 configure 一下, 然后执行:

```
make
make install
```

nginx的默认目录是/usr/local/nginx, 配置storage nginx:

```
cd /usr/local/nginx/conf
vi nginx.conf
```

注意:

这里是我遇到的第二个坑:

首先第一行:

```
line 2: user nobody;
# 改成:
user root;
line 36: listen 9999;
line 48:
location /wheel/M00 {
    root /home/littleboy/programmingTools/fastdfs/fastdfs_storage_dat    a/data;
    ngx_fastdfs_module;
    proxy_connect_timeout 300;
    proxy_read_timeout 300;
    proxy_send_timeout 300;
}
```

然后进入fastDFS安装时解压过的目录, 将http.conf和mime.types拷贝到/etc/fdfs目录下:

```
cd /home/littleboy/prorammingTools/fastdfs/fastdfs-5.11/conf
cp http.conf /etc/fdfs
cp http.conf /etc/fdfs
cp mime.types /etc/fdfs
```

另外还需要把fastsdfs-nginx-module安装目录的src下的mod-fastdfs.conf也拷贝过来:

```
cp /home/littleboy/programmingTools/fastdfs/fastdfs-nginx-module-1.20/src/mod_fastdfs.conf /etc/fdfs
```

修改mod_fastdfs.conf:

```
vi /etc/fdfs/mod_fastdfs.conf
```

对一下几行进行修改:

```
line10: base_path=/home/littleboy/programmingTools/fastdfs/fastdfs_storage
line40: tracker_server=192.168.1.3:22122
line44: storage_server_port=23000
line53: url_have_group_name = true
line62: store_path0=/home/littleboy/programmingTools/fasdfs/fastdfs_storage_data
line113: group_count = 3

# 在文件的最后设置group
[group1]
group_name=wheel
storage_server_port=23000
store_path_count=2
store_path0=/home/littleboy/programmingTools/fasdfs/fastdfs_storage_data
store_path1=/home/littleboy/programmingTools/fasdfs/fastdfs_storage_data
```

创建M00至storage存储目录的符号连接:

```
ln -s /home/littleboy/programmingTools/fastdfs/fastdfs_storage_data/data/ /home/littleboy/programmingTools/fastdfs/fastdfs_storage_data/M00
```

启动nginx:

```
/usr/local/nginx/sbin/nginx
```

访问127.0.0.1:9999, 可以看到`welcome to nginx`,接下来我们还要配置tracker的nginx。

## 配置tracker nginx

在解压一个nginx:

```
mkdir nginx-1.12.0-2
cd nginx-1.12.0-2
tar -zxf nginx-1.12.0.tar.gz nginx-1.12.0
```

然后再configur一下:

```
./configure --prefix=/usr/local/nginx2 --add-module=/home/littleboy/programmingTools/fastdfs/fastdfs-nginx-module-1.20/src
make
make install
```

接下来还是修改nginx.conf:

```
vi /usr/local/nginx2/conf/nginx.conf

line2: user root;
line35: # 这里加入一个upstream, 指向tracker的nginx地址:
upstream fdfs_wheel {
    server 192.168.1.3:9999;
}

 server {
        listen       9989;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /wheel/M00 {
            proxy_pass http://fdfs_wheel;
        }
        # 省略下面的代码
}
```

启动nginx:

```
/usr/local/nginx2/sbin/nginx
```

现在访问`192.168.1.3:9999/wheel/M00/00/00/wKgBA10ipjGAT1AHAABd0Kc3bLM592.jpg`, 应该就可以访问到图片了。

# 总结

不容易啊不容易。
