from django.http import JsonResponse, HttpResponse
from django.shortcuts import render_to_response, render
from django.db.models import Q, ObjectDoesNotExist
from django.views import View
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from sports.models import Person, Match, Sharp9, Image, News, Label, Hall, CompetitionImage, Interview, HallOfFameYear, \
    Team, TeamCompetitionImage
from sports.apps import Excel, Mail
import lxml.html
import urllib.request
import urllib.parse
import http.cookiejar
import json
import os


class LoginView(View):
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:55.0) Gecko/20100101 Firefox/55.0', }
    check_url = 'https://accounts.net9.org/login'

    def get(self, request):
        images = [{'name': image.name, 'title': image.title,
                   'description': image.description, 'which': image.which}
                  for image in Image.objects.filter(address='home').order_by('which')]
        content = {'images': images}
        for i in range(1, 4):
            image = Image.objects.get(address='home-bottom', which=str(i))
            content['image' + str(i)] = {'name': image.name, 'description': image.description, 'title': image.title}
        return render(request, 'home.html', context=content)

    def post(self, request):
        jar = http.cookiejar.CookieJar()
        handler = urllib.request.HTTPCookieProcessor(jar)
        opener = urllib.request.build_opener(handler)
        urllib.request.install_opener(opener)
        user_name = request.POST.get('username')
        pass_word = request.POST.get('password')
        arguments = urllib.parse.urlencode({'username': user_name,
                                            'password': pass_word,
                                            'submit': "登入"}).encode(encoding='UTF8')
        request_ = urllib.request.Request(self.check_url, headers=self.headers, data=arguments)
        login_result = urllib.request.urlopen(request_).read().decode('utf-8')
        if login_result.find('没有这个用户') != -1:
            return JsonResponse({'message': 'no'})
        elif login_result.find('密码无效') != -1:
            return JsonResponse({'message': 'wrong'})
        else:
            user = Person.objects.filter(username=user_name)
            if len(user) == 0 or (user[0].priority == '1' and user[0].name == ''):
                message = urllib.request.urlopen('https://accounts.net9.org/editinfo').read().decode('utf-8')
                html = lxml.html.fromstring(message)
                name = html.get_element_by_id('surname').get('value') + html.get_element_by_id('givenname').get('value')
                email = html.get_element_by_id('email').get('value')
                phone = html.get_element_by_id('mobile').get('value')
                date = html.get_element_by_id('birthdate').get('value')
                date = date[0:4] + '-' + date[4:6] + '-' + date[6:]
                request.session['user'] = user_name
                if len(user) == 0:
                    Person.objects.create(username=user_name, name=name, email=email, phone=phone, date=date,
                                          priority='3', message=json.dumps([]), finished=json.dumps([]))
                    return JsonResponse({'message': 'first'})
                else:
                    manager = Person.objects.get(priority='1')
                    manager.delete()
                    Person.objects.create(username=user_name, name=name, email=email, phone=phone, date=date,
                                          priority='1', message=json.dumps([]), finished=json.dumps([]))
                    return JsonResponse({'message': 'first'})
            else:
                request.session['user'] = user_name
                return JsonResponse({'message': 'ok'})


class Information(View):
    def get(self, request):
        user_name = request.session['user']
        content = get_context_person(user_name)
        return render_to_response('information.html', content)

    def post(self, request):
        user_name = request.session['user']
        user = Person.objects.get(username=user_name)
        user.name = request.POST.get('name')
        user.gender = request.POST.get('gender')
        user.studentId = request.POST.get('id')
        user.identity = request.POST.get('identity')
        user.phone = request.POST.get('phone')
        user.major = request.POST.get('major')
        user.size = request.POST.get('size')
        user.date = request.POST.get('date')
        user.email = request.POST.get('email')
        user.where = request.POST.get('where')
        user.studentClass = request.POST.get('class')
        user.save()
        content = get_context_person(user_name)
        return render_to_response('information.html', content)


def search(request):
    if request.method == 'GET':
        result = []
        key = request.GET.get('key')
        matches = Match.objects.all()
        for item in matches:
            if item.name.find(key) != -1:
                result.append(item)
        matches = Sharp9.objects.all()
        for item in matches:
            if item.name.find(key) != -1:
                result.append(item)
        user_name = request.session['user']
        content = get_context_person(user_name)
        search_result = [get_context_match(i, j, user_name) for i, j in enumerate(result)]
        content['matches'] = search_result
        return render_to_response('search.html', content)

    if request.method == 'POST':
        return IndexView().post(request=request)


