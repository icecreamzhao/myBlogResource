---
title: SpringBoot配置单数据源
date: 2019-03-21 07:46:23
categories:
- 后端
- java
- spring
tags:
- java
- spring
---

# 前言

上一篇博客讨论了如何快速构建SpringBoot项目, 这一篇博客接着讨论如何在SpringBoot中配置单数据源。
<!--more-->

# 配置h2数据源

由于h2是内存数据库, 相对来说比较容易配置, 所以先从h2开始。

首先将依赖选择好, 要包括h2, jdbc。

接着在main所在的类中, 配置数据源:

```java
@Autowired
private java.sql.DataSource dataSource;
```

对, SpringBoot会自动装配好数据源, 接着我们将数据库的连接字符串打印出来, 所以完整的代码是这样的:

```java
/**
 * 这里实现CommandLineRunner是为了
 * 实现在SpringBoot项目启动的时候
 * 做一些工作, 我们这里需要打印连接字符串
 */
@SpringBootApplication
@Slf4j
public class Application implements CommandLineRunner {
    @Autowired
    private DataSource dataSource;

    public static void main(String[] args) {
        Application.run(Application.class, args);
    }

    /**
     * 我们需要在启动的时候做的工作就写在这里 
     */
    @Override
    public void run(String ...args) Throws Excetpion {
        showConnection();
    }

    private void showConnection() throws SQLException {
        log.info(dataSource.toString());
        Connection conn = dataSource.getConnection();
        log.info(conn.toString());
        conn.close();
    }
}
```

# 配置dbcp2数据源

也相对比较简单, 需要我们在`properties`文件中指定driverClassName, url等信息:

application.properties:
```properties
# 开放actuator的所有节点
management.endpoints.web.exposure.include=*

# 这里修改spring的默认数据源
spring.datasource.type=org.apache.commons.dbcp2.BasicDataSource

spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/springboottestdb?serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=password

spring.datasource.dbcp2.max-wait-millis=10000
spring.datasource.dbcp2.min-idle=5
spring.datasource.dbcp2.initial-size=5
```

这里修改了spring的默认数据源之后, 就可以将指定的数据源自动装配了。

# 不使用自动配置的方式来配置数据源

我们还可以自己去手写bean来配置我们的数据源:

配置类:
```java
@Configuration
@EnableTransactionManagement
public class ConDataSource {

    @Autowired
    private Environment mEnvironment;

    @Bean(name = "ownDataSource")
    public DataSource dataSource() throws Exception {
        Properties properties = new Properties();
        properties.setProperty("driverClassName", mEnvironment.getProperty("spring.datasource.driver-class-name"));
        properties.setProperty("url", mEnvironment.getProperty("spring.datasource.url"));
        properties.setProperty("username", mEnvironment.getProperty("spring.datasource.username"));
        properties.setProperty("password", mEnvironment.getProperty("spring.datasource.password"));
        return BasicDataSourceFactory.createDataSource(properties);
    }

    @Bean
    public PlatformTransactionManager transactionManager() throws Exception {
        return new DataSourceTransactionManager(dataSource());
    }
}
```

再修改一下`application`中的dataSource的变量名为`ownDataSource`, 就可以了。

# springboot的自动配置注解

我们在第一次和第二次配置数据源的时候并没有声明bean提供给spring, 那么spring是怎么找到这个数据源的呢?

是通过如下注解来实现自动装配数据源的:

    @DataSourceAutoConfiguration
    配置DataSource
    @DataSourceTransactionManagerAutoConfiguration
    配置DataSourceTransactionManager
    @JdbcTemplateAutoConfiguration
    配置JdbcTemplate

## 数据源相关配置属性

通用:

* spring.datasource.url=jdbc:mysql://127.0.0.1/test
* spring.datasource.username=dbuser
* spring.datasource.password=dbpassword
* spring.datasource.driver-class-name=com.mysql.jdbc.Driver(可选)

最后一个是可选的, springboot会根据url自动选择相对应的driver。
