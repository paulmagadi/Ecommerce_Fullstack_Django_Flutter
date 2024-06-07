from django.urls import path
from . import views

urlpatterns = [
    path('product/<str:slug>', views.product, name='product'),
    path('category/<str:slug>/', views.category, name='category'),
    path('categories/', views.categories, name='categories'),
    path('sale/', views.sale, name='sale'),
    path('new/', views.new, name='new'),
    path('featured/', views.featured, name='featured'),
    path('products/', views.products, name='products'),
    path('search/', views.search, name='search'),
]