from django.urls import path
from . import views

urlpatterns = [
    path('', views.payment, name='payment'),
    path('process/', views.process_payment, name='process_payment'),
    path('execute/', views.payment_execute, name='payment_execute'),
    path('cancel/', views.payment_cancel, name='payment_cancel'),
    path('success/', views.order_success, name='order_success'),
]