class IndexView(View):
    model = Match
    default = '男篮'
    label = 'mb'
    html = 'mb.html'

    def get_data(self, request):
        user_name = request.session['user']
        content = get_context_person(user_name)
        belong = request.GET.get('belong')
        if belong is None:
            belong = self.default
        match_list = self.model.objects.filter(belong=belong)
        matches = [get_context_match(i, match, user_name) for i, match in enumerate(match_list)]
        images = [{'name': image.name, 'title': image.title,
                   'description': image.description, 'which': image.which}
                  for image in Image.objects.filter(address=self.label, belong=belong).order_by('which')]
        url = [{'title': i.title, 'url': i.url, 'which': i.which, 'no': j} for j, i in
               enumerate(News.objects.filter(belong=belong))]
        content['matches'] = matches
        content['belong'] = belong
        content['images'] = images
        content['url'] = url
        content['label'] = [item.label for item in Label.objects.filter(belong=self.label)]
        return content

    def get(self, request):
        if request.GET.get('type') == 'file':
            match = self.model.objects.get(name=request.GET.get('name'))
            filename = (match.name + '.xls').encode('utf-8').decode('ISO-8859-1')
            data = json.loads(request.GET.get('data'))
            if match.team == '个人':
                people = json.loads(match.checked)
                students = [get_context_person(i) for i in people]
                Excel(students, data)
            else:
                students = []
                teams = json.loads(match.groups)
                for item in teams:
                    for member in item['member']:
                        context = get_context_person(Person.objects.get(name=member).username)
                        context['team'] = item['name']
                        students.append(context)
                Excel(students, data, True)
            with open('list.xls', 'rb') as f:
                c = f.read()
                response = HttpResponse(c, content_type='application/octet-stream')
                response['Content-Disposition'] = 'attachment; filename="%s"' % filename
                return response
        elif request.GET.get('type') == 'member':
            match = self.model.objects.get(name=request.GET.get('which'))
            waiting = json.loads(match.waiting)
            checked = json.loads(match.checked)
            if request.session['user'] in waiting:
                return JsonResponse({'message': 'waiting'})
            if request.session['user'] in checked:
                return JsonResponse({'message': 'checked'})
            return JsonResponse({'message': Person.objects.get(username=request.session['user']).name})
        elif request.GET.get('type') == 'find':
            name = request.GET.get('name')
            try:
                person = Person.objects.get(Q(name=name) | Q(username=name))
            except ObjectDoesNotExist:
                person = None
            if person is None:
                return JsonResponse({'message': 'no'})
            else:
                match = self.model.objects.get(name=request.GET.get('which'))
                waiting = json.loads(match.waiting)
                checked = json.loads(match.checked)
                if person.username in waiting or person.username in checked:
                    return JsonResponse({'message': 'checked'})
                else:
                    return JsonResponse({'message': person.name})
        elif request.GET.get('type') == 'label-add':
            value = request.GET.get('value')
            if len(Label.objects.filter(label=value)) != 0:
                return JsonResponse({'message': 'exist'})
            else:
                Label.objects.create(label=value, belong=self.label)
                return JsonResponse({'message': 'ok'})
        elif request.GET.get('type') == 'label-delete':
            value = request.GET.get('value')
            print(value)
            if len(Label.objects.filter(label=value)) == 0:
                return JsonResponse({'message': 'exist'})
            else:
                target = Label.objects.get(label=value, belong=self.label)
                target.delete()
                return JsonResponse({'message': 'ok'})
        else:
            content = self.get_data(request)
            return render(request, self.html, context=content)

    def post(self, request):
        if request.POST.get('type') == 'submit':
            which = request.POST.get('which')
            match = self.model.objects.get(name=which)
            waiting = json.loads(match.waiting)
            checked = json.loads(match.checked)
            if match.team == '个人':
                if request.session['user'] in waiting:
                    return JsonResponse({'message': 'waiting'})
                if request.session['user'] in checked:
                    return JsonResponse({'message': 'checked'})
                waiting.append(request.session['user'])
                match.waiting = json.dumps(waiting)
                match.save()
                return JsonResponse({'message': 'ok'})
            else:
                group = json.loads(match.group)
                groups_ = json.loads(match.groups)
                added = json.loads(request.POST.get('data'))
                for team in group:
                    if team['name'] == added['name']:
                        return JsonResponse({'message': 'name'})
                for team in groups_:
                    if team['name'] == added['name']:
                        return JsonResponse({'message': 'name'})
                for i in added['member']:
                    waiting.append(Person.objects.get(name=i).username)
                waiting.append(Person.objects.get(name=added['leader']).username)
                group.append(added)
                match.group = json.dumps(group)
                match.waiting = json.dumps(waiting)
                match.save()
                return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'add':
            name = request.POST.get('name')
            if len(self.model.objects.filter(name=name)) != 0:
                return JsonResponse({'message': 'used'})
            date = request.POST.get('date')
            deadline = request.POST.get('deadline')
            limit = request.POST.get('limit')
            description = request.POST.get('description')
            belong = request.POST.get('which')
            address = request.POST.get('address')
            team = request.POST.get('team')
            size = 1 if team == '个人' else request.POST.get('size')
            groups_ = group = waiting = checked = json.dumps([])
            self.model.objects.create(name=name, date=date, deadline=deadline, description=description, team=team,
                                      size=size, number=limit, belong=belong, waiting=waiting, checked=checked,
                                      address=address, group=group, groups=groups_)
            return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'delete':
            name = request.POST.get('which')
            match = self.model.objects.get(name=name)
            match.delete()
            return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'check':
            name = request.POST.get('which')
            match = self.model.objects.get(name=name)
            waiting = json.loads(match.waiting)
            checked = json.loads(match.checked)
            change = json.loads(request.POST.get('list'))
            if match.team == '个人':
                for item in change:
                    person = Person.objects.get(name=item['name'], studentClass=item['class_'])
                    message = json.loads(person.message)
                    username = person.username
                    if item['type'] == 'check':
                        finished = json.loads(person.finished)
                        finished.append(
                            {'name': name, 'time': match.date, 'address': match.address, 'grades': '', 'no': ''})
                        person.finished = json.dumps(finished)
                        message.append({'name': name, 'type': 'add'})
                        person.message = json.dumps(message)
                        person.save()
                        waiting.remove(username)
                        checked.append(username)
                    else:
                        waiting.remove(username)
                        message.append({'name': name, 'type': 'refuse'})
                        person.message = json.dumps(message)
                        person.save()
            else:
                group = json.loads(match.group)
                groups_ = json.loads(match.groups)
                for item in change:
                    for team in group:
                        if team['name'] == item['name']:
                            group.remove(team)
                            if item['type'] == 'check':
                                groups_.append(team)
                                team['member'].append(team['leader'])
                                for person in team['member']:
                                    who = Person.objects.get(name=person)
                                    waiting.remove(who.username)
                                    checked.append(who.username)
                                    finished = json.loads(who.finished)
                                    finished.append(
                                        {'name': name, 'time': match.date, 'address': match.address, 'grades': '',
                                         'no': ''})
                                    who.finished = json.dumps(finished)
                                    message = json.loads(who.message)
                                    message.append({'name': name, 'type': 'add'})
                                    who.message = json.dumps(message)
                                    who.save()
                            else:
                                team['member'].append(team['leader'])
                                for person in team['member']:
                                    who = Person.objects.get(name=person)
                                    waiting.remove(who.username)
                                    message = json.loads(who.message)
                                    message.append({'name': name, 'type': 'refuse'})
                                    who.message = json.dumps(message)
                                    who.save()
                match.group = json.dumps(group)
                match.groups = json.dumps(groups_)
            match.waiting = json.dumps(waiting)
            match.checked = json.dumps(checked)
            match.save()
            return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'grades':
            name = request.POST.get('which')
            match = self.model.objects.get(name=name)
            change = json.loads(request.POST.get('list'))
            if match.team == '个人':
                for item in change:
                    person = Person.objects.get(name=item['name'], studentClass=item['class_'])
                    finished = json.loads(person.finished)
                    message = json.loads(person.message)
                    message.append({'name': name, 'type': 'grades'})
                    person.message = json.dumps(message)
                    for j in range(len(finished)):
                        if finished[j]['name'] == name:
                            temporary = finished[j]
                            temporary['grades'] = item['grades']
                            temporary['no'] = item['No']
                            finished[j] = temporary
                            person.finished = json.dumps(finished)
                            person.save()
                            break
                return JsonResponse({'message': 'ok'})
            else:
                groups_ = json.loads(match.groups)
                for item in change:
                    for teams in groups_:
                        if teams['name'] == item['name']:
                            for person in teams['member']:
                                who = Person.objects.get(name=person)
                                finished = json.loads(who.finished)
                                message = json.loads(who.message)
                                message.append({'name': name, 'type': 'grades'})
                                who.message = json.dumps(message)
                                for j in range(len(finished)):
                                    if finished[j]['name'] == name:
                                        temporary = finished[j]
                                        temporary['grades'] = item['grades']
                                        temporary['no'] = item['No']
                                        print(temporary)
                                        finished[j] = temporary
                                        who.finished = json.dumps(finished)
                                        who.save()
                                        break
                return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'wait':
            name = request.POST.get('which')
            match = self.model.objects.get(name=name)
            if match.team == '个人':
                if request.POST.get('todo') == 'true':
                    waiting = [Person.objects.get(username=name) for name in json.loads(match.checked)]
                else:
                    waiting = [Person.objects.get(username=name) for name in json.loads(match.waiting)]
                message = [{'name': person.name, 'class_': person.studentClass} for person in waiting]
                return JsonResponse({'waiting': message, 'type': 'personal'})
            else:
                if request.POST.get('todo') == 'true':
                    groups_ = json.loads(match.groups)
                    message = [{'name': team['name'], 'class_': team['leader']} for team in groups_]
                else:
                    group = json.loads(match.group)
                    message = [{'name': team['name'], 'class_': team['leader']} for team in group]
                return JsonResponse({'waiting': message, 'type': 'group'})

        if request.POST.get('type') == 'mail':
            name = request.POST.get('which')
            match = self.model.objects.get(name=name)
            receiver = [Person.objects.get(username=username).email for username in json.loads(match.checked)]
            return JsonResponse({'receivers': receiver})

        if request.POST.get('type') == 'send':
            receivers = request.POST.get('receivers').split(';')
            receivers.remove('')
            Mail().send(request.POST.get('title'), receivers,
                        request.POST.get('text'))
            content = self.get_data(request)
            return render(request, 'mb.html', context=content)

        if request.POST.get('type') == 'file':
            image = request.FILES.get('image')
            filename = request.POST.get('which') + request.POST.get('belong') + image.name
            try:
                picture = Image.objects.get(address=self.label, which=int(request.POST.get('which')),
                                            belong=request.POST.get('belong'))
                os.remove(settings.BASE_DIR + '/sports/static/images/' + picture.name)
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))
                picture.name = filename
                picture.description = request.POST.get('description')
                picture.title = request.POST.get('title')
                picture.save()
            except ObjectDoesNotExist:
                Image.objects.create(address=self.label, which=int(request.POST.get('which')),
                                     title=request.POST.get('title'), name=filename,
                                     description=request.POST.get('description'), belong=request.POST.get('belong'))
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))
            content = self.get_data(request)
            return render(request, self.html, context=content)

        if request.POST.get('type') == 'url-add':
            title = request.POST.get('title')
            which = request.POST.get('which')
            url = request.POST.get('url')
            belong = request.POST.get('belong')
            News.objects.create(title=title, which=which, url=url, where='mb', belong=belong)
            content = self.get_data(request)
            return render(request, self.html, context=content)

        if request.POST.get('type') == 'delete-news':
            news = News.objects.get(url=request.POST.get('url'), belong=request.POST.get('belong'))
            news.delete()
            return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'cancel':
            which = request.POST.get('which')
            match = self.model.objects.get(name=which)
            waiting = json.loads(match.waiting)
            if match.team == '个人':
                waiting.remove(request.session['user'])
                match.waiting = json.dumps(waiting)
                match.save()
                return JsonResponse({'message': 'ok'})
            else:
                name = Person.objects.get(username=request.session['user']).name
                group = json.loads(match.group)
                for i in group:
                    if i['leader'] == name:
                        for j in i['member']:
                            person = Person.objects.get(name=j)
                            waiting.remove(person.username)
                            message = json.loads(person.message)
                            message.append({'name': which, 'type': 'drop'})
                            person.message = json.dumps(message)
                            person.save()
                        waiting.remove(Person.objects.get(name=i['leader']).username)
                        group.remove(i)
                        match.group = json.dumps(group)
                        match.waiting = json.dumps(waiting)
                        match.save()
                        break
                return JsonResponse({'message': 'ok'})


