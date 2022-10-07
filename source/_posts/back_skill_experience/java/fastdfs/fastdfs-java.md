---
title: fastDFS和java
date: 2019-07-25 17:37:35
categories:
- 后端技巧/经验
- java
tags:
- fastdfs
---

# 前言

最近一直再用fastDFS, [上一篇](/java/fastdfs/nginx-fastdfs-config.html)讲了fastDFS如何配置, 那么这一篇我们来讲一讲如何使用Java来上传和下载文件。

<!--more-->

# 依赖配置

首先将依赖配置好:

```xml
<dependency>
    <groupId>net.oschina.zcx7878</groupId>
    <artifactId>fastdfs-client-java</artifactId>
    <version>1.27.0.0</version>
</dependency>
```

还有配置文件:

```xml
connect_timeout_in_seconds = 5
network_timeout_in_seconds = 30

charset = UTF-8

http_anti_steal_token = true
http_secret_key = FastDFS1234567890
http_tracker_http_port = 19192

tracker_server = 127.0.0.1:22192
```

# 工具类

这里怎么写其实都好, 我就先列出我写的:

```java
public class FastDfsUtil {
    private TrackerClient trackerClient = null;
    private TrackerServer trackerServer = null;
    private StorageServer storageServer = null;
    private StorageClient1 storageClient = null;

    public FastDfsUtil(String conf) throws Exception {
        if (conf.contains("classpath:")) {
            String path = URLDecoder.decode(getClass().getProtectionDomain().getCodeSource().getLocation().toString(), "UTF-8");
            path=path.substring(6);
            conf = conf.replace("classpath:",URLDecoder.decode(path,"UTF-8"));
        }
        ClientGlobal.init(conf);
        trackerClient = new TrackerClient();
        trackerServer = trackerClient.getConnection();
        storageServer = null;
        storageClient = new StorageClient1(trackerServer, storageServer);
    }

    /**
     * 上传文件
     * @param fileContent 文件的字节数组
     * @return null为失败
     * @throws Exception
     */
    public String uploadFile(byte[] fileContent) throws Exception {
        return uploadFile(fileContent, null, null);
    }

    /**
     * 上传文件方法
     * <p>Title: uploadFile</p>
     * <p>Description: </p>
     * @param fileContent 文件的内容，字节数组
     * @param extName 文件扩展名
     * @param metas 文件扩展信息
     * @return
     * @throws Exception
     */
    public String uploadFile(byte[] fileContent, String extName, NameValuePair[] metas) {
        String result=null;
        try {
            result = storageClient.upload_file1(fileContent, extName, metas);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (MyException e) {
            e.printStackTrace();
        }
        return result;
    }
```

测试:

```java
String confUrl = this.getClass().getClassLoader().getResource("./fastdfs-client.properties").getPath();
FastDfsUtil fastDFSClient = new FastDfsUtil(confUrl);
String filePath= fastDFSClient.uploadFile("C:\\Users\\littleboy\\Pictures\\Snipaste_2019-03-09_11-32-27.jpg");
System.out.println("返回路径："+filePath);
```

# 总结

大概就酱。
