---
title: 商城开发笔记-小知识点-mybatis构建实体类
date: 2018-12-03 21:36:52
categories:
- 开发笔记
- 商城
tags:
- 商城开发
- 小知识点
---

## 思路

主要使用了`org.mybatis.generator.api.MyBatisGenerator`这个类, 该类使用xml文件来对表进行映射, 从而创建对应的实体类。



<!--more-->

## 流程

1. 创建一个用来存储警告信息的list
2. 将映射文件初始化mybatis的配置类中
3. 执行generate()方法



实际操作:

```java
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.internal.DefaultShellCallback;

public class MybatisGenerateClass {
  public static void generateClass() throws Exception() {
    // 1. 创建一个用来存储警告信息的list
    List<String> warningsList = new ArrayList<String>();
    // 2. 将映射文件初始化mybatis的配置类中
    File configFile = new File("你的配置文件.xml");
    boolean overwrite = true;
    ConfigurationParser cp = new ConfigurationParser(warningsList);
    Configuration config = cp.parseConfiguration(configFile);
    DefaultShellCallback callback = new DefaultCallback(overwrite);
    // 3. 执行generate()方法
    MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warningsList);
    myBatisGenerator.generate(null);
  }
}
```



## 映射文件

需要包含:

* 数据库驱动jar
* 数据库链接地址, 账密, 需要注意一点, 我这里将`&`使用了`&amp;`来代表, 并且指定了时区
* 实体类存放的位置以及相关设置
* dao以及映射文件存放位置以及相关设置
* 需要映射的表

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
    <!--数据库驱动,最好不要有中文字符,不然会找不到,使用绝对地址更加稳定-->
    <classPathEntry location="C:\Users\littleboy\.m2\repository\mysql\mysql-connector-java\8.0.11\mysql-connector-java-8.0.11.jar" />
    <context id="DB2Tables"  targetRuntime="MyBatis3">
      	<!--注释规则-->
      	<!--suppressAllComments  false时打开注释，true时关闭注释-->
      	<!--suppressDate  false时打开时间标志，true时关闭...真是反人类啊-->
        <commentGenerator>
            <property name="suppressDate" value="true"/>
            <property name="suppressAllComments" value="true"/>
        </commentGenerator>
      
        <!--数据库链接地址、账号、密码-->
        <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
                        connectionURL="jdbc:mysql://localhost/taotao?characterEncoding=utf8&amp;useSSL=true&amp;serverTimezone=UTC"
                        userId="username"
                        password="password">
        </jdbcConnection>
      
      	<!--mybatis里专门用来处理NUMERIC和DECIMAL类型的策略-->
        <javaTypeResolver>
            <property name="forceBigDecimals" value="false"/>
        </javaTypeResolver>
        <!--生成Model类存放位置-->
        <javaModelGenerator targetPackage="com.littleboy.pojo" targetProject="src">
            <property name="enableSubPackages" value="true"/>
            <property name="trimStrings" value="true"/>
        </javaModelGenerator>
        <!--生成映射文件存放位置-->
        <sqlMapGenerator targetPackage="com.littleboy.dao" targetProject="src">
            <property name="enableSubPackages" value="true"/>
        </sqlMapGenerator>
        <!--生成DaoMapper类存放位置-->
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.littleboy.dao" targetProject="src">
            <property name="enableSubPackages" value="true"/>
        </javaClientGenerator>
        <!--生成对应表及类名,需要记住的一点是逆向工程无法生成关联关系,只能生成单表操作-->
        <table tableName="tb_content" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_content_category" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_item" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_item_cat" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_item_desc" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_item_param" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_item_param_item" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_order" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_order_item" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_order_shipping" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
        <table tableName="tb_user" enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false"></table>
    </context>
</generatorConfiguration>
```

