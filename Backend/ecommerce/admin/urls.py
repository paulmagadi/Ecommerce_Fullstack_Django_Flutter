from django.urls import path
from . import views

urlpatterns = [
    path('admin_portal', views.admin_portal, name='admin_portal'),
    path('add_product', views.add_product, name='add_product'),
    path('inventory', views.inventory, name='inventory'),
    path('product_inventory/<int:pk>', views.product_inventory, name='product_inventory'),
]