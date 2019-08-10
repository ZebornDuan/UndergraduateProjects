## 容器的基本操作

#### 启动容器

`docker run IMAGE [COMMAND] [ARG...]`

- docker run ubuntu echo 'Hello World'
- docker run -i -t ubuntu /bin/bash
- -i --interactive=true | false 默认为false 打开容器标准输入(交互模式)的选项
- -t --tty=true | false 默认是false 创建伪tty终端的选项
- --name=自定义容器名 为即将创建的容器指定名称 默认自动创建一个名称

`docker start [-i] [NAME/ID]`
- 重新启动已经停止的容器

#### 查看容器

`docker ps [-a] [-l]`
- 默认显示正在运行中的容器
- -a 显示所有容器
- -l 显示最近一次使用的容器

`docker inspect [ID/NAME]`
- 查看指定容器的详细配置信息

#### 删除容器
`docker rm [NAME/ID]`
- 删除已经停止运行的容器

#### 查看容器状态

`docker logs [-f] [-t] [-tail] [ID/NAME]`
- 查看容器日志
- -f --follows=true | false 默认为false 跟踪日志变化的选项
- -t --timestamps=true | false 默认为false 在返回的日志结果上加上时间戳的选项
- --tail="all" 返回结尾多少数量的日志 默认为所有日志

`docker top [NAME/ID]`
- 查看容器内进程状态

#### 设置容器的端口映射

`-p --publish=[]`
- containerPort
	`docker run -p 80 -i -t ubuntu /bin/bash`
- hostPort:containerPort
	`docker run -p 8080:80 -i -t ubuntu /bin/bash`
- ip::containerPort
	`docker run -p 0.0.0.0:80 -i -t ubuntu /bin/bash`
- ip:hostPort:containerPort
	`docker run -p 0.0.0.0:8080:80 -i -t ubuntu /bin/bash`

## 守护式容器

#### 守护式容器
- 能够长期运行
- 没有交互式会话
- 适合运行应用程序和服务

#### 运行守护式容器

1.
	- docker run -i -t IMAGE /bin/bash
	- Ctrl+P Ctrl+Q
	- 退出运行在交互模式下的容器 让容器在后台运行

2.
	- docker attach [NAME/ID]
	- 进入正在运行中的容器的交互模式

3. 
	- docker run -d IMAGE [COMMAND] [ARG..]
	- 启动守护式容器

4. 
	- docker exec [-d] [-i] [-t] [NAME/ID] [COMMAND] [ARG..]
	- 在运行中的容器内启动新的进程

#### 停止守护式容器
1. 
	- docker stop [ID/NAME]
	- 向容器发送停止运行的信号 等容器停止后返回容器的唯一标识

2. 
	- docker kill [ID/NAME]
	- 立即停止正在运行中的容器

## 镜像操作

`docker info`
查看docker配置信息(镜像存储目录)

`docker images [OPTIONS][REPOSITORY]`
- -a --all=false 显示所有镜像 包括中间层镜像
- -f --filter=[] 过滤条件
- --no-trunc=false 以非截断方式显示镜像ID
- -q --quiet=false 只显示镜像ID
- REPOSITORY/TAG能够唯一确定一个镜像 同一个镜像可以对应多个不同的REPOSITORY/TAG

`docker inspect [OPTIONS] [CONTAINER|IMAGE]`
- 查看容器或镜像的详细信息

`docker rmi [OPTIONS] [IMAGE...]`
- -f --force=false force removal of the image
- --no-prune=false do not delete untaged parents

## 获取和推送镜像

#### 查找镜像
- 在docker hub上搜索 https://hub.docker.com
- `docker search [OPTIONS] TERM`
	- --automated=false Only show autamated builds
	- --no-trunc=false Do not truncate output
	- -s --stars=0 Only displays with at least x stars
	- 最多返回25个结果

