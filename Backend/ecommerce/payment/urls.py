from django.urls import path
from . import views

urlpatterns = [
    path('checkout/', views.checkout, name='checkout'),
    path('', views.payment, name='payment'),
    path('execute/', views.payment_execute, name='payment_execute'),
    path('cancel/', views.payment_cancel, name='payment_cancel'),
]