from django.contrib import admin

from .models import Category, Product, Color, Size, ProductImage, WebBanner, MobileBanner
from mptt.admin import MPTTModelAdmin


class CategoryAdmin(MPTTModelAdmin):
    list_display = ('name', 'parent')
    search_fields = ('name',)

admin.site.register(Category, CategoryAdmin)
admin.site.register(Product)
admin.site.register(Color)
admin.site.register(Size)
admin.site.register(ProductImage)
admin.site.register(WebBanner)
admin.site.register(MobileBanner)