#### 拉取镜像
- `docker pull [OPTIONS] NAME[:TAG]`
	- -a, --all-tags download all taged images in the repository
- 使用加速镜像服务器
	- 使用registry-mirror选项
		- 修改/etc/default/docker
		- 添加DOCKER_OPTS="--registry-mirror=http://MIRROR-ADDR"
	- www.daocloud.io

#### 推送镜像
- `docker push NAME[:TAG]`

#### 构建镜像

- `docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]`
	- -a, --author="" Author
	- -m, --message="" Commit message
	- -p, --pause=true Pause container during commit

- 使用Dockerfile构建镜像
	- 创建Dockerfile文件
	- `docker build [OPTIONS] PATH | URL | - `
		- --false-rm=false
		- --no-cache=false
		- --pull=false
		- -q, --quiet=false
		- --rm=true
		- -t, --tag=""

## Dockerfile

#### Dockerfile指令
- 指令格式
	- \# Comment
	- INSTRUCTION arguments
- FROM
	- FROM < image > / FROM < image >:< tag >
	- 已经存在的镜像
	- 基础镜像
	- 必须是第一条非注释指令
- MAINTAINER
	- MAINTAINER < name >
	- 指定镜像作者信息 包含镜像所有者和联系信息
- RUN
	- 在镜像构建过程中运行的命令
	- RUN < command > (shell模式)
		- 以/bin/sh -c command的形式执行 `RUN echo hello`
	- RUN ["executable", "param1", "param2"...]  (exec模式)
		- 能够以其他形式的shell运行命令 `RUN ["/bin/bash", "-c", "echo hello"]`
- EXPOSE
	- EXPOSE <  port  >
	- 声明应用程序可能会使用的端口
	- 使用docker run命令时仍然需要用-p选项打开对应的端口
- CMD
	- 在容器启动时运行的命令 会被docker run命令的command选项覆盖 用来指定容器启动时的默认行为
	- CMD ["executable", "param1", "param2"...]  (exec模式)
	- CMD command param1 param2 (shell模式)
	- CMD ["param1", "param2"]  (作为ENTRYPOINT指令的默认参数)
- ENTRYPOINT
	- 与CMD指令类似 但不会被docker run命令中的启动命令command选项覆盖
	- 用--entrypoint=""选项覆盖
	- ENTRYPOINT ["executable", "param1", "param2"...]  (exec模式)
	- ENTRYPOINT command param1 param2 (shell模式)
- ADD/COPY
	- 将文件或目录复制到用Dockerfile构建的镜像中
	- ADD/COPY < src > ... < dest >
	- ADD/COPY ["< src >" ... "< dest >"]  (适用于文件路径中含有空格的情况)
	- 目标路径需要使用镜像中的绝对路径
	- ADD包含类似tar的解压功能 如果单纯复制文件 推荐使用COPY
- WORKDIR
	- 指定容器创建时的工作目录 CMD和ENTRYPOINT指令都将在该目录下执行
	- 推荐使用绝对路径 如果使用相对路径工作路径将会一直传递
- ENV
	- ENV < key > < value >
	- ENV < key >=< value >
	- 指定镜像构建时的环境变量
- USER
	- USER user/USER uid/USER user:group/USER uid:gid/USER uerr:gid/USER uid:group
	- 指定镜像构建和容器运行时的操作用户
- ONBUILD
	- ONBUILD [INSTRUCTION]
	- 镜像触发器 当一个镜像被其他镜像作为基础镜像时执行
	- 会在构建过程中插入指令
- VOLUMN
	- VOLUMN [< / >]

#### Dockerfile构建过程
- 从基础镜像运行一个容器
- 执行一条指令 对容器作出修改
- 执行类似docker commit的操作 提交一个新的镜像层
- 再基于刚提交的镜像运行一个新的容器
- 执行Dockerfile中的吓一跳指令 直至所有指令执行完毕

查看镜像构建过程 `docker history [image]`