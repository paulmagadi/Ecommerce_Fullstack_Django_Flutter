from django.urls import path
from . import views

urlpatterns = [
    path('product/<int:pk>', views.product, name='product'),
    path('category/<int:pk>/', views.category, name='category'),
    path('categories/', views.categories, name='categories'),
    path('sale/', views.sale, name='sale'),
    path('new/', views.new, name='new'),
    path('featured/', views.featured, name='featured'),
    path('offers/', views.offers, name='offers'),
    path('search/', views.search, name='search'),
]