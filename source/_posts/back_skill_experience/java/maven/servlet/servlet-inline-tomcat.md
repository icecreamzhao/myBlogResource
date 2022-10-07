---
title: 使用maven插件创建一个servlet项目
date: 2020-01-09 16:16:28
categories:
- 后端技巧/经验
- java
tags:
- maven
- servlet
---

# 依赖

使用 idea 新创建一个 maven 项目, 不要选择任何模板, 在 `pom.xml` 中添加下列依赖:

<!--more-->

```xml
<packaging>war</packaging>

<properties>
    <jsp-version>2.3.3</jsp-version>
    <servlet-version>4.0.1</servlet-version>
</properties>

<dependencies>
    <dependency>
        <groupId>javax.servlet.jsp</groupId>
        <artifactId>javax.servlet.jsp-api</artifactId>
		<version>${jsp-version}</version>
		<scope>provided</scope>
    </dependency>

    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
		<version>${servlet-version}</version>
        <scope>provided</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.tomcat.maven</groupId>
            <artifactId>tomcat7-maven-plugin</artifactId>
            <version>2.2</version>
            <configuration>
                <path>/</path>
                <port>8090</port>
                <server>tomcat7</server>
            </configuration>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>run</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

> 注意, 这里一定要把 packaging 改成 war

# 目录路径

在 `src/main` 目录下新建一个 `webapp/WEB-INF` 文件夹, 新建一个 `web.xml`, 内容是:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <servlet>
        <servlet-name>hello</servlet-name>
        <servlet-class>Hello</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>hello</servlet-name>
        <url-pattern>/hello</url-pattern>
    </servlet-mapping>
</web-app>
```

# 新建一个servlet

在 `src/main/java` 路径下新建一个 `Hello.java`, 内容是:

```java
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author littleboy
 */

public class Hello extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter printWriter = resp.getWriter();
        printWriter.println("hello");
    }
}
```

# 测试

访问 `http://localhost:8090/hello`, 就可以看到 `hello` 字样了。
