from django.contrib import admin

from .models import Category, Product, Color, Size, ProductImage, WebBanner, MobileBanner
from mptt.admin import MPTTModelAdmin

class ProductImageInline(admin.TabularInline):
    model = ProductImage
    extra = 1

class ProductAdmin(admin.ModelAdmin):
    inlines = [ProductImageInline]
    list_display = ('name', 'price', 'is_sale', 'stock_quantity', 'is_listed', 'created_at')
    prepopulated_fields = {'slug': ('name',)}

class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'slug', 'parent')
    search_fields = ('name',)
    prepopulated_fields = {'slug': ('name',)}
    




# class CategoryAdmin(MPTTModelAdmin):
#     list_display = ('name', 'parent')
#     search_fields = ('name',)

admin.site.register(Product, ProductAdmin)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Color)
admin.site.register(Size)
admin.site.register(ProductImage)
admin.site.register(WebBanner)
admin.site.register(MobileBanner)