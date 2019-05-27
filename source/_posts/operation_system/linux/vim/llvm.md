---
title: 在centos下安装llvm和vim的ycm插件
date: 2019-04-28 22:31:44
categories:
- 操作系统
- linux
tags:
- linux
- llvm
- gcc
- ycm
---

# 前言

原本只是想在vim上装几个插件玩玩, 然后发现了YCM这款插件, 之后, 就有了今天的这篇博客。
经历了连续一个星期的战斗, 终于还是被我安装上了llvm, 更新了gcc的版本和vim的版本, 特此记录一下战斗的过程。
<!--more-->

# 安装YCM

YCM插件可以对代码进行事实上的语义分析, 实现了真正的智能提示和补全插件。

## Vundle

在安装YCM插件之前, 需要先安装一下vim的插件管理器: Vundle。

安装步骤:

### 下载插件

```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### 配置插件

打开~/.vimrc, 在文件头加入以下内容:

```shell
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
```

可以看出, Vundle支持多种形式的插件源, 包括github上的插件, http://vim-srcipts.org/vim/scripts.html 上的插件, 非github上的git插件, 本地硬盘上的插件等。

### 安装插件

打开vim, 运行`:PluginInstall`命令来自动安装插件。

![llvm](/images/linux/computer-operation/llvm.jpg)

我在安装完之后, 再次打开vim, 提示我vim版本低, 最低版本为7.4.143, 好了, 这就是我遇到的第一个坑。

怎么办, 更新vim呗。

## 更新vim

我直接将vim7升级到了vim8, 升级步骤:

### 删除旧版本的vim

```shell
yum remove vim -y
```

### 安装ncurses

这里是它的[简介](https://www.invisible-island.net/ncurses/announce.html)

```shell
* yum install ncurses-devel -y
```

> 如果没有vpn, 八成会下载失败, 可以手工安装:
```shell
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/ncurses-devel-5.9-13.20130511.el7.x86_64.rpm
yum install ncurses-devel-5.9-13.20130511.el7.x86_64.rpm
```

### 下载vim

```shell
git clone https://github.com/vim/vim.git
cd vim/src
make install
```

### 配置环境变量

编辑文件: `/usr/local/bin/bim /etc/profile.d/path.sh`

```sh
#!/bin/bash
export PATH=$PATH:/usr/local/bin/vim
```
source /etc/profile.d/path.sh

ok, vim更新成功, 接下来打开vim的时候发现还是有错误信息:

```shell
YouCompleteMe unavailable: requires Vim compiled with Python (2.7.1+ or 3.4+) support.
Press ENTER or type command to continue
```

这是由于vim不支持python导致的, 可以通过:

```shell
vim --version | grep python
```

来查看是否支持。ok, 这是我遇到的第二个坑, 怎么办, 安装Python呗。

## 安装Python3

### 1. 准备安装环境

```shell
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make gdbm-devel
```

### 2. 编译安装Python 3

[源码下载地址](https://www.python.org/downloads/source)

### 2.1 获取源码

```shell
~$ wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tgz
~$ tar -zxvf Python-3.6.2.tgz
```

### 2.2 编译安装

```shell
~$ cd Python-3.6.2
~$ ./configure prefix=/usr/local/python3
~$ make
~$ sudo make install
~$ sudo ln -s /usr/local/python3/bin/python3 /usr/bin/python3
~$ sudo ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
```

安装好Python了之后, 在vim源码的根目录下使用

```shell
./configure ./configure --enable-multibyte --enable-rubyinterp=yes --enable-pythoninterp=yes --enable-python3interp=yes
make
sudo make install
```

ok, 现在我们的vim已经支持python3了, 那么接着安装YCM。

YCM的vim插件已经安装好了, 接下来安装clang和llvm。

## 安装llvm

### 下载源码

安装svn, 用于下载llvm的源码

```shell
yum install svn -y
```

下载llvm源码

```shell
mkdir llvm_source_build
cd llvm_source_build
co http://llvm.org/svn/llvm-project/llvm/trunk llvm
```

下载clang源码

```shell
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
```

下载clang工具源码(可选)

```shell
cd llvm/tools/clang/tools
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
```

下载Complier-RT源码(可选)

```shell
cd llvm/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
```

### 配置和安装llvm和clang

下载好之后, 就可以编译了。

首先返回到llvm_source_build目录下, 新建一个build目录。

```shell
cd ../../
mkdir build
```

cmake一下:

```shell
cd /build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DCMAKE_INSTALL_PREFIX=/opt/llvm ../llvm
```

上面的-CMAKE_INSTALL_PREDIX=/opt/llvm 表示要安装的目录。

然后我惊讶的发现, cmake的版本太低, 这是我遇到的第三个坑, 怎么办, 升级cmake呗。

### 升级cmake

#### 下载cmake

```shell
wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz
```

#### 解压

```shell
tar xvf cmake-3.6.2.tar.gz && cd cmake-3.6.2/
```

#### 编译安装

```shell
./bootstrap
gmake
gmake install
```

#### 查看编译之后的版本

```shell
/usr/local/bin/cmake --version
```

#### 移除旧版本

```shell
yum remove cmake -y
```

#### 新建软连接

```shell
ln -s /usr/local/bin/cmake /usr/bin/
```

#### 查看版本

```shell
cmake --version
```

在编译安装这一步的时候, 我遇到了gcc的版本太低的问题, 这是我遇到的第四个坑。怎么办, 升级gcc呗。

### 升级gcc

#### 下载gcc

```shell
wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-5.4.0/gcc-5.4.0.tar.gz
tar xvf gcc-5.4.0.tar.gz
cd gcc-5.4.0
```

#### 下载依赖包

```shell
./contrib/download_prerequisites
```

#### 配置编译参数

```shell
cd ..
mkdir gcc-build-5.4.0
cd gcc-build-5.4.0
../gcc-5.4.0/configure --enable-checking=release --enable-languages=c,c++ --disable-multilib
```

#### 编译安装

```shell
make -j4  #允许4个编译命令同时执行，加速编译过程
make install
```

#### 配置环境变量

编译~.bashrc

```shell
export LD_LIBRARY_PATH=/usr/local/gcc-4.9.2/lib64:/usr/local/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/gcc-4.9.2/bin:/usr/local/bin:$PATH
```

#### 查看gcc版本

```shell
gcc -v
g++ -v
```

升级了cmake之后, 让我们来继续编译llvm。

### 编译llvm

```shell
cd llvm_source_build/build
export CC=/usr/local/bin/gcc
export CXX=/usr/local/bin/g++
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" -DCMAKE_INSTALL_PREFIX=/opt/llvm ../llvm
make
sudo make install
```

### 配置环境变量

```shell
#配置一下环境变量
vim /etc/profile
#在末尾添加
export PATH=$PATH:/opt/llvm/bin
```

这里我整整编译了一晚上才编译好, 期间遇到了 `- version GLIBCXX_3.4.20' not found` 的问题, 就是gcc的版本太低, 或者是和配置的gcc的版本不一致, 以下是我参考的所有的博客和文档。

