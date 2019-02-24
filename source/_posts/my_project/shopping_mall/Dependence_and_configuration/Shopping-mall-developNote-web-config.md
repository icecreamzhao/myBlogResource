---
title: 商城开发/商城开发笔记-web的配置
date: 2018-11-27 23:30:43
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
---

# Spring MVC的配置

主要包括了注解配置, 拦截器配置, 自动扫描配置和最重要的dubbo配置 ~~其实还包括一个静态资源配置, 但是因为咱们的前端使用的是vue, Spring MVC就不用管这里了~~

<!--more-->

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="
        http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://code.alibabatech.com/schema/dubbo http://code.alibabatech.com/schema/dubbo/dubbo.xsd
        http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.0.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <mvc:annotation-driven />
    <mvc:default-servlet-handler />
    <!-- 相当于注册了DefaultAnnotationHandlerMapping和AnnotationMethodHandlerAdapter两个bean
    配置一些messageconverter
    即解决了@Controller注解的使用前提配置。 -->
    <!-- https://blog.csdn.net/jbgtwang/article/details/7359592 -->
    <!-- https://scotch.io/@ethanmillar/spring-mvc-component-scan-annotation-config-annotation-driven -->

    <mvc:interceptors>
        <mvc:interceptor>
            <mvc:mapping path="/**" />
            <bean class="com.littleboy.interceptor.CommonInterceptor">
                <property name="excludedUrls">
                    <list>
                        <value>/</value>
                    </list>
                </property>
            </bean>
        </mvc:interceptor>
    </mvc:interceptors>
    <!-- spring + ajax 请求时, 会遇到 403 的解决方案 -->
    <!-- https://blog.csdn.net/qq_25152183/article/details/53158222 -->

    <context:property-placeholder location="classpath:conf/db.properties" />

    <context:component-scan base-package="com.littleboy.controller" />

    <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="${web.view.prefix}" />
        <property name="suffix" value="${web.view.suffix}" />
    </bean>

    <!-- 静态资源配置 -->
    <!--<mvc:resources mapping="/resources/**" location="shopping_mail_front/static/**" />-->

    <!-- 声明需要使用的dubbo服务的工程名 -->
    <dubbo:application name="manager" />
    <!-- 声明需要使用的dubbo的注册中心地址 -->
    <dubbo:registry protocol="zookeeper" address="127.0.0.1:2182" />
    <!-- 声明需要使用的具体服务名 -->
    <dubbo:reference interface="com.littleboy.service.ItemService" id="itemService" />
    <dubbo:reference interface="com.littleboy.service.ItemCatService" id="itemCatService" />
</beans>
```

我们来仔细的说一说这个配置, 顺便也帮我自己梳理一下Spring MVC的基础。

一上来, 就是两个我们不怎么熟悉的配置

`<mvc:annotation-driven />` `<mvc:default-servlet-handler />`

没关系, 我们来一个一个讲。

<br>

## <mvc:annotaion-driven />

这个其实是简写的一种形式, 通过这种写法能让我们省去很多配置, 它会帮我们自动注册 `DefaultAnnotationHandlerMapping` 和 `AnnotationMethodHandlerAdapter`, 这两个bean是Spring为`@controller`分发请求所必需的。

并提供了数据绑定支持, `@NumberFormatAnnotation` 支持, `@DateTimeFormat` 支持, `@Valid` 支持, 读写xml支持(JAXB), 读写JSON支持(Jackson)

对于Spring的基础, [这篇博客](http://elf8848.iteye.com/blog/875830)讲的很详细, 可以看一看。

<br>

## <mvc:default-servlet-handler />

这个和访问静态资源有关, 访问静态资源有三种方案。

上面算其中一种, 将`/**` url注册到SimpleUrlHandlerMapping的urlMap中, 并把对静态资源的访问转到`org.springframework.web.servlet.resource.DefaultServletHttpRequestHandler`处理并返回, DefaultServletHttpRequestHandler是各个servlet容器默认的servlet。

其他两种分别是:

1. 使用tomcat的defaultServlet来处理静态文件。例子：

   ```xml
   <servlet-mapping>
       <servlet-name>default</servlet-name>  
       <url-pattern>*.jpg</url-pattern>     
   </servlet-mapping>    
   <servlet-mapping>
       <servlet-name>default</servlet-name>    
       <url-pattern>*.js</url-pattern>    
   </servlet-mapping>    
   <servlet-mapping>
       <servlet-name>default</servlet-name>       
       <url-pattern>*.css</url-pattern>      
   </servlet-mapping>
   ```

   每一种静态资源都需要配置一个Servlet

2. 使用Spring的提供的配置来处理。例子:

   ```xml
   <mvc:resources mapping="/images/**" location="/images/" />
   ```

   mapping属性配置了对于静态资源的请求路径, location属性配置了静态资源所在路径。

<br>

## 拦截器

接下来我配置了一个拦截器, 因为当我搭建好项目, 弄好前端, 进行第一次访问时发现报错, 打开f12一看发现了这个:

![Spring+ajax请求被阻塞](/images/Spring+ajax-request-block.png)

我仔细的查了以下, 发现contentType(就是发送请求的文件类型)为三个常用格式以外的格式, 如`application/json` 时, 会先发送一个试探的OPTIONS类型的请求发送给服务端, 这个时候, 修改请求头是没有用的, 因为还没有走到。

这个时候就需要一个拦截器来拦截所有请求, 在所有请求中加上允许跨域的头。

大概是这么写:

```java
/************
 * 拦截器
 ***********/
