---
title: 使用maven来对测试用例进行测试
date: 2019-09-06 10:02:08
categories:
- Java
- maven
tags:
- maven
---

# 前言

真的不容易呀! 搞了树莓派之后, 一直想在树莓派上搞java开发, 也在vim上装了不少的插件, 但是java的编译一直搞得我头痛。忽然想起maven可以对测试用例进行测试, 而且可以自定义编译之后的路径, 非常方便, 所以这就搞起!

<!--more-->

# 需要的依赖

这个东西真的搞了我很久, 先介绍一下都需要哪些依赖:

```xml
<!-- 测试用例 -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.11</version>
    <scope>test</scope>
</dependency>

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
            <source>1.10</source>
            <target>1.10</target>
            <encoding>UTF-8</encoding>
            <showWarnings>true</showWarnings>
            <configuration>
        </plugin>
    </plugins>
</build>
```

**注意, 这里必须是junit的依赖, 我在上maven的中央库中找的时候告诉我移到了新的地址, 然后我就是用的是**

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <version>5.5.1</version>
    <scope>test</scope>
</dependency>
```

**这个, 然后就一直报找不到org.junit这个包, 搞了好久也不好使。**

# 编写与使用测试用例

* 编写测试用例

maven的测试用例默认放到`src/test/java`路径下的, 在运行的时候会查找所有带有@Test注解的方法并运行测试用例, 那么测试用例应该这么写:

```java
import org.junit.Test;

public class Test {
	@Test
	public void test() {
		// 这里放入需要测试的代码
	}
}
```

这样, 一个简单的测试用例就完成了。

* 运行测试用例

直接执行`mvn test`, 会直接运行该项目下的所有测试用例。
如果想要运行`TestPracticeOne.java`下的`testOne()`方法, 可以这样: `mvn -Dtest=TestPracticeOne#testOne test`, 就可以了, 这种方式也支持正则, 比如`mvn -Dtest=TestPracticeOne#test* test`, 这样运行的是所有开头是`test`的方法。

# 参考

更详细的介绍可以参考[maven的官方介绍](https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit.html)。