def first(request):
    if request.method == 'GET':
        user_name = request.session['user']
        content = get_context_person(user_name)
        return render_to_response('information_.html', content)


def get_context_person(user_name):
    user = Person.objects.get(username=user_name)
    content = {'name': user.name, 'studentId': user.studentId, 'identity': user.identity,
               'gender': user.gender, 'phone': user.phone, 'size': user.size, 'degree': user.degree,
               'email': user.email, 'date': user.date, 'studentClass': user.studentClass,
               'where': user.where, 'username': user.username, 'major': user.major, 'priority': user.priority}
    if len(json.loads(user.message)) == 0:
        content['new'] = 0
    else:
        content['new'] = 1
        content['msg'] = json.loads(user.message)
    return content


def get_context_match(i, match, user_name):
    context = {
        'name': match.name, 'date': match.date, 'deadline': match.deadline,
        'limit': match.number, 'description': match.description, 'No': i,
        'address': match.address, 'team': match.team, 'size': match.size,
    }
    checked = list(json.loads(match.checked))
    waiting = list(json.loads(match.waiting))
    if user_name in waiting:
        context['cancel'] = '1'
    checked.extend(waiting)
    people = [Person.objects.get(username=name) for name in checked]
    people = [{'no': j + 1, 'name': person.name, 'class': person.studentClass} for j, person in enumerate(people)]
    context['people'] = people
    context['number'] = len(people)
    group = json.loads(match.group)
    groups_ = json.loads(match.groups)
    group.extend(groups_)
    if match.team != '个人':
        context['number'] = len(group)
    for k in range(len(group)):
        group[k]['no'] = k + 1
        group[k]['member'] = [{'no': h + 1, 'name': name, 'class': Person.objects.get(name=name).studentClass} for
                              h, name in enumerate(group[k]['member'])]
        if group[k]['leader'] == Person.objects.get(username=user_name).name and group[k] not in groups_:
            context['cancel'] = '2'
    context['group'] = group
    return context


