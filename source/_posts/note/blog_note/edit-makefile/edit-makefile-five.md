---
title: 《跟我一起写makefile (五)》摘抄
date: 2019-06-04 16:29:42
categories:
- 笔记
- 读博客笔记
- 跟我一起写makefile
tags:
- c++
- 笔记
- makefile
---

# 六、多目标

Makefile 的规则中的目标可以不止一个, 其支持多目标, 有可能我们的多目标同时依赖于一个文件, 并且其生成的命令大体类似, 于是我们就能把其合并起来。当然, 多个目标的生成规则的执行命令是同一个, 这可能会给我们带来麻烦, 不过好在我们可以使用一个自动化变量 "$@", 这个变量表示这目前规则中所有的目标的集合, 看一个例子:

```
bigoutput littleoutput : text.g
	generate text.g -$(subst output,,$@) > $@
```

上述规则等价于:

```
bigoutput: text.g
	generate text.g -big > bigoutput

littleoutput: text.g
	generate text.g -little > littleoutput
```

其中, `-$(subst output,,$@)` 中的 "$" 表示执行一个 Makefile 的函数, 函数名为 subst, 后面的为参数, 这里的这个函数是截取字符串的意思, "$@" 表示目标的集合, 就像一个数组, "$@" 依次取出目标, 并执行命令。

<!--more-->
# 七、静态模式

静态模式可以更加容易地定义多目标的规则, 可以让我们的规则变得更加的弹性和灵活, 我们还是先来看一下语法:

```
<targets ...>: <target-pattern>: <prereq-patterns ...>
	<commands>
	...
```

targets 定义了一系列的目标文件, 可以用通配符, 是目标的一个集合。

target-pattern 是指明了 targets 的模式, 也就是目标集模式。

prepreq-patterns 是目标的依赖模式, 它对 target-pattern 形成的模式进行一次依赖目标的定义。

举个例子: 如果我们的 '<target-pattern>' 定义成 "%.o", 意思是我们的 `<target>` 集合中都是以 ".o" 结尾的, 而如果我们的 `<prereq-patterns>` 定义成 "%.c", 意思是对 `<target-pattern>` 所形成的目标集进行二次定义, 其计算方法是, 取 `<target-pattern>` 模式中的 "%" (也就是去掉了[.o] 这个结尾), 并为其加上 `[.c]` 这个结尾, 形成的新集合。

所以, 我们的"目标模式"或是"依赖模式"中都应该有"%"这个字符, 如果你的文件名中有"%", 那么你可以使用反斜杠"/"进行转义, 来标明真实的"%"字符。

看一个例子:

```
objects = foo.o bar.o
all: $(objects)
$(objects): %.o: %.c
	$(cc) -c $(CFLAGS) $< -o $@
```

上面的例子中, 指明了我们的目标从 `$object` 中获取, "%.o" 表明要所有以 "%.o" 结尾的目标, 也就是 "foo.o bar.o", 也就是变量 `$object` 集合的模式, 而依赖模式 `%.c` 则取模式 "%.o" 的 "%", 也就是 "foo bar", 并为其加上 ".c" 的后缀, 于是, 我们的依赖目标就是 "foo.c bar.c"。而命令中的`$<`和`$@`则是自动化变量, `$<` 表示所有的依赖目标集(也就是 "foo.c bar.c"), `$@` 表示目标集(也就是"foo.o bar.o")。于是, 上面的规则展开后等价于下面的规则:

```
foo.o: foo.c
	$(cc) -c $(CFLAGS) foo.c -o foo.o

bar.o: bar.c
	$(cc) -c $(CFLAGS) bar.c -o bar.o
```

试想, 如果我们的 "%.o" 有几百个, 那种我们只要用这种很简单的 "静态模式规则" 就可以写完一堆规则, 实在太有效率了。我们在看一个例子:

```
files = foo.elc bar.o lose.o

$(filter %.o, $(files)): %.o: %.c
	$(cc) -c $(CFLAGS) $< -o $@

$(filter $.elc, $(files)): %.elc: %.el
	emacs -f batch-byte-compile $<
```

`$(filter %.o, $(files))`表示调用 Makefile 的 filter 函数, 过滤 "$files" 集, 只要其中模式为 "%.o" 的内容。其他的内容, 就不用多说了。

