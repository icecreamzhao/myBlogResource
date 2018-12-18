---
title: 商城开发笔记-service的配置
date: 2018-11-26 19:46:23
categories:
- 开发笔记
- 商城
tags:
- 商城开发
---

### 数据库配置

如果把配置写到xml配置文件中会显得很乱, 而且不好改, 如果有多个数据库的话, 会非常不方便, 那么可以单独写到一个配置文件中, 这样如果有多个数据库配置的话, 就可以直接切换配置文件了。

<!--more-->

下面是我的数据库配置文件(db.properties):

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/taotao?useUnicode=true&characterEncoding=utf-8&serverTimezone=UTC
jdbc.username=littleboy
jdbc.password=970711dhz

jdbc.pool.init=1
jdbc.pool.minIdle=3
jdbc.pool.maxActive=20

web.view.prefix=/WEB-INF/views/
web.view.suffix=.html
```



### Spring 配置

Spring 配置主要分为三个, 

1. dao层配置, 也就是数据库配置
2. service层配置
3. 事务配置



#### dao层配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="
        http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <!-- 加载配置文件 -->
    <context:property-placeholder location="classpath:conf/db.properties" />

    <!-- 配置数据库连接池 -->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource" destroy-method="close">
        <property name="url" value="${jdbc.url}" />
        <property name="username" value="${jdbc.username}" />
        <property name="password" value="${jdbc.password}" />
        <property name="driverClassName" value="${jdbc.driver}" />
        <!-- 最大连接数 -->
        <property name="maxActive" value="${jdbc.pool.maxActive}" />
        <!-- 最小空闲连接数 -->
        <property name="minIdle" value="${jdbc.pool.minIdle}" />
    </bean>

    <!-- mybatis 的sqlSessionFactory, 配置了mybatis的配置文件和mapper.xml文件 -->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />
        <property name="configLocation" value="classpath:mybatis/sqlMapConfig.xml" />
        <property name="mapperLocations" value="classpath*:mapper/*.xml" />
    </bean>

    <!-- mapper 扫描器 -->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <property name="basePackage" value="com.littleboy.dao" />
    </bean>
</beans>
```

这里用的数据库连接池是阿里开发的druid, 可自行百度

这里有一个Mapper扫描器和配置mybaits的东西, 这里涉及到了mybatis的自动生成实体类和Mapper, [这篇讲到了这个。](/my_project/shopping_mall/taps/shopping-mall-developNote-mybatis-automatic-generation.html)



#### service 层配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
       xsi:schemaLocation="
        http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
        http://code.alibabatech.com/schema/dubbo http://code.alibabatech.com/schema/dubbo/dubbo.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <!-- 扫描service -->
    <context:component-scan base-package="com.littleboy.service.**" />

    <!-- 使用dubbo发布服务 -->
    <!-- 提供方应用信息, 用于计算依赖关系 -->
    <!-- 服务的工程名 -->
    <dubbo:application name="manager" />

    <!-- 注册中心 -->
    <dubbo:registry protocol="zookeeper"
                    address="127.0.0.1:2182" />

    <!-- 用dubbo协议在20080端口暴露服务 -->
    <dubbo:protocol name="dubbo" port="20080" />
    <!-- 声明需要暴露的服务接口 -->
    <dubbo:service interface="com.littleboy.service.ItemService" ref="itemServiceImpl" timeout="600000"/>
    <dubbo:service interface="com.littleboy.service.ItemCatService" ref="itemCatServiceImpl" timeout="600000" />

</beans>
```

这里除了必要的自动扫描之外, 还有dubbo的配置, 首先声明了服务的工程名, 接着是配置了注册中心的地址, 这里的地址是你的zookeeper的地址。

最后配置了dubbo的端口和服务接口



#### translation 配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx-4.0.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd">
  
    <!-- (事务管理)transaction manager, use JtaTransactionManager for global tx -->
    <bean id="transactionManager"
          class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource" />
    </bean>

    <!-- 配置事务通知属性 -->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <!-- 定义事务传播属性 -->
        <tx:attributes>
            <tx:method name="insert*" propagation="REQUIRED" />
            <tx:method name="update*" propagation="REQUIRED" />
            <tx:method name="edit*" propagation="REQUIRED" />
            <tx:method name="save*" propagation="REQUIRED" />
            <tx:method name="add*" propagation="REQUIRED" />
            <tx:method name="new*" propagation="REQUIRED" />
            <tx:method name="set*" propagation="REQUIRED" />
            <tx:method name="remove*" propagation="REQUIRED" />
            <tx:method name="delete*" propagation="REQUIRED" />
            <tx:method name="change*" propagation="REQUIRED" />
            <tx:method name="get*" propagation="REQUIRED" read-only="true" />
            <tx:method name="find*" propagation="REQUIRED" read-only="true" />
            <tx:method name="load*" propagation="REQUIRED" read-only="true" />
            <tx:method name="*" propagation="REQUIRED" read-only="true" />
        </tx:attributes>
    </tx:advice>

    <aop:config>
        <aop:advisor advice-ref="txAdvice" pointcut="execution(* com.littleboy.service..*.*(..))"/>
    </aop:config>
</beans>
```

没啥可说的, 配置了事务, 并使用aop将事务切入到service中, 可以看看数据库方面的书来补充一下事务方面的知识。



#### web.xml

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
        xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
        http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd">

    <display-name>manager</display-name>

    <!-- 加载 spring 容器 -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:spring/application*.xml</param-value>
    </context-param>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
</web-app>
```

配置了Spring的监听器, 加载Spring容器



下一篇讲web工程的配置。