---
title: 商城开发笔记-给parent配置添加swagger依赖
date: 2019-10-26 16:46:09
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
---

# 介绍

swagger 是一个定义接口文档及接口相关信息的工具, 通过这个工具可以生成各种形式的文档。作为 Java 大一统框架, 当然会将该规范纳入进来, 形成了 Spring-swagger, 现在改成了 Springfox, 那么接下来讲一讲如何引入这个东东。

# 依赖

pom.xml:

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>${swagger.version}</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>${swagger.version}</version>
</dependency>
```

<!--more-->

# 配置

```java
package com.littleboy.config;

import com.google.common.base.Predicate;
import com.littleboy.config.annotation.SwaggerCustomIgnore;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import static com.google.common.base.Predicates.*;
import static springfox.documentation.builders.RequestHandlerSelectors.*;
import static springfox.documentation.builders.PathSelectors.*;

@Configuration
@EnableSwagger2
@ComponentScan(basePackages = "com.littleboy.controller")
public class SwaggerConfig {
	//组织Docket对象，翻译过来就是摘要的意思，它是生成API文档的核心对象，里面配置一些必要的信息
	@Bean
	public Docket swaggerSpringMvcPlugin(){
		//指定规范，这里是SWAGGER_2
		return new Docket(DocumentationType.SWAGGER_2)
				//设定Api文档头信息，这个信息会展示在文档UI的头部位置
				.apiInfo(swaggerDemoApiInfo())
				.select()
				//添加过滤条件，谓词过滤predicate，这里是自定义注解进行过滤
				.apis(not(withMethodAnnotation(SwaggerCustomIgnore.class)))
				//这里配合@ComponentScan一起使用，又再次细化了匹配规则(当然，我们也可以只选择@ComponentScan、paths()方法当中的一中)
				.paths(allowPaths())
				.build();
	}

	/**
	 * 自定义API文档基本信息实体
	 * @return
	 */
	private ApiInfo swaggerDemoApiInfo(){
		//构建联系实体，在UI界面会显示
		Contact contact = new Contact("littleboy", "http://icecreamzhao.github.io", "dahazidk@163.com");
		return new ApiInfoBuilder()
				.contact(contact)
				//文档标题
				.title("Swagger2构建RESTful API文档")
				//文档描述
				.description("SpringBoot集成Springbox开源项目，实现OAS，构建成RESTful API文档")
				//文档版本
				.version("1.0.0")
				.build();
	}

	/**
	 * path匹配规则
	 * @return
	 */
	private Predicate<String> allowPaths(){
		return or(
				regex("/user.*"),
				regex("/role.*")
		);
	}
}
```

SwaggerCustomIgnore:

```java
package com.littleboy.config.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 忽略接口注解
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface SwaggerCustomIgnore {

}
```

# 查看效果

启动项目, 访问`http://localhost:8080/swagger-ui.html` 就可以查看符合条件的接口文档了。
