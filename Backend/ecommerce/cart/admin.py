from django.contrib import admin
from .models import Order, OrderItem
# Register your models here.

# class OrderAdmin(admin.ModelAdmin):
#     list_display = ('id',)

admin.site.register(OrderItem)
admin.site.register(Order)