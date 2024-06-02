from django.db import models
from django.utils.text import slugify
from mptt.models import MPTTModel, TreeForeignKey

class Category(MPTTModel):
    parent = TreeForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
    name = models.CharField(max_length=50, unique=True)
    key_words = models.CharField(max_length=255)
    descriptions = models.CharField(max_length=255)
    image = models.ImageField(upload_to='media/uploads/categories/')
    slug = models.SlugField(unique=True, blank=True)

    class MPTTMeta:
        order_insertion_by = ['name']

    class Meta:
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)
        
class Color(models.Model):
    name = models.CharField(max_length=100, unique=True)
    
    def __str__(self):
        return self.name
    

class Size(models.Model):
    value = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return f'{self.name.name} : {self.value}'