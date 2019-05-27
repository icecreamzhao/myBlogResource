---
title: javafx springboot+maven打包
date: 2019-05-16 22:46:34
categories:
- Java
- Javafx
tags:
- Java
- Javafx
---

# 前言

最近在用javafx写窗体应用, 突发奇想既然都是java, 是不是可以使用springboot来开发? 上网一搜还真有, 本片摘自[JavaFx系列教程之一：JavaFx+Springboot+Maven 开发打包教程](https://segmentfault.com/a/1190000014037443#articleHeader2)

<!--more-->
# 依赖

javafx的springboot支持库, 官方的没有, 开源的有不少, 我使用的是[springboot-javafx-support](https://github.com/roskenet/springboot-javafx-support), 这个库文档比较全, [文档地址](https://www.felixroske.de/page/programmierung/index.html)。

maven的javafx[打包工具](https://github.com/javafx-maven-plugin/javafx-maven-plugin)。

# Maven配置

新建一个maven工程, 并将依赖和插件配置好, 主要如下:

```xml
<properties>
    <spring.boot.version>1.5.1.RELEASE</spring.boot.version>
    <springboot-javafx-support.version>1.3.15</springboot-javafx-support.version>
</properties>
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
        <version>${spring.boot.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
        <version>${spring.boot.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-log4j2</artifactId>
        <version>${spring.boot.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <version>${spring.boot.version}</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>de.roskenet</groupId>
        <artifactId>springboot-javafx-support</artifactId>
        <version>${springboot-javafx-support.version}</version>
    </dependency>
</dependencies>
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
        <plugin>
            <groupId>com.zenjava</groupId>
            <artifactId>javafx-maven-plugin</artifactId>
            <configuration>
                <mainClass>com.littleboy.main.Main</mainClass>
                <vendor>littleboy</vendor>
            </configuration>
        </plugin>
    </plugins>
</build>
```

> 其中，比较重要的是：`<mainClass>com.littleboy.main.Main</mainClass>` 这个是打包的时候的 main 类。`<vendor>littleboy</vendor>`是组织名称。

# MainController

配置好之后就可以编写启动类了:

```java
@SpringBootApplication
public class Main extends AbstractJavaFxApplicationSupport {

    @Override
    public void start(Stage primaryStage) {
        //TODO
    }

    public static void main(String[] args) {
        launch(args);
    }
```

# 打包

可以直接使用idea的artifacts来进行打包, 打包之后有可能会报找不到主类, 需要在`manifest file`中指定主类。