class NineView(IndexView):
    model = Sharp9
    default = '酒井杯篮球赛'
    label = '9#'
    html = '9#.html'


class priority(View):
    def get(self, request):
        user_name = request.session['user']
        content = get_context_person(user_name)
        managers = Person.objects.filter(priority='2')
        content['managers'] = [{'No': i + 1, 'name': person.name, 'class': person.studentClass}
                               for i, person in enumerate(managers)]
        return render_to_response('priority.html', content)

    def post(self, request):
        if request.POST.get('type') == 'add':
            name = request.POST.get('name')
            try:
                person = Person.objects.get(Q(name=name) | Q(username=name))
            except ObjectDoesNotExist:
                person = None
            if person is None:
                return JsonResponse({'message': 'no'})
            if person.priority == '2':
                return JsonResponse({'message': 'done'})
            else:
                person.priority = '2'
                person.save()
                return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'delete':
            name = request.POST.get('which')
            print(name)
            person = Person.objects.get(name=name)
            person.priority = '3'
            person.save()
            return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'give':
            name = request.POST.get('name')
            try:
                person = Person.objects.get(Q(name=name) | Q(username=name))
            except ObjectDoesNotExist:
                person = None
            if person is None:
                return JsonResponse({'message': 'no'})
            else:
                person.priority = '1'
                person.save()
                old = Person.objects.get(username=request.session['user'])
                old.priority = '2'
                old.save()
                return JsonResponse({'message': 'ok'})


