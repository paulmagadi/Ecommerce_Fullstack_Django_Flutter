from django.urls import path
from . import views


urlpatterns = [
    path('register/', views.register_user, name='register'),
    path('login/', views.login_user, name='signin'),
    path('logout/', views.logout_user, name='signout'),
    path('user_profile', views.user_profile, name='user_profile'),
    path('update_user/', views.update_user, name='update_user'),
    path('update_password/', views.update_password, name='update_password'),
    path('update_info/', views.update_info, name='update_info'),
    path('shipping_info/', views.shipping_info, name='shipping_info'),
]

