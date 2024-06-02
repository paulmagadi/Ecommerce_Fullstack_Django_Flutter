from django.contrib import admin

from .models import Category, Specification, SpecificationValue
from mptt.admin import MPTTModelAdmin


class CategoryAdmin(MPTTModelAdmin):
    list_display = ('name', 'parent')
    search_fields = ('name',)

admin.site.register(Category, CategoryAdmin)
admin.site.register(SpecificationValue)
admin.site.register(Specification)