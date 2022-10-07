---
title: vue, 打包, 跨域和 nginx
date: 2020-04-27 06:36:03
categories:
- 配置技巧/经验
- 开发环境配置（运维）
tags:
- 跨域
- nginx
---

# 要解决的问题

* 当一个 vue 项目本地运行时, 如何解决跨域的问题
* 当一个 vue 项目打包, 并部署到 nginx 服务器之后, 如何解决跨域的问题

# 问题说明

## 当一个 vue 项目本地运行时, 如何解决跨域的问题

vue 项目本地开发时, 这个时候使用的是 vue 静态服务器做代理, 这个功能是 http-proxy-middleware 这个模块提供的。
在 vue 2.x 版本中, 我们使用 config/index.js 来配置跨域。
在 vue 3.x 版本中, 使用 vue.config.js 来配置跨域。

<!--more-->

```js
// vue 2.x
module.exports = {
    dev: {
        assetsSubDirectory: 'static',
        assetsPublicPath: '/',
        // 代理列表, 是否开启代理通过[./dev.env.js]配置
        proxyTable: devEnv.OPEN_PROXY === false ? {} : {
            '/proxyApi': {
                target: 'http://192.168.50.37:8085/',
                changeOrigin: true,
                pathRewrite: {
                    '^/proxyApi': '/'
                }
            }
        },
        host: '192.168.50.39', // can be overwritten by process.env.HOST
        port: 8001
    }
}

// vue 3.x
devServer: {
    proxy: {
	    '/proxyApi': {
		    target: 'http://192.168.50.37:8085',
			ws: true,
			// 如果是 https, 则配置 true
			secure: false,
			// 是否允许跨域
			changeOrigin: true,
			pathRewrite: {
			    '^/proxyApi': '/'
			}
		}
	}
}
```

## 当一个项目打包之后, 如何解决跨域的问题

当使用 `npm run build`, 并使用 nginx 作为代理服务器之后, 上面配置的就不好使了, 那么如何解决跨域的问题呢?
因为 vue 本身就支持对应不同的环境使用不同的配置文件, 比如生产环境, 开发环境等。那么可以在生产环境的配置文件中, 将全局的api接口请求地址加上类似于 `http://www.simple.com/apis` 这样的域名, 然后在 nginx 中这样配置:

```
server {
	listen 80;
	//...

	location / {
		// ...
	}
	location /apis/ {
		proxy_pass http://192.168.50.37:8085/;
	}
}
```

这样设置一下, 就可以将 `http://www.simple.com/apis/login` 这样的路径替换成 `http://192.168.50.37:8085/login` 了, 如果没配置的情况之下, 由于域名不同, 所以会有跨域的问题, 而 nginx 在有跨域的问题时, 会先发送一个 options 请求来试探一下是否支持跨域, 这个时候如果服务器不支持 options 请求则会报错, 但是这样设置一下就可以直接替换, 不存在跨域的问题了。
