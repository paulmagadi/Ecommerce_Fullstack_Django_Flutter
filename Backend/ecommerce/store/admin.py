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

# class ColorAdmin(admin.ModelAdmin):
#     list_display = ('color',)

# class SizeAdmin(admin.ModelAdmin):
#     list_display = ('size',)

# class WebBannerAdmin(admin.ModelAdmin):
#     list_display = ('caption', 'created_at', 'in_use')

# admin.site.register(Category, CategoryAdmin)
admin.site.register(Product, ProductAdmin)
# admin.site.register(Color, ColorAdmin)
# admin.site.register(Size, SizeAdmin)
# admin.site.register(ProductImage)
# admin.site.register(WebBanner, WebBannerAdmin)



# class CategoryAdmin(MPTTModelAdmin):
#     list_display = ('name', 'parent')
#     search_fields = ('name',)

admin.site.register(Category, CategoryAdmin)
# admin.site.register(Product)
admin.site.register(Color)
admin.site.register(Size)
admin.site.register(ProductImage)
admin.site.register(WebBanner)
admin.site.register(MobileBanner)