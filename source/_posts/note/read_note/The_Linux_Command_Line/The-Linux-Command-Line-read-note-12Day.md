---
title: 快乐的Linux命令行笔记-软件包管理系统
date: 2019-02-17 21:28:56
categories:
- 笔记
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- linux
- 快乐的Linux命令行
---

[第一天的笔记-基本的命令和使用方法](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)
[第二天的笔记-操作文件](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)
[第三天的笔记-查阅命令文档并创建命令别名](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)
[第四天的笔记-重定向标准输入和输出以及处理查询结果](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)
[第五天的笔记-命令的展开](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-5Day.html)
[第六天的笔记-快捷键](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-6Day.html)
[第七天的笔记-文件权限](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-7Day.html)
[第八天的笔记-进程](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-8Day.html)
[第九天的笔记-修改shell环境](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-9Day.html)
[第十天的笔记-vim入门](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-10Day.html)
[第十一天的笔记-自定义shell提示符](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-11Day.html)

# 总结
今天主要学习了如何使用包管理系统来进行软件的安装, 下载和更新。
<!--more-->
# 软件包管理

> 一般而言, 大多数发行版分别属于两大包管理技术阵营: Debian的".deb"和红帽的".rpm"。

主要的包管理系统

| 包管理系统 | 发行版(部分列表) |
| :--------- | :--------------- |
| Debian Style (.deb) | Debian, Ubuntu, Xandros, Linspire |
| Red Hat Style (.rpm) | Fedora, CentOS, Red Hat Enterprice Linux, OpenSUSE, Mandriva, PCLinuxOS |

# 软件包管理系统的工作方式

大多数软件由发行商以`包文件`的形式提供, 剩下的则以源码形式存在, 可以手动编译安装。

# 包文件

包文件是一个构成软件包的文件压缩集合。

一个软件包可能由大量程序以及支持这些程序的数据文件组成。除了安装文件之外, 软件包文件也包括关于这个包的源数据。

# 资源库

资源库是一个将专门为这个系统开发的所有的软件包集中的一个位置。


而且一个系统有可能维护着不同的几个资源库, 比如通常会有一个"测试"资源库, 其中包含刚刚建立的软件包, 供测试人员和一些想要体验最新功能的用户使用和测试。还会有一个"开发"资源库, 这个资源库中保存着注定要包含到下一个主要版本中的半成品软件包。


另外还会有包含第三方的资源库, 有些软件包有可能会因为法律, 专利或者DRM反规避问题而不能包含到发行版中。如果想使用他们, 需要手动将他们包含到软件包管理系统的配置文件中。

# 依赖性

软件包管理系统会提供一些依赖项解析方法, 确保安装软件包时, 其所有的依赖也被安装。

# 上层和底层软件包工具

软件包工具分为上层和底层, 底层大致分为两种, 上面已经介绍过了。而上层工具会有很多种。

> 包管理工具

| 发行版 | 底层工具 | 上层工具 |
| :----- | :------: | :------- |
| Debian-style | dpkg | apt-get, aptitude |
| fedora, Red Hat Enterprise Linux, CentOS | rpm | yum |

# 软件包查找工具

| 风格 | 命令 |
| :----- | :------: | :------- |
| Debian | apt-get update; apt-cache search serarch_string |
| Red Hat | yum search search_string |

> 使用yum搜索emacs文本编译器

```shell
yum search emacs
```

> 使用apt搜索

```shell
apt-get update; apt-cache search emacs
```

# 从资源库中安装一个软件包

| 风格 | 命令 |
| :--- | :--- |
| Debian | apt-get update; apt-get install package_name |
| Red Hat | yum install package_name |

> 使用apt来安装emacs文本编译器
```shell
apt-get update; apt-get install emacs
```

# 通过软件包文件来安装软件

> 使用底层工具来直接安装软件包(没有经过依赖解析)

| 风格 | 命令 |
| :--- | :--- |
| Debian | dpkg --install package_file |
| Ret Hat | rpm -i package_file |

# 卸载软件

| 风格 | 命令 |
| :--- | :--- |
| Debian | apt-get remove package_name |
| Red Hat | yum erase package_name |

# 经过资源库来更新软件包

| 风格 | 命令 |
| :--- | :--- |
| Debian | apt-get update; apt-get upgrade |
| Red Hat | yum update |

# 通过软件包文件来升级软件

| 风格 | 命令 |
| :--- | :--- |
| Debian | dpkg --install package_file |
| Red Hat | rpm -U package_file |

# 软件包的安装列表

| 风格 | 命令 |
| :--- | :--- |
| Debian | dpkg --list |
| Red Hat | rpm -qa |

# 确定是否安装了一个软件包

| 风格 | 命令 |
| :--- | :--- |
| Debian | dpkg --status package_name |
| Red Hat | rpm -q package_name |

# 显示安装软件包的信息

| 风格 | 命令 |
| :--- | :--- |
| Debian | apt-cache show package_name |
| Red Hat | yum info package_name |

# 查看安装了某个文件的软件包

| 风格 | 命令 |
| :--- | :--- |
| Debian | dpkg --search file_name |
| Red Hat | rpm -qf file_name |

> 在Red Hat系统中, 查看那个软件包安装了`/usr/bin/vim`这个文件

```shell
rpm -qf /usr/bin/vim
```
