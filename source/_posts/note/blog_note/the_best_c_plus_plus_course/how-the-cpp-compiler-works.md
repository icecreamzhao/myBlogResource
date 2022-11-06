---
title: C++ 编译器是如何工作的
date: 2019-10-19 04:51:46
categories:
- 笔记
- 读书笔记
- 最好的cpp教程
tags:
- c++
- 笔记
---

# 需要搞明白的问题

C++ 编译器都做了那些事情?

# 知识点

* 和 java 不同的一点是, java 重视文件, 文件名和文件目录都会影响到 java 项目的编译, 而c++不重视文件, 文件对于c++来说只是用来给编译器提供源码的一种方法。

* cpp 文件可以互相 include。 如果 cpp 不互相 include 的话, 那么一个 cpp 就代表一个 translate unit; 如果互相 include, 那么就对于编译器来说就相当于是一个大的 cpp 文件, 编译之后也是众多有 include 关系的 cpp 编译成一个 translate unit。一个 translate unit 代表一个 obj 文件。

<!--more-->

* `.cpp` 后缀名只是默认约定的编译器处理文件的方式, 如果你不告诉编译器如何处理文件, 那么编译器就会按照默认的方式当作 c++ 文件处理; 但是你也可以告诉编译器, 指定一个后缀名, 将该后缀名的文件当作 c++ 文件来处理。

* 编译好的 obj 文件为什么这么大?
> 因为在预编译头那里引用了其他的头文件, 这意味着在编译之后, 这些头文件的内容会被复制到编译好的文件中。

## 预处理相关的关键字

### head file

关于头文件: 当在使用 `#include "*.h"` 时, 编译器所做的事情是, 将该头文件中所有的内容复制替换到 `#inlclude "*.h"` 语句的位置。

这里有一个例子:

```c++
int multiply(int a, int b)
{
	int result = a * b;
	return result;
#include 'EndBrace.h'
```

EndBrace.h file:

```h
}
```

这里可以看到, `EndBrace.h` 文件中只有一个 `}` , 编译器在遇到 `#include` 时要做的事情就是找到该头文件并把内容复制到当前 include 的位置而已。

### define

关于 define: 当在使用 `#define` 时, 比如 `#define INTEGER int`, 那么编译器会搜索该 cpp 下所有 INTEGER 并替换成 int。

### if 和 endif

关于 if 和 endif: 如果符合 if 的条件, 则 if 块中所有的代码会被放到 obj 文件中, 如果不符合, 则不会。

## linker

链接, 将函数的声明和函数的定义找到并连接在一起。通常一个 C++ 工程由多个 obj 文件构成, 每一个 obj 是一个 translation unit, 而链接器的工作就是将所有 obj 中的符号和函数找到并连接到一起。

# 总结

最后来理一下思路, 编译器要做的事情有两件。第一件: compiling, 编译代码, 将代码编译成 `.obj` 文件, 之后就可以给 linker 用。compiling 期间, 首先预编译代码, 上面的知识点都是 preprocessor 语句, 预处理之后, 会进入 tokenizing (标记解释) 和 parsing (解析) 阶段; 第二件: 链接。
