---
title: 在Jenkins上创建多分支流水线
date: 2019-12-05 10:12:50
tags:
    - Jenkins
    - Pipeline
categories:
    - Jenkins
    - Pipeline
---

### 准备Jenkinsfile配置文件

#### 准备公共配置文件

新建远程仓库，文件目录结构：

```
# 资源文件
|-- resources
# 执行脚本文件
|-- vars
```
<!-- more -->

新建配置文件`build.groovy`，放在`vars`文件夹下:

```groovy
#!groovy

def call(Map map) {

    pipeline {
        agent any

        environment {
			APP_NAME = "${map.APP_NAME}"
			APP_PORT = "${map.APP_PORT}"
            //非必要，可以设置用于发版
            REMOTE_HOST = "${map.REMOTE_HOST}"
            //程序远程仓库地址
            REPO_URL = "${map.REPO_URL}"
            BRANCH_NAME = "${map.BRANCH_NAME}"
            //非必要
            STACK_NAME = "${map.STACK_NAME}"
        }

        stages {
            stage('获取代码') {
                steps {
                    git([url: "${REPO_URL}", branch: "${BRANCH_NAME}"])
                }
            }

            stage('编译代码') {
                steps {
                    withMaven(maven: 'maven 3.6') {
                        sh "mvn -U -am clean package -DskipTests"
                    }
                }
            }

            stage('构建镜像') {
                steps {
					sh "cp ./target/*.jar ./"
                    sh "docker build -t ${APP_NAME}/${BRANCH_NAME}:1.0-SNAPSHOT ." 
                }
            }
			
			stage('运行镜像') {
                steps {
					sh "if docker ps -a | grep ${APP_NAME}-${BRANCH_NAME};\n then docker rm -f ${APP_NAME}-${BRANCH_NAME}\n echo Remove Docker Container: ${APP_NAME}-${BRANCH_NAME}\n fi"
					sh "docker run -d -p ${APP_PORT}:${APP_PORT} --name ${APP_NAME}-${BRANCH_NAME} ${APP_NAME}/${BRANCH_NAME}:1.0-SNAPSHOT"
                }
            }

        }
    }
}
```

#### 配置Jenkins公共Jenkinsfile库的地址

进入Jenkins的系统管理的系统配置，找到` Global Pipeline Libraries `，配置远程仓库地址：
![在Jenkins上创建多分支流水线-0](/images/在Jenkins上创建多分支流水线-0.png)

#### 准备程序Jenkinsfile配置文件

程序根目录新建Jenkinsfile文件，填写配置：

```groovy
#!groovy

// 在多分支构建下，严格规定Jenkinsfile只存在可以发版的分支上

// 引用在jenkins已经全局定义好的library
library 'aptst-pipeline-library'
def map = [:]

//程序名称
map.put('APP_NAME','aptst-config-server')
//程序端口
map.put('APP_PORT','3344')
// 远程管理节点地址（用于执行发版）
map.put('REMOTE_HOST','xxx.xxx.xxx.xxx')
// 项目github代码地址
map.put('REPO_URL','XXX')
// 分支名称
map.put('BRANCH_NAME','master')
// 服务栈名称，公共配置没配置可以不需要
map.put('STACK_NAME','XXX')

// 调用library中vars目录下的build.groovy脚本
build(map)
```

### Blue Ocean

首先进入Jenkins的Blue Ocean页面，在Jenkins页面左边找到按钮或输入网址`http://<jenkins address>/blue`

![在Jenkins上创建多分支流水线-1](/images/在Jenkins上创建多分支流水线-1.png)

### 创建Pipeline

点击`创建流水线`：

![在Jenkins上创建多分支流水线-2](/images/在Jenkins上创建多分支流水线-2.png)

选择代码仓库，根据你远程仓库选择对应的：

![在Jenkins上创建多分支流水线-3](/images/在Jenkins上创建多分支流水线-3.png)

添加GitHub服务器：

![在Jenkins上创建多分支流水线-4](/images/在Jenkins上创建多分支流水线-4.png)

![在Jenkins上创建多分支流水线-5](/images/在Jenkins上创建多分支流水线-5.png)

选择仓库然后点击创建流水线：

![在Jenkins上创建多分支流水线-6](/images/在Jenkins上创建多分支流水线-6.png)

完整步骤图：

![在Jenkins上创建多分支流水线-7](/images/在Jenkins上创建多分支流水线-7.png)

### 配置webhook

首先让我们看看 [Github官方](https://developer.github.com/webhooks/) 关于Github webhooks的解释： 

> Webhooks allow you to build or set up integrations which subscribe to certain events on GitHub.com.

中文意思就是： webhook允许您构建或设置订阅GitHub.com上某些事件的集成。 通过webhook，我们就可以实现自动化部署。

进入项目GitHub仓库地址，进入**`settings`**，点击**` hook`**，再点击**`Add webhook`**：

![在Jenkins上创建多分支流水线-8](/images/在Jenkins上创建多分支流水线-8.png)

填写Jenkins接收事件地址**`Payload URL`**：

```
http://<Jenkins address>/github-webhook/
```

![在Jenkins上创建多分支流水线-9](/images/在Jenkins上创建多分支流水线-9.png)