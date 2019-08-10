# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2018-05-11 07:44
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CompetitionImage',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('person_name', models.CharField(max_length=30)),
                ('competition_name', models.CharField(max_length=50)),
                ('description', models.TextField()),
                ('date', models.CharField(max_length=20)),
                ('address', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Hall',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=10)),
                ('year', models.CharField(max_length=4)),
                ('strength', models.CharField(max_length=100)),
                ('sex', models.CharField(max_length=4)),
                ('personclass', models.CharField(max_length=10)),
                ('image', models.CharField(max_length=1000)),
                ('interview', models.CharField(max_length=1000)),
                ('grade', models.CharField(max_length=10)),
                ('introduction', models.TextField()),
                ('introduction_self', models.TextField()),
                ('honor', models.CharField(max_length=1000)),
            ],
        ),
        migrations.CreateModel(
            name='HallOfFameYear',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('year', models.CharField(max_length=6)),
            ],
        ),
        migrations.CreateModel(
            name='Image',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=20)),
                ('description', models.TextField()),
                ('name', models.CharField(max_length=50)),
                ('address', models.CharField(max_length=10)),
                ('which', models.IntegerField()),
                ('belong', models.CharField(max_length=5)),
            ],
        ),
        migrations.CreateModel(
            name='Interview',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('person_name', models.CharField(max_length=30)),
                ('title', models.CharField(max_length=50)),
                ('description', models.TextField()),
                ('date', models.CharField(max_length=20)),
                ('address', models.CharField(max_length=200)),
                ('url', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Label',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('label', models.CharField(max_length=10)),
                ('belong', models.CharField(max_length=5)),
            ],
        ),
        migrations.CreateModel(
            name='Match',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=10)),
                ('date', models.CharField(max_length=15)),
                ('deadline', models.CharField(max_length=15)),
                ('description', models.TextField()),
                ('number', models.IntegerField()),
                ('checked', models.TextField()),
                ('waiting', models.TextField()),
                ('address', models.CharField(max_length=20)),
                ('belong', models.CharField(max_length=8)),
                ('team', models.CharField(max_length=3)),
                ('size', models.IntegerField()),
                ('group', models.TextField()),
                ('groups', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='News',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField()),
                ('which', models.CharField(max_length=3)),
                ('url', models.TextField()),
                ('where', models.CharField(max_length=5)),
                ('belong', models.CharField(max_length=5)),
            ],
        ),
        migrations.CreateModel(
            name='Person',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=30)),
                ('name', models.CharField(max_length=10)),
                ('priority', models.CharField(max_length=1)),
                ('studentId', models.CharField(max_length=10)),
                ('identity', models.CharField(max_length=18)),
                ('gender', models.CharField(max_length=5)),
                ('phone', models.CharField(max_length=11)),
                ('major', models.CharField(max_length=20)),
                ('size', models.CharField(max_length=3)),
                ('degree', models.CharField(max_length=5)),
                ('email', models.EmailField(max_length=254)),
                ('date', models.CharField(max_length=15)),
                ('studentClass', models.CharField(max_length=4)),
                ('where', models.CharField(max_length=15)),
                ('message', models.TextField()),
                ('finished', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='Sharp9',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=10)),
                ('date', models.CharField(max_length=15)),
                ('deadline', models.CharField(max_length=15)),
                ('description', models.TextField()),
                ('number', models.IntegerField()),
                ('checked', models.TextField()),
                ('waiting', models.TextField()),
                ('address', models.CharField(max_length=20)),
                ('belong', models.CharField(max_length=8)),
                ('team', models.CharField(max_length=3)),
                ('size', models.IntegerField()),
                ('group', models.TextField()),
                ('groups', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='Team',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=10)),
                ('captain', models.CharField(max_length=4)),
                ('phone', models.CharField(max_length=15)),
                ('coach', models.CharField(max_length=10)),
                ('member', models.CharField(max_length=200)),
                ('image', models.CharField(max_length=300)),
                ('introduction', models.TextField()),
                ('introduction_self', models.TextField()),
                ('honor', models.CharField(max_length=2000)),
            ],
        ),
        migrations.CreateModel(
            name='TeamCompetitionImage',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('team_name', models.CharField(max_length=30)),
                ('competition_name', models.CharField(max_length=50)),
                ('description', models.TextField()),
                ('date', models.CharField(max_length=20)),
                ('address', models.CharField(max_length=200)),
            ],
        ),
    ]