class setting(View):
    def get_data(self, request):
        user_name = request.session['user']
        content = get_context_person(user_name)
        images = [{'name': image.name, 'title': image.title,
                   'description': image.description, 'which': image.which}
                  for image in Image.objects.filter(address='home').order_by('which')]
        content['images'] = images
        for i in range(1, 4):
            image = Image.objects.get(address='home-bottom', which=str(i))
            content['image' + str(i)] = {'name': image.name, 'description': image.description, 'title': image.title}
        return content

    def get(self, request):
        content = self.get_data(request)
        return render_to_response('setting.html', context=content)

    def post(self, request):
        if request.POST.get('type') is not None:
            address = 'home'
        else:
            address = 'home-bottom'
        image = request.FILES.get('image')
        filename = request.POST.get('which') + address + image.name
        picture = Image.objects.get(address=address, which=int(request.POST.get('which')))
        if picture.name != 'default.jpeg':
            os.remove(settings.BASE_DIR + '/sports/static/images/' + picture.name)
        default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))
        picture.name = filename
        picture.description = request.POST.get('description')
        picture.title = request.POST.get('title')
        picture.save()
        content = self.get_data(request)
        return render_to_response('setting.html', context=content)


def personal(request):
    username = request.session['user']
    person = Person.objects.get(username=username)
    content = get_context_person(username)
    finished = json.loads(person.finished)
    finished = list(reversed(finished))
    for i in range(len(finished)):
        finished[i]['No'] = i + 1
    content['finish'] = finished
    response = render_to_response('person.html', context=content)
    person.message = json.dumps([])
    person.save()
    return response


