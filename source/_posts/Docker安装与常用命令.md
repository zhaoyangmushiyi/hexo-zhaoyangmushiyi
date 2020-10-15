---
title: Docker安装与常用命令
date: 2019-01-11 09:04:33
tags:
    - Docker
categories:
    - Docker
---
## CentOS
### yum安装
#### 卸载老版本的Docker
　　在CentOS中，老版本Docker名称是`docker`或`docker-engine`，而Docker CE的软件包名称是`docker-ce`。因此，如已安装过老版本的Docker，需使用如下命令卸载。  
```
sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
```
　　需要注意的是，执行该命令只会卸载Docker本身，而不会删除Docker存储的文件，例如镜像、容器、卷以及网络文件等。这些文件保存在`/var/lib/docker`目录中，需要手动删除。
<!-- more -->
#### 安装仓库
　　执行以下命令，安装Docker所需的包。其中，`yum-utils`提供了`yum-config-manager`工具；`device-mapper-persistent-data`及`lvm2`则是`devicemapper`存储驱动所需的包。
```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```
　　执行如下命令，安装`stable`仓库。必须安装`stable`仓库，即使你想安装`edge`或`test`仓库中的Docker构建版本。
```
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
　　[可选] 执行如下命令，启用`edge`及`test`仓库。`edge/test`仓库其实也包含在了`docker.repo`文件中，但默认是禁用的，可使用以下命令来启用。
```
sudo yum-config-manager --enable docker-ce-edge    # 启用edge仓库
sudo yum-config-manager --enable docker-ce-test    # 启用test仓库
```
　　如需再次禁用，可加上`--disable`标签。例如，执行如下命令即可禁用`edge`仓库。
```
sudo yum-config-manager --disable docker-ce-edge
```
　　TIPS：从`Docker 17.06`起，`stable`版本也会发布到`edge`以及`test`仓库中。

#### 安装Docker CE

　　执行以下命令，更新yum的包索引
```
sudo yum makecache fast
```
　　执行如下命令即可安装最新版本的Docker CE
```
sudo yum install docker-ce
```
　　在生产环境中，可能需要指定想要安装的版本，此时可使用如下命令列出当前可用的Docker版本。
```
yum list docker-ce.x86_64  --showduplicates | sort -r
```
　　这样，列出版本后，可使用如下命令，安装想要安装的Docker CE版本。
```
sudo yum install docker-ce-<VERSION>
```
　　启动Docker
```
sudo systemctl start docker
```
　　验证安装是否正确。
```
sudo docker run hello-world
```
　　这样，Docker将会下载测试镜像，并使用该镜像启动一个容器。如能够看到类似如下的输出，则说明安装成功。
```
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from library/hello-world
    b04784fba78d: Pull complete
    Digest: sha256:f3b3b28a45160805bb16542c9531888519430e9e6d6ffc09d72261b0d26ff74f
    Status: Downloaded newer image for hello-world:latest
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    To generate this message, Docker took the following steps:
     1. The Docker client contacted the Docker daemon.
     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
     3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
     4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.
    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash
    Share images, automate workflows, and more with a free Docker ID:
     https://cloud.docker.com/
    For more examples and ideas, visit:
     https://docs.docker.com/engine/userguide/
```
#### 升级Docker CE

　　如需升级Docker CE，只需执行如下命令：
```
sudo yum makecache fast
```
　　然后按照安装Docker的步骤，即可升级Docker。
#### 参考文档

　　CentOS 7安装Docker官方文档：[Docker for CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)，文档中还讲解了在CentOS 7中安装Docker CE的其他方式，本文不作赘述。
### shell一键安装
```
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
## Windows(docker for windows)
### 系统要求

　　Windows 10 Professional 或 Windows 10 Enterprise X64 或Windows Home 10(Version 2004 or later，Windows Home can only run the WSL 2 backend)

　　对于Win 7 or 低版本Windows 10 Home，可使用Docker Toolbox（不建议使用）
### 安装步骤
　　前往[Docker for Windows 10](https://hub.docker.com/editions/community/docker-ce-desktop-windows)，下载安装包，双击即可安装。

#### 配置Table自动补全

1. 启动一个的PowerShell（即以管理员身份运行）。搜索PowerShell，右键单击，然后选择以管理员身份运行。在PowerShell提示符下键入： 

   ```shell
   Set-ExecutionPolicy RemoteSigned
   ```

2. 检查策略设置是否正确，运行：`get-executionpolicy` ，应该返回RemoteSigned。

3. 安装posh-dockerPowerShell模块以自动完成Docker命令，键入：`Install-Module posh-docker`或者，要仅为当前用户安装模块，键入： 

   ```shell
   Install-Module -Scope CurrentUser posh-docker
   ```

4. 安装完成后，只能为当前PowerShell启用自动完成功能，输入：

   ```shell
   Import-Module posh-docker
   ```

## 配置镜像加速器
### 阿里云加速器
　　注册阿里云账号后，进入[阿里云控制台](https://cr.console.aliyun.com/#/accelerator)。  
　　针对Docker客户端版本大于 1.10.0 的用户，可以通过修改daemon配置文件`/etc/docker/daemon.json`来使用加速器：  

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://arbzyqhz.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```
　　以上内容转载自周立的Docker教程，[Docker系列教程02-Docker安装(CentOS7/Ubuntu/macOS/Windows)](http://www.itmuch.com/docker/02-docker-install/)