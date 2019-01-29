---
title: 商城开发笔记-根据实体类自动建表
categories:
  - 开发笔记
  - 商城
  - 配置篇
tags:
  - 商城开发
---

# 前言

我们在 [商城开发笔记-pojo,dao,interface,service的依赖](/my_project/shopping_mall/Dependence_and_configuration/Shopping-mall-developNote-pojo-dao-interface-service-depend.html) 和 [商城开发笔记-service的配置](/my_project/shopping_mall/Dependence_and_configuration/Shopping-mall-developNote-service-config.html) 讨论过这个项目的pojo, dao, interface和service的依赖, 我们使用的是mybatis提供的`mybatis-generator`插件, 来生成实体类和mapper, 但是如果添加或者修改表结构的话, 就得使用sql来直接修改。 hibernate可以根据实体类来创建或者修改表, 那么我们今天要使用另一个插件, `ACTable`来让mybatis也支持这个功能。

这个插件我在 [读mybatis-enhance开源项目](/categories/read-open-source/Java/mybatis-enhance/) 这个分类中详细介绍过, 对这个插件感兴趣的话可以移步。
<!--more-->
## 添加依赖

首先我们需要在`parent`模块中将这个依赖添加进来:
parent的pom.xml的properties部分:

```xml
<mybatis.actable.version>1.0.4</mybatis.actable.version>
```

dependencyManagement部分:

```xml
<dependency>
    <groupId>com.gitee.sunchenbin.mybatis.actable</groupId>
    <artifactId>mybatis-enhance-actable</artifactId>
    <version>${mybatis.actable.version}</version>
</dependency>
```
最后我们需要在dao, pojo和service模块中都加入这个依赖:
```xml
<dependency>
    <groupId>com.gitee.sunchenbin.mybatis.actable</groupId>
    <artifactId>mybatis-enhance-actable</artifactId>
</dependency>
```

# 配置

其实人家在 [码云](http://git.oschina.net/sunchenbin/mybatis-enhance) 的项目介绍中就已经将配置说的很清楚了, 那么接下来我来根据我们这个项目来聊一下具体的配置。


## 实体类配置

例子:
```java
@Table(name = "MyTable")
public class MyTable implements Serializable {
  @Column(name = "Id", type = MySqlTypeConstant.BIGINT, length = 20, isKey = true, isAutoIncrement = true)
  private long id;

  @Column(name = "Name", type = MySqlTypeConstant.VARCHAR, length = 50, isNull = false, defaultValue = "")
  private String name;

  /********get set 方法就不写了*******/
}
```
其实很简单, 一看就可以看明白, 在实体类顶部需要声明`@Table`注解, 指定表名。
在字段顶部声明`@Column`注解, 指定各种属性。

## 模式设置

这个插件提供了三种模式, 分别是:

1. 当mybatis.table.auto=create时，系统启动后，会将所有的表删除掉，然后根据model中配置的结构重新建表，该操作会破坏原有数据。
2. 当mybatis.table.auto=update时，系统会自动判断哪些表是新建的，哪些字段要修改类型等，哪些字段要删除，哪些字段要新增，该操作不会破坏原有数据。
3. 当mybatis.table.auto=none时，系统不做任何处理。

可以使用配置文件来进行设置(autoCreateTable.properties):
```properties
mybatis.table.auto=update
mybatis.model.pack=配置用于实体类的包名
```
## xml配置

我们这个项目的数据库配置文件是service模块的`application-dao.xml`, 所以直接修改这个文件就可以了。

OK, 下面是原来的配置文件:
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

我们这里先将刚才设置模式的配置文件引入进来:
```xml
<bean id="configProperties" class="org.springframework.beans.factory.config.PropertiesFactoryBean">
    <property name="locations">
        <list>
            <value>classpath:conf/db.properties</value>
            <value>classpath*:conf/autoCreateTable.properties</value>
        </list>
    </property>
</bean>
<bean id="propertyConfigurer" class="org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer">
    <property name="properties" ref="configProperties" />
</bean>
```
原先的配置使用了简写的形式, 和下面的写法是等价的:
```xml
<bean id="configProperties" class="org.springframework.beans.factory.config.PropertiesFactoryBean">
    <property name="location" value="classpath*:conf-descriptor.properties"/>
</bean>
<bean id="propertyConfigurer" class="org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer">
    <property name="properties" ref="configProperties" />
</bean>
```
简写的形式也可以配置多个文件, 使用逗号分隔, 像这样:
```xml
<context:property-placeholder location="classpath:conf/db.properties, classpath*:conf/autoCreateTable.properties" />
```

mybatis的的sqlSessionFactory的配置也需要改一下:
```xml
<bean id="sqlSessionFactory" class="com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="configLocation" value="classpath:mybatis/sqlMapConfig.xml" />
    <property name="mapperLocations">
        <array>
            <value>classpath*:mapper/*.xml</value>
            <value>classpath*:com/gitee/sunchenbin/mybatis/actable/mapping/*/*.xml</value>
        </array>
    </property>
    <property name="typeAliasesPackage" value="com.littleboy.pojo.*" />
</bean>
```
和原来比只多加了一行, 最后是mapper扫描器, 需要在basePackage属性中将这个插件的dao的包路径也添加进来。
```xml
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage"
              value="com.gitee.sunchenbin.mybatis.actable.dao.*;com.littleboy.dao.*" />
    <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
</bean>
```