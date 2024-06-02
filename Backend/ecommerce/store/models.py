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
    color = models.CharField(max_length=100, unique=True)
    
    def __str__(self):
        return self.color
    

class Size(models.Model):
    size = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.color
    
class Images(models.Model):
    image = models.ImageField(upload_to='media/uploads/products/')
    
    
class Product(models.Model):
    name = models.CharField(max_length=255, verbose_name='product_name')
    price = models.DecimalField(max_digits=12, decimal_places=2)
    profile_image = models.ImageField(upload_to='media/uploads/products')
    category = TreeForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    color = models.ManyToManyField(Color, on_delete=models.CASCADE, related_name='products')
    size = models.ManyToManyField(Size, on_delete=models.CASCADE, related_name='products')

    def __str__(self):
        return self.name
    
