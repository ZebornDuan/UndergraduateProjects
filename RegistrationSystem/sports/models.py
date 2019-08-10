from django.db import models


class Person(models.Model):
    username = models.CharField(max_length=30)
    name = models.CharField(max_length=10)
    priority = models.CharField(max_length=1)
    studentId = models.CharField(max_length=10)
    identity = models.CharField(max_length=18)
    gender = models.CharField(max_length=5)
    phone = models.CharField(max_length=11)
    major = models.CharField(max_length=20)
    size = models.CharField(max_length=3)
    degree = models.CharField(max_length=5)
    email = models.EmailField()
    date = models.CharField(max_length=15)
    studentClass = models.CharField(max_length=4)
    where = models.CharField(max_length=15)
    message = models.TextField()
    finished = models.TextField()

    def __str__(self):
        return self.username


class Match(models.Model):
    name = models.CharField(max_length=10)
    date = models.CharField(max_length=15)
    deadline = models.CharField(max_length=15)
    description = models.TextField()
    number = models.IntegerField()
    checked = models.TextField()
    waiting = models.TextField()
    address = models.CharField(max_length=20)
    belong = models.CharField(max_length=8)
    team = models.CharField(max_length=3)
    size = models.IntegerField()
    group = models.TextField()
    groups = models.TextField()

    def __str__(self):
        return self.name


class Hall(models.Model):
    name = models.CharField(max_length=10)
    year = models.CharField(max_length=4)
    strength = models.CharField(max_length=100)
    sex = models.CharField(max_length=4)
    personclass = models.CharField(max_length=10)
    image = models.CharField(max_length=1000)
    interview = models.CharField(max_length=1000)
    grade = models.CharField(max_length=10)
    introduction = models.TextField()
    introduction_self = models.TextField()
    honor = models.CharField(max_length=1000)

    def __str__(self):
        return self.name


class Sharp9(models.Model):
    name = models.CharField(max_length=10)
    date = models.CharField(max_length=15)
    deadline = models.CharField(max_length=15)
    description = models.TextField()
    number = models.IntegerField()
    checked = models.TextField()
    waiting = models.TextField()
    address = models.CharField(max_length=20)
    belong = models.CharField(max_length=8)
    team = models.CharField(max_length=3)
    size = models.IntegerField()
    group = models.TextField()
    groups = models.TextField()

    def __str__(self):
        return self.name


class Image(models.Model):
    title = models.CharField(max_length=20)
    description = models.TextField()
    name = models.CharField(max_length=50)
    address = models.CharField(max_length=10)
    which = models.IntegerField()
    belong = models.CharField(max_length=5)


class News(models.Model):
    title = models.TextField()
    which = models.CharField(max_length=3)
    url = models.TextField()
    where = models.CharField(max_length=5)
    belong = models.CharField(max_length=5)


class CompetitionImage(models.Model):
    person_name = models.CharField(max_length=30)
    competition_name = models.CharField(max_length=50)
    description = models.TextField()
    date = models.CharField(max_length=20)
    address = models.CharField(max_length=200)


class Interview(models.Model):
    person_name = models.CharField(max_length=30)
    title = models.CharField(max_length=50)
    description = models.TextField()
    date = models.CharField(max_length=20)
    address = models.CharField(max_length=200)
    url = models.CharField(max_length=200)


class HallOfFameYear(models.Model):
    year = models.CharField(max_length=6)


class Label(models.Model):
    label = models.CharField(max_length=10)
    belong = models.CharField(max_length=5)
    
class Team(models.Model):
    name = models.CharField(max_length=10)
    captain = models.CharField(max_length=4)
    phone = models.CharField(max_length=15)
    coach = models.CharField(max_length=10)
    member = models.CharField(max_length=200)
    image = models.CharField(max_length=300)
    introduction = models.TextField()
    introduction_self = models.TextField()
    honor = models.CharField(max_length=2000)
    
class TeamCompetitionImage(models.Model):
    team_name = models.CharField(max_length=30)
    competition_name = models.CharField(max_length=50)
    description = models.TextField()
    date = models.CharField(max_length=20)
    address = models.CharField(max_length=200)
