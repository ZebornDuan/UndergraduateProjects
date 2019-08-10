# 体育赛事报名系统

## 简介

该项目是为清华大学计算机系开发的体育赛事报名登记系统。系统账号采用清华大学计算机系门户网站[Accounts9](https://accounts.net9.org/)的登录账号和口令进行验证。首次登录需要完善相关的个人信息，部分信息系统会从Accounts9自动获得，若信息有变可以更改。系统用户分为三个不同的特权级，即用户，管理员与超级管理员。用户仅能浏览赛事信息和报名赛事，管理员能够新建和编辑赛事、审核报名人员与编辑站点页面。超级管理员仅一人，除了管理员的权限，超级管理员还能够更改其他人员的权限。管理员可导出报名人员名单，并编辑邮件通知运动员。

## 如何运行该系统

```
python manage.py makemigrations
python manage.py migrate

python init.py

init.py 运行时会对站点内容进行默认内容的初始化，并指定超级管理员的Accounts9账号，之后超级管理员可登录编辑站点内容。

python manage.py runserver 0.0.0.0:8000 端口可自行选择
```

## 预览

![](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/RegistrationSystem/sports/static/images/preview1.png)
![](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/RegistrationSystem/sports/static/images/preview2.png)
![](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/RegistrationSystem/sports/static/images/preview3.png)
![](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/RegistrationSystem/sports/static/images/preview4.png)
![](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/RegistrationSystem/sports/static/images/preview5.png)


## 使用到的第三方库

[bootstrap](http://www.bootcss.com/)

[jquery](https://jquery.com/)

[bootstrap-datetimepicker](http://www.bootcss.com/p/bootstrap-datetimepicker/)

[kindeditor](http://kindeditor.net/demo.php)