### 编译ycm_core

现在准备工作算是完成了, 现在开始正式开始编译ycm_core

生成makefile文件

```shell
mkdir ycm_build
cd ycm_build
# 这里PATH_TO_LLVM_ROOT的路径应该是你的llvm的build的路径
cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/ycm_temp/llvm_root_dir ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
```

编译makefile

```shell
# 将clang-c复制到ycm插件中
cp -r  ~/programmingTools/llvm/llvm/tools/clang/include/clang-c ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/ClangCompleter/
cmake --build . --target ycm_core --config Release
```

### 编辑ycm的配置文件

```shell
 cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/
```

[【vim】插件管理及代码智能提示与补全环境的配置](https://www.cnblogs.com/zzqcn/p/4660615.html)
[CentOS 7 + vim + ycm (clang) + NERDTree](https://www.zybuluo.com/searcher2xiao/note/136156)
[VIM、YouCompleteMe折腾配置以及clang+llvm编译安装](https://www.jianshu.com/p/c24f919097b3)
[centos升级vim](https://www.cnblogs.com/lavezhang/p/7227777.html)
[CentOS7解决YouCompleteMe对Python的依赖](https://blog.csdn.net/uu203/article/details/82621523)
[安装LLVM+Clang教程](https://blog.csdn.net/l2563898960/article/details/82871826)
[Centos7安装高版本Cmake](https://blog.csdn.net/jiang_xinxing/article/details/77945478)
[Centos升级gcc至5.4.0](https://www.jianshu.com/p/8ac4e50d182d)
[centOS系统gcc升级步骤(亲自测试成功)](https://blog.csdn.net/zhaojianting/article/details/81095120)
[CentOS下gcc4.9编译安装教程](https://www.jianshu.com/p/f0b28fb4661d)
[How to set path for sudo commands](https://superuser.com/questions/927512/how-to-set-path-for-sudo-commands)
[CMake 指定gcc编译版本](https://blog.csdn.net/haohaibo031113/article/details/72833327)
[关于在centos下安装python3.7.0以上版本时报错ModuleNotFoundError: No module named '_ctypes'的解决办法](https://blog.csdn.net/qq_36416904/article/details/79316972)
[Vim智能补全插件YouCompleteMe安装](https://blog.csdn.net/leaf5022/article/details/21290509#comments)
[llvm之旅第一站 － 编译及简单使用](http://www.nagain.com/activity/article/4/)
[Getting Started with the LLVM System](https://blog.csdn.net/zhang14916/article/details/89288196)
[gRPC编译- version `GLIBCXX_3.4.20' not found 问题](https://blog.csdn.net/weixin_34365417/article/details/86870934)
[CentOS 6.4(64位)上安装错误libstdc++.so.6(GLIBCXX_3.4.14)解决办法](https://blog.csdn.net/lqzixi/article/details/24738337)
[linux下提示/usr/lib64/libstdc++.so.6: version `GLIBCXX_3.4.14' not found 解决办法](https://www.cnblogs.com/wx7217242/articles/4684530.html)
[Linux C/C++程序员CentOS 6.5安装YouCompleteMe使用vim语法自动补全](http://www.bubuko.com/infodetail-1978493.html) 这个比较全!
[10款优秀Vim插件帮你打造完美IDE](https://www.cnblogs.com/linuxprobe/p/5926821.html)