def team(request):
    if request.method == 'GET':
        if 'searchname' in request.GET:
            username = request.session['user']
            content = {'username': username, 'priority': Person.objects.get(username=username).priority}
            name = request.GET['searchname']
            team_list = Team.objects.filter(name__contains=name)
            teams = [get_context_teams(i, team) for i, team in enumerate(team_list)]
            content['teams'] = teams
            return render(request, 'team.html', context=content)
        else:
            name = request.session['user']
            content = {'username': name, 'priority': Person.objects.get(username=name).priority}
            team_list = Team.objects.filter()
            teams = [get_context_teams(i, team) for i, team in enumerate(team_list)]
            content['teams'] = teams
            return render(request, 'team.html', context=content)

    if request.method == 'POST':
        if request.POST.get('type') == 'submit':
            name = request.POST.get('name')
            if len(Hall.objects.filter(name=name)):
                return JsonResponse({'message': 'used'})

            image = request.FILES.get('image')
            filename = name + image.name
            try:
                team = Team.objects.get(name=name)
                os.remove(settings.BASE_DIR + '/sports/static/images/' + team.image)
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))
                picture.save()
            except ObjectDoesNotExist:
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))

            phone = request.POST.get('phone')
            introduction = request.POST.get('introduction')
            captain = request.POST.get('captain')
            Team.objects.create(name=name, captain=captain, introduction=introduction, phone=phone, image=filename,
                                introduction_self='', honor='', coach='', member='')
            return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'delete':
            name = request.POST.get('name')
            team = Team.objects.get(name=name)
            os.remove(settings.BASE_DIR + '/sports/static/images/' + team.image)
            team.delete()
            return JsonResponse({'message': 'ok'})


def get_context_teams(i, team):
    context = {
        'name': team.name, 'captain': team.captain, 'introduction': team.introduction,
        'phone': team.phone, 'image': team.image,
    }
    return context


def team_info(request):
    if request.method == 'GET':
        if 'showname' in request.GET:
            username = request.session['user']
            name = request.GET['showname']
            team = Team.objects.get(name=name)
            content = {'username': username, 'priority': Person.objects.get(username=username).priority, 'name': name,
                       'captain': team.captain, 'introduction_self': team.introduction_self,
                       'member': team.member, 'honor': team.honor.replace('\n', '<br/>'), 'honor_show': team.honor,
                       'coach': team.coach, 'phone': team.phone,
                       'image': team.image}
        return render(request, 'team_info.html', context=content)
    if request.method == 'POST':
        if request.POST.get('type') == 'edit':
            name = request.POST.get('name')
            team = Team.objects.get(name=name)
            team.coach = request.POST.get('coach')
            team.introduction_self = request.POST.get('introduction_self')
            team.member = request.POST.get('member')
            team.honor = request.POST.get('honor')
            team.save()
            return JsonResponse({'message': 'ok'})


def team_competition(request):
    if request.method == 'GET':
        if 'showname' in request.GET:
            username = request.session['user']
            team_name = request.GET['showname']
            content = {'username': username, 'priority': Person.objects.get(username=username).priority,
                       'name': team_name}
            ImageList = TeamCompetitionImage.objects.filter(team_name=team_name)
            images = [get_context_team_competition_image(i, image) for i, image in enumerate(ImageList)]
            content['images'] = images
            return render(request, 'team_competition.html', context=content)
    if request.method == 'POST':
        if request.POST.get('type') == 'submit':
            team_name = request.POST.get('name')
            image = request.FILES.get('image')
            address = 'team_competition' + team_name + image.name
            try:
                picture = TeamCompetitionImage.objects.get(address=address)
                return JsonResponse({'message': 'used'})
            except ObjectDoesNotExist:
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + address, ContentFile(image.read()))
            date = request.POST.get('date')
            competition_name = request.POST.get('competition_name')
            description = request.POST.get('description')
            TeamCompetitionImage.objects.create(team_name=team_name, date=date, description=description,
                                                competition_name=competition_name, address=address)
            return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'delete':
            address = request.POST.get('address')
            image = TeamCompetitionImage.objects.get(address=address)
            os.remove(settings.BASE_DIR + '/sports/static/images/' + image.address)
            image.delete()
            return JsonResponse({'message': 'ok'})


