<<<<<<< HEAD
from django.test import TestCase
from sports.models import Person, Hall
from django.contrib.sessions.models import Session
import os

# Create your tests here.
class HallOfFameTest(TestCase):
    def test_home(self):
        response = self.client.post('/', {'username': 'fengzq15', 'password': 'fengzhiqi3916'})
        self.assertEqual(response.content, b'{"message": "first"}')
        response = self.client.get('/index/hall_of_fame')
        self.assertEqual(response.status_code, 200)
    def test_login(self):
        object = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        person = Hall.objects.get(name='冯志奇')
        self.assertEqual('2017', person.year)
        self.assertEqual('test', person.introduction)
        self.assertEqual('test', person.strength)
        self.assertEqual('冯志奇1home1homesr.jpeg', person.image)
        
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        self.assertEqual(response.content, b'{"message": "used"}')
        
        response = self.client.post('/index/hall_of_fame', {'type': 'delete', 'name':'冯志奇'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
    def test_delete(self):
        object = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        response = self.client.post('/index/hall_of_fame', {'type': 'delete', 'name':'冯志奇'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
class HallOfFamePersoninfoTest(TestCase):
    def test_home(self):
        response = self.client.post('/', {'username': 'fengzq15', 'password': 'fengzhiqi3916'})
        self.assertEqual(response.content, b'{"message": "first"}')
        object = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        response = self.client.get('/index/hall_of_fame/personinfo',{'showname':'冯志奇'})
        self.assertEqual(response.status_code, 200)
        
        response = self.client.post('/index/hall_of_fame', {'type': 'delete', 'name':'冯志奇'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
    def test_edit(self):
        object = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        
        response = self.client.post('/index/hall_of_fame/personinfo',{'type':'edit', 'name':'冯志奇', 'sex':'男', 'personclass':'计51', 'introduction_self':'test', 'grade':'2015', 'honor':'test'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
        response = self.client.post('/index/hall_of_fame', {'type': 'delete', 'name':'冯志奇'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
class HallOfFameInterviewTest(TestCase):
    def test_home(self):
        response = self.client.post('/', {'username': 'fengzq15', 'password': 'fengzhiqi3916'})
        self.assertEqual(response.content, b'{"message": "first"}')
        object = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        response = self.client.get('/index/hall_of_fame/interview',{'showname':'冯志奇'})
        self.assertEqual(response.status_code, 200)
        response = self.client.post('/index/hall_of_fame', {'type': 'delete', 'name':'冯志奇'})
        self.assertEqual(response.content, b'{"message": "ok"}')
    
    def test_submit_and_delete(self):
        object = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame', {'image':object, 'type': 'submit', 'name':'冯志奇', 'year':'2017', 'introduction':'test', 'strength':'test'})
        
        image = open('./sports/static/images/1home1homesr.jpeg','rb')
        response = self.client.post('/index/hall_of_fame/interview',{'image':image,'type':'submit', 'name':'冯志奇', 'date':'2017.08.08', 'title':'测试', 'url':'http://www.baidu.com', 'description':'测试'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
        response = self.client.post('/index/hall_of_fame/interview',{'image':image,'type':'submit', 'name':'冯志奇', 'date':'2017.08.08', 'title':'测试', 'url':'http://www.baidu.com', 'description':'测试'})
        self.assertEqual(response.content, b'{"message": "used"}')
        
        response = self.client.post('/index/hall_of_fame/interview',{'address':'interview冯志奇1home1homesr.jpeg','type':'delete'})
        self.assertEqual(response.content, b'{"message": "ok"}')
        
        response = self.client.post('/index/hall_of_fame', {'type': 'delete', 'name':'冯志奇'})
        self.assertEqual(response.content, b'{"message": "ok"}')
=======
from django.test import TestCase
from sports.models import Person


# Create your tests here.
class LoginTest(TestCase):
    def test_home(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

    def test_login(self):
        self.assertEqual(len(Person.objects.filter(username='reborn')), 0)
        response = self.client.post('/', {'username': 'reborn', 'password': 'reborn1001'})
        self.assertEqual(response.content, b'{"message": "first"}')
        person = Person.objects.get(username='reborn')
        self.assertEqual('18271209621', person.phone)
        self.assertEqual('', person.studentId)
        response = self.client.post('/', {'username': 'reborn', 'password': 'reborn1001'})
        self.assertGreater(len(Person.objects.filter(username='reborn')), 0)
        self.assertEqual(response.content, b'{"message": "ok"}')
        response = self.client.post('/', {'username': 'reborn', 'password': 'wrong'})
        self.assertEqual(response.content, b'{"message": "wrong"}')
        response = self.client.post('/', {'username': 'reborn_reborn', 'password': 'wrong'})
        self.assertEqual(response.content, b'{"message": "no"}')
       
>>>>>>> beauty-ui
