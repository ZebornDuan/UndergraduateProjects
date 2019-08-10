from django.apps import AppConfig
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
from xlwt import *


class SportsConfig(AppConfig):
    name = 'sports'


class Mail(object):
    def __init__(self, sender='630521728@qq.com', password='ibqybbyibzirbcah', address='smtp.qq.com', port=465):
        self.sender = sender
        self.password = password
        self.server = smtplib.SMTP_SSL(address, port)

    def send(self, title, receiver, content):
        message = MIMEText(content, 'html', 'utf-8')
        message['From'] = formataddr(['sport_system', self.sender])
        message['To'] = formataddr(['', ','.join(receiver)])
        message['Subject'] = title
        try:
            self.server.login(self.sender, self.password)
            self.server.sendmail(self.sender, receiver, message.as_string())
            self.server.quit()
        except Exception:
            pass


def Excel(students, data, team=None):
    w = Workbook()
    sheet = w.add_sheet('Sheet1')
    dictionary = {'姓名': 'name', '学号': 'studentId', '班级': 'studentClass', '所在院系': 'major',
                  '身份证号': 'identity', '手机号': 'phone', '所在宿舍': 'where', '攻读学位': 'degree', '生日': 'date', '电子邮箱': 'email',
                  '性别': 'gender', '尺寸': 'size'}
    for i, item in enumerate(data):
        sheet.write(0, i, item)
    if team is not None:
        sheet.write(0, len(data), '队伍')
    for i, j in enumerate(students):
        for k, m in enumerate(data):
            sheet.write(i + 1, k, j[dictionary[m]])
        if team is not None:
            sheet.write(i + 1, len(data), j['team'])
    w.save('list.xls')
