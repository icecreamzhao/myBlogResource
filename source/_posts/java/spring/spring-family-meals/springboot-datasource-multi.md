---
title: springboot配置多数据源
date: 2019-05-19 17:05:15
categories:
- 后端
- java
- spring
tags:
- java
- spring
---

# 前言

[上一篇](/java/spring/spring-family-meals/springboot-datasource-single.html)博客讨论了如何配置单数据源, 这一篇博客接着讨论如何配置多数据源。
<!--more-->

# 配置文件

首先需要将数据源的连接字符串写到配置文件中:

```properties
springtestdb.datasource.url=jdbc:mysql://127.0.0.1:3306/springboottestdb?serverTimezone=UTC
springtestdb.datasource.username=root
springtestdb.datasource.password=password

printer.datasource.url=jdbc:mysql://127.0.0.1:3306/printer?serverTimezone=UTC
printer.datasource.username=root
printer.datasource.password=password
```

# 配置类

接着写配置类:

```java
@Configuration
@EnableTransactionManagement
@Slf4j
public class PrinterDataSource {
    @Bean
    @ConfigurationProperties("printer.datasource")
    public DataSourceProperties printerDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean(name = "printer")
    public DataSource printerDataSource() {
        DataSourceProperties dataSourceProperties = printerDataSourceProperties();
        log.info(dataSourceProperties.getUrl());
        return dataSourceProperties.initializeDataSourceBuilder().build();
    }

    @Bean
    public PlatformTransactionManager printerTransactionManager(DataSource printer) {
        return new DataSourceTransactionManager(printer);
    }
}
```

这里使用了DataSourceProperties将配置文件中的配置设置到了DataSource中, 这样配置了之后, 其他的数据源的配置也可以像这样配置。