def get_context_team_competition_image(i, image):
    context = {
        'person_name': image.team_name, 'date': image.date, 'description': image.description,
        'competition_name': image.competition_name, 'address': image.address, 'order': i,
    }
    return context


def hall_of_fame(request):
    if request.method == 'GET':
        if 'searchname' in request.GET:
            username = request.session['user']
            content = {'username': username, 'priority': Person.objects.get(username=username).priority}
            name = request.GET['searchname']
            years_object = HallOfFameYear.objects.filter()
            content['info'] = []
            year_list = []
            for year_object in years_object:
                year_list.append(year_object.year)
            year_list.sort(reverse=True)
            for year in year_list:
                hall_person_list = Hall.objects.filter(year=year, name__contains=name)
                hall_persons = [get_context_hall_person(i, hall_person) for i, hall_person in
                                enumerate(hall_person_list)]
                dic = {'year': year, 'persons': hall_persons}
                content['info'].append(dic)
            return render(request, 'hall_of_fame.html', context=content)
        else:
            name = request.session['user']
            content = {'username': name, 'priority': Person.objects.get(username=name).priority}
            content['info'] = []
            years_object = HallOfFameYear.objects.filter()
            year_list = []
            for year_object in years_object:
                year_list.append(year_object.year)
            year_list.sort(reverse=True)
            for year in year_list:
                hall_person_list = Hall.objects.filter(year=year)
                hall_persons = [get_context_hall_person(i, hall_person) for i, hall_person in
                                enumerate(hall_person_list)]
                dic = {'year': year, 'persons': hall_persons}
                content['info'].append(dic)
            return render(request, 'hall_of_fame.html', context=content)

    if request.method == 'POST':
        if request.POST.get('type') == 'submit':
            name = request.POST.get('name')
            year = request.POST.get('year')
            if len(Hall.objects.filter(name=name)) != 0 and len(Hall.objects.filter(year=year)) != 0:
                return JsonResponse({'message': 'used'})

            image = request.FILES.get('image')
            filename = name + image.name
            try:
                picture = Hall.objects.get(name=name)
                os.remove(settings.BASE_DIR + '/sports/static/images/' + picture.image)
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))
                picture.save()
            except ObjectDoesNotExist:
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + filename, ContentFile(image.read()))

            introduction = request.POST.get('introduction')
            strength = request.POST.get('strength')
            Hall.objects.create(name=name, year=year, introduction=introduction, strength=strength, image=filename,
                                grade='', personclass='', introduction_self='', honor='', sex='')
            return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'delete':
            name = request.POST.get('name')
            person = Hall.objects.get(name=name)
            os.remove(settings.BASE_DIR + '/sports/static/images/' + person.image)
            person.delete()
            return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'add_year':
            year = request.POST.get('year')
            try:
                person = HallOfFameYear.objects.get(year=year)
                return JsonResponse({'message': 'used'})
            except ObjectDoesNotExist:
                HallOfFameYear.objects.create(year=year, )
                return JsonResponse({'message': 'ok'})

        if request.POST.get('type') == 'delete_year':
            year = request.POST.get('year')
            years = HallOfFameYear.objects.get(year=year)
            years.delete()
            return JsonResponse({'message': 'ok'})


def get_context_hall_person(i, hall_person):
    context = {
        'name': hall_person.name, 'year': hall_person.year, 'introduction': hall_person.introduction,
        'strength': hall_person.strength, 'image': hall_person.image,
    }
    return context


