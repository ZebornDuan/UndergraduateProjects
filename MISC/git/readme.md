# 版本控制 Version Control

## 软件版本

### 软件版本命名规则
版本号由二至四个部分组成：主版本号、次版本号、内部版本号和修订号。主版本号和次版本号是必选的；内部版本号和修订号是可选的，但是如果定义了修订号部分，则内部版本号就是必选的。所有定义的部分都必须是大于或等于 0 的整数。

1.GNU 风格的版本号命名格式

```
主版本号 . 子版本号 [. 修正版本号 [.编译版本号]]
Major_Version_Number.Minor_Version_Number[.Revision_Number[.Build_Number]]
示例 : 1.2.1, 2.0, 5.0.0 build-13124
```
2.Windows 风格的版本号命名格式 :

```
主版本号 . 子版本号 [ 修正版本号 [.编译版本号]]
Major_Version_Number.Minor_Version_Number[Revision_Number[.Build_Number]]
示例: 1.21, 2.0
```
3.`.Net Framework` 风格的版本号命名格式:
```
主版本号.子版本号[.编译版本号[.修正版本号]]
Major_Version_Number.Minor_Version_Number[.Build_Number[.Revision_Number]]
``` 
4.开发者软件版本名称

α（alpha）内部测试版
α版，此版本表示该软件仅仅是一个初步完成品，通常只在软件开发者内部交流，也有很少一部分发布给专业测试人员。一般而言，该版本软件的 bug 较多，普通用户最好不要安装。

β（beta）外部测试版
该版本相对于α版已有了很大的改进，消除了严重的错误，但还是存在着一些缺陷，需要经过大规模的发布测试来进一步消除。这一版本通常由软件公司免费发布，用户可从相关的站点下载。通过一些专业爱好者的测试，将结果反馈给开发者，开发者们再进行有针对性的修改。该版本也不适合一般用户安装。

γ（gamma）版
该版本已经相当成熟了，与即将发行的正式版相差无几。

## 版本控制工具git的使用

### git命令

使用git进行版本控制需要明确以下几个概念：

- Workspace：工作区
- Index / Stage：暂存区
- Repository：仓库区（或本地仓库）
- Remote：远程仓库

他们之间的关系可以参考以下这张图：
![git](http://www.ruanyifeng.com/blogimg/asset/2015/bg2015120901.png)

图上的命令即为使用最频繁的基本git命令，其他常用的git命令请参考这篇[blog](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)。

与远程仓库相关的操作请参考这篇[blog](http://www.ruanyifeng.com/blog/2014/06/git_remote.html)。需要明确远程主机和追踪关系的概念，理解origin参数的意义和来源，因为绝大多数情况下远程主机只有一个，这些概念容易被忽略。什么时候会有多个远程主机的情况呢？举个例子，你想要对别人的开源项目进行改进或贡献，这时在GitHub上你需要先fork别人的项目，这时候在你自己的远程主机上就会新建一个fork出的仓库，而你的本地仓库就可能需要同时追踪在你自己远程主机上这个fork出的仓库和别人的远程主机的原始项目，如果你想向别人的仓库推送代码，就需要通过pull request把提交到自己fork出的仓库里的代码申请合并到别人所有的原始仓库。pull request的操作可以参考这篇[blog](https://blog.csdn.net/qq_33429968/article/details/62219783)。

在实际的开发工作过程中，对每次代码提交的commit message的格式有一定的约定，并且软件发布新版本时会根据这些commit message生成change log来说明与上一个版本之间的差异。commit message的格式与change log的生成请参考这篇[blog](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)。

值得一提的是，版本控制系统的远程仓库是保存在远程服务器上的，与远程仓库的交互也是需要远程服务器支持的。因此不同的版本控制系统所提供的服务支持是有些许差异的，在使用时需要区别对待。常用的开源软件版本控制与协作开发的服务提供商是*GitHub*，其也提供付费私有仓库的支持，国内的中文版本控制服务提供商有*码云*等。企业级常用的私有服务提供商有*GitLab*。除了基本的版本控制服务之外，有时在多人协作的过程中需要对代码进行自动化审查或人工审查，根据审查结果决定某个提交是否可以合并到远程分支还是需要进行修改，这样的代码review系统通常使用*Jenkins + Gerrit + Git*的套件服务（关于套件可以参考这篇[blog](https://blog.csdn.net/mr_raptor/article/details/76223233)，或在互联网上查阅更多资料）。有时候也把单元测试和某些自动化测试作为代码提交前的必要检查，只有通过这些检查的代码才能够被提交，这种场景下可以通过git的hook文件来进行配置，详情参考[使用git中hook文件做代码提交前的检查](https://blog.csdn.net/O4dC8OjO7ZL6/article/details/79620420)。

### 图形化版本控制工具

图形化的版本控制工具提供图形界面的操作方式，能够完成一些常用的版本控制命令的功能，使用图形化工具的好处主要是能够直观的展现不同分支和提交的变化，且在处理分支合并的冲突时能够便捷的通过点击来选择需要保留的代码。

git自身具备一个图形界面工具，即git GUI，在安装git时可以选择性的进行安装。其使用可以参考这篇[blog](https://blog.csdn.net/qq_34842671/article/details/70916587)和这篇[blog](https://www.cnblogs.com/wangzhongqiu/p/6251054.html)，更多资料可以在互联网上查找。

相比git GUI，一款名为*SourceTree*的图形化版本控制工具的功能更加强大，界面也更加精致，支持Windows和Mac系统。SourceTree内集成了常用的git工作流，遵循其工作流便能完成功能的开发。SourceTree的安装和使用可以参阅互联网上的资料。

