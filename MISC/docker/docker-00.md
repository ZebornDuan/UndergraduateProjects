# Docker 简介

## 什么是容器
- 一种虚拟化的方案
- 操作系统级别的虚拟化
- 依赖于Linux内核特性: Namespace和Cgroups(Contorl Groups)

## 什么是Docker
- 将应用程序自动部署到容器
- Go语言开源引擎 Github地址:[https://github.com/docker/docker](https://github.com/docker/docker)
- 2013年初 dotCloud
- 基于Apache 2.0开源授权协议发行

## Docker的目标
- 提供简单轻量的建模方式
- 职责的逻辑分离
- 快速高效的开发生命周期
- 鼓励使用面向服务的架构

## Docker的使用场景
- 使用Docker容器开发、测试、部署服务
- 创建隔离的运行环境
- 搭建测试环境
- 构建多用户的平台即服务(PaaS)基础设施
- 提供软件即服务(SaaS)应用程序
- 高性能、超大规模的宿主机部署

![Linux容器 VS 虚拟机](https://github.com/DBullet/Resources/blob/master/docker/01.png)

## Docker的基本组成

### Docker Client 客户端/Docker Daemon 守护进程
- C/S架构
- 本地/远程

![Docker C/S架构](https://github.com/DBullet/Resources/blob/master/docker/02.png)
### Docker Image 镜像
- 容器的基石(镜像相当于容器的源代码 类似于对象和类的关系)
- 层叠的只读文件系统
- 联合加载(union mount)

### Docker Container 容器
- 通过镜像启动
- 启动和执行阶段
- 写时复制(Copy on Write)

![Docker 容器](https://github.com/DBullet/Resources/blob/master/docker/03.png)

### Docker Registry 仓库
- 公有 Docker Hub
- 私有

## Docker依赖的Linux内核特性
- Namespaces 命名空间
- Control groups(cgroups)控制组

### Namespaces命名空间
- 编程语言：封装 -> 代码隔离
- 操作系统：系统资源的隔离 进程、网络、文件系统...

- Namespaces命名空间
	- PID(Process ID) 进程隔离
	- NET(Network) 管理网络接口
	- IPC(InterProcess Communication) 管理跨进程通信的访问
	- MNT(Mount) 管理挂载点
	- UTS(Unix Timesharing System) 管理内核和版本标识

### Control groups 控制组
- 用来分配资源
- 来源于google 始于Linux kernel 2.6.24@2007
- cgroups提供的功能
	- 资源限制
	- 优先级设定
	- 资源计量
	- 资源控制

### Docker容器的能力
- 文件系统隔离:每个容器都有自己的root文件系统
- 进程隔离:每个容器运行在自己的进程环境中
- 网络隔离:容器间的虚拟网络接口和IP地址是分开的
- 资源隔离和分组:使用cgroups将CPU和内存之类的资源独立分配给每个Docker容器

![Docker架构](https://github.com/DBullet/Resources/blob/master/docker/04.png)