# 八、自动生成依赖性

在 Makefile 中, 我们的依赖关系可能会需要包含一系列的头文件, 比如, 如果我们的 `main.c` 中有一句 `#include "defs.h"`, 那么我们的依赖关系应该是:

```
main.o: main.c defs.h
```

但是如果是一个比较大型的工程, 你必须清楚哪些 C 文件包含了哪些头文件, 并且, 你在加入或删除头文件时, 也需要小心的修改 Makefile, 这是一个很没有维护性的工作。为了避免这种繁重而又容易出错的事情, 我们可以使用 C/C++ 编译的一个功能, 大多数的 C/C++ 编译器都支持一个 "-M" 的选项, 即自动寻找源文件中包含的头文件, 并生成一个依赖关系。例如, 如果我们执行下面的命令:

```
cc -M main.c
```

其输出是:

```
main.o: main.c defs.h
```

于是由编译器自动生成的依赖关系, 这样一来, 你就不必再手动书写若干文件的依赖关系, 而由编译器自动生成了。需要提醒一句的是, 如果你使用 GNU 的 C/C++ 编译器, 你得用 "-MM" 参数, 不然, "-M" 参数会把一些标准库的头文件也包含进来。

那么, 编译器的功能如何与我们的 Makefile 联系在一起呢。因为这样一来, 我们的 Makefile 也要根据这些源文件重新生成, 让 Makefile 自己依赖于源文件? 这个功能不现实, 不过我们可以有其他手段来迂回地实现这一功能。GNU 组织建议把编译器为每一个源文件地自动生成的依赖关系放到一个文件中, 为每一个 `name.c` 的文件都生成一个 `name.d` 的 Makefile 文件, `[.d]` 文件爱你中就存放对应 `[.c]` 文件的依赖关系。

于是, 我们可以写出 `[.c]` 文件和 `[.d]` 文件的依赖关系, 并让 makefile 自动更新或生成 `[.d]` 文件, 并把其包含在我们的主 Makefile 中, 这样, 我们就可以自动化地生成每个文件的依赖关系了。

这里我们给出了一个模式规则来产生`[.d]`文件:

```
%.d: %.c
	@set -e: rm -f $@ ;\
	$(cc) -M (CPPFLAGS) $< > $@. ;\
	sed 's/\($*\)\.o[:]*/\l.o$@:/g' <$@.>$@ ;\
	rm -f $@.
```

这个规则的意思是, 所有的`[.d]`文件依赖于`[.c]`文件, "rm -f$@"的意思是删除所有的目标, 也就是`[.d]`文件, 第二行的意思是, 为每个依赖文件`$<`, 也就是`[.c]`文件生成依赖文件, `$@`表示模式`.d`文件, 如果有一个C文件是name.c, 那么"%"就是name, `.`意为一个随机编号, 第二行生成的文件极有可能是`name.d.12345`, 第三行使用sed命令做了一个替换, 关于sed命令的用法请看相关文档。第四行就是删除临时文件。

总而言之, 这个模式要做的事就是在编译器生成的依赖关系中加入`[.d]`文件的依赖, 即把依赖关系:

> main.o: main.c defs.h

转成:

> main.o main.d: main.c defs.h


于是, 我们的`[.d]`文件也会自动更新了, 并会自动生成了。当然, 你还可以在这个`[.d]`文件中加入除依赖关系之外的东西, 比如: 包括生成的命令也可一并加入, 让每个`[.d]`文件都包含一个完整的规则。一旦我们完成这个工作, 接下来, 我们就要把这些自动生成的规则放进我们的主 Makefile 中。我们可以使用 Makefile 的 `include` 命令, 来引用别的 Makefile 文件, 例如:

```
sources = foo.c bar.c
include $(sources:.c=.d)
```

上述语句中的`$(sources:.c=.d)`中的`.c=.d`的意思是做一个替换, 把变量`$(sources)`所有的`[.c]`的字符串都替换成`[.d]`, 关于这个替换的内容, 在后面我们会有更详细的讲述。因为include是按次序来载入文件, 所以最先载入的`[.d]`文件中的目标会成为默认目标。
