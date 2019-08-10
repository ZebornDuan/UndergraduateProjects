from django.conf.urls import url
from sports import views
urlpatterns = [
    url(r'^$', views.LoginView.as_view()),
    url(r'^success/$', views.Information.as_view()),
    url(r'^index/$', views.IndexView.as_view()),
    url(r'^first/', views.first),
    url(r'^nine/', views.NineView.as_view()),
    url(r'^priority/', views.priority.as_view()),
    url(r'^setting/', views.setting.as_view()),
    url(r'^person/', views.personal),
    url(r'^search', views.search),
    url(r'^index/hall_of_fame$', views.hall_of_fame),
    url(r'^index/hall_of_fame/personinfo$', views.hall_of_fame_personinfo),
    url(r'^index/hall_of_fame/competition$', views.hall_of_fame_competition),
    url(r'^index/hall_of_fame/interview$', views.hall_of_fame_interview),
    url(r'^team/$', views.team),
    url(r'^team/info$', views.team_info),
    url(r'^team/competition$', views.team_competition)
]
handler404 = views.page_not_found