public class CommonInterceptor implements HandlerInterceptor {
    private List<String> excludedUrls;

    /**
     * 在请求处理之前被调用, 该方法会被最先执行, 之后执行controller方法
     * @param request 请求
     * @param response 返回
     * @param handler
     * @return 请求是否结束, 如果返回值是false, 那么接下来的方法都不会执行
     * @throws Exception
     */
    @Override
    public boolean preHandle(
            HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 设置响应头
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "*");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers",
                "Origin, X-Requested-With, Content-Type, Accept");
        return true;
    }

    /**
     * 在controller的方法执行之后, DispatcherServlet 进行视图渲染之前被执行
     * @param request 请求
     * @param response 返回
     * @param handler
     * @param modelAndView 该dto是已经被controller处理之后的了
     * @throws Exception
     */
    @Override
    public void postHandle(
            HttpServletRequest request, HttpServletResponse response, Object handler,
            @Nullable ModelAndView modelAndView) throws Exception {
    }

    /**
     * 在DispatcherServlet进行了视图渲染之后执行的方法, 主要用于资源清理
     * @param request
     * @param response
     * @param handler
     * @param ex
     * @throws Exception
     */
    @Override
    public void afterCompletion(
            HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws
            Exception {
    }

    public List<String> getExcludedUrls() {
        return excludedUrls;
    }

    public void setExcludedUrls(List<String> excludedUrls) {
        this.excludedUrls = excludedUrls;
    }
}
```

这样浏览器会发送的两个请求就都会成功了。

接下来配置了一个配置文件, 视图解析器。

<br>

# dubbo配置

在service工程中我们接触过一次, 只不过那一次是声明服务, 而这一次是接收服务。

同样也需要声明dubbo服务的工程名以及注册中心地址~~(也就是zookeeper的地址)~~, 然后就是需要使用的服务id和接口了。

<br>

# mybatis配置

其实mybatis的配置文件没有什么东西, 但是, 这个配置文件得有, 所以还是得写一下。

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 别名 -->
    <typeAliases>
        <package name="com.littleboy.pojo"/>
    </typeAliases>
</configuration>
```

<br>

# web配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE web-app PUBLIC
        "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
        "http://java.sun.com/dtd/web-app_2_3.dtd" >
<web-app
        id="WebApp_ID"
        version="3.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://java.sun.com/xml/ns/javaee"
        xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd">

    <display-name>web</display-name>
    <welcome-file-list>
        <welcome-file>helloWorld.html</welcome-file>
    </welcome-file-list>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:spring/spring-mvc.xml</param-value>
    </context-param>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- post 编码问题 -->
    <filter>
        <filter-name>CharacterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>utf-8</param-value>
        </init-param>
    </filter>

    <filter-mapping>
        <filter-name>CharacterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    <!-- 编码结束 -->

    <servlet>
        <servlet-name>manager</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:spring/spring-mvc.xml</param-value>
        </init-param>
    </servlet>

    <!-- 不包括jsp -->
    <servlet-mapping>
        <servlet-name>manager</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
</web-app>
```

随便看看就行了, 没什么难的, 首先加载了Spring配置, 配置了SpringMVC的监听器和过滤器, 设置了Spring的DispatcherServlet, 需要注意, 访问的如果是jsp的话, 是不会被DispatcherServlet处理的。

<br>

ok, 后端配置总算是讲完了, 接下来该聊一聊前端了。