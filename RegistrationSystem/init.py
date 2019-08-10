import os, django

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "Sportsys.settings")
django.setup()

from sports.models import Person, Image, Label

if __name__ == '__main__':
    for i in range(1, 4):
        Image.objects.create(address='home-bottom', name='default.jpeg', title='标题', description='详细描述', which=i)
        Image.objects.create(address='home', name='default.jpeg', which=i)

    nine = ['酒井杯篮球赛', '酒井杯足球赛', '酒井杯乒羽联赛', '系运会', '酒井杯排球赛']
    mb = ['男篮', '女篮', '男足', '手球', '田径', '女足', '毽绳', '武术', '排球']
    for item in mb:
        Label.objects.create(label=item, belong='mb')
    for item in nine:
        Label.objects.create(label=item, belong='9#')

    while True:
        print("请选择系统超级管理员")
        name1 = input("请输入超级管理员Accounts9账号\n")
        name2 = input("请再次确认该账号 确保该账号存在且无误\n")
        if name1 == name2:
            Person.objects.create(username=name1, priority='1')
            print("添加超级管理员成功 请登录系统完善个人信息")
            break
        else:
            print("输入不一致 请重新输入")