def hall_of_fame_personinfo(request):
    if request.method == 'GET':
        if 'showname' in request.GET:
            username = request.session['user']
            name = request.GET['showname']
            hall_person = Hall.objects.get(name=name)
            content = {'username': username, 'priority': Person.objects.get(username=username).priority, 'name': name,
                       'sex': hall_person.sex, 'introduction_self': hall_person.introduction_self,
                       'personclass': hall_person.personclass, 'honor': hall_person.honor.replace('\n', '<br/>'),
                       'honor_show': hall_person.honor, 'strength': hall_person.strength, 'grade': hall_person.grade,
                       'image': hall_person.image}
        return render(request, 'hall_of_fame_personinfo.html', context=content)
    if request.method == 'POST':
        if request.POST.get('type') == 'edit':
            name = request.POST.get('name')
            hall = Hall.objects.get(name=name)
            hall.sex = request.POST.get('sex')
            hall.personclass = request.POST.get('personclass')
            hall.introduction_self = request.POST.get('introduction_self')
            hall.grade = request.POST.get('grade')
            hall.honor = request.POST.get('honor')
            hall.save()
            return JsonResponse({'message': 'ok'})


def hall_of_fame_competition(request):
    if request.method == 'GET':
        if 'showname' in request.GET:
            username = request.session['user']
            person_name = request.GET['showname']
            content = {'username': username, 'priority': Person.objects.get(username=username).priority,
                       'name': person_name}
            ImageList = CompetitionImage.objects.filter(person_name=person_name)
            images = [get_context_competition_image(i, image) for i, image in enumerate(ImageList)]
            content['images'] = images
            return render(request, 'hall_of_fame_competition.html', context=content)
    if request.method == 'POST':
        if request.POST.get('type') == 'submit':
            person_name = request.POST.get('name')
            image = request.FILES.get('image')
            address = 'competition' + person_name + image.name
            try:
                picture = CompetitionImage.objects.get(address=address)
                return JsonResponse({'message': 'used'})
            except ObjectDoesNotExist:
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + address, ContentFile(image.read()))
            date = request.POST.get('date')
            competition_name = request.POST.get('competition_name')
            description = request.POST.get('description')
            CompetitionImage.objects.create(person_name=person_name, date=date, description=description,
                                            competition_name=competition_name, address=address)
            return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'delete':
            address = request.POST.get('address')
            image = CompetitionImage.objects.get(address=address)
            os.remove(settings.BASE_DIR + '/sports/static/images/' + image.address)
            image.delete()
            return JsonResponse({'message': 'ok'})


def get_context_competition_image(i, image):
    context = {
        'person_name': image.person_name, 'date': image.date, 'description': image.description,
        'competition_name': image.competition_name, 'address': image.address, 'order': i,
    }
    return context


def hall_of_fame_interview(request):
    if request.method == 'GET':
        if 'showname' in request.GET:
            username = request.session['user']
            person_name = request.GET['showname']
            content = {'username': username, 'priority': Person.objects.get(username=username).priority,
                       'name': person_name}
            InterviewList = Interview.objects.filter(person_name=person_name)
            interviews = [get_context_interview(i, interview) for i, interview in enumerate(InterviewList)]
            content['interviews'] = interviews
        return render(request, 'hall_of_fame_interview.html', context=content)

    if request.method == 'POST':
        if request.POST.get('type') == 'submit':
            person_name = request.POST.get('name')
            image = request.FILES.get('image')
            address = 'interview' + person_name + image.name
            try:
                picture = Interview.objects.get(address=address)
                return JsonResponse({'message': 'used'})
            except ObjectDoesNotExist:
                default_storage.save(settings.BASE_DIR + '/sports/static/images/' + address, ContentFile(image.read()))
            date = request.POST.get('date')
            title = request.POST.get('title')
            url = request.POST.get('url')
            description = request.POST.get('description')
            Interview.objects.create(person_name=person_name, date=date, description=description, title=title,
                                     address=address, url=url)
            return JsonResponse({'message': 'ok'})
        if request.POST.get('type') == 'delete':
            address = request.POST.get('address')
            image = Interview.objects.get(address=address)
            os.remove(settings.BASE_DIR + '/sports/static/images/' + image.address)
            image.delete()
            return JsonResponse({'message': 'ok'})


def get_context_interview(i, interview):
    context = {
        'person_name': interview.person_name, 'date': interview.date, 'description': interview.description,
        'title': interview.title, 'address': interview.address, 'url': interview.url, 'order': i,
    }
    return context

@csrf_exempt 
def page_not_found(request):
	return render_to_response('404.html')
