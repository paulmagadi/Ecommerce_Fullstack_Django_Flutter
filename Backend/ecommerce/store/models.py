from django.db import models
from django.forms import ValidationError
from django.utils.text import slugify
from mptt.models import MPTTModel, TreeForeignKey

class Category(MPTTModel):
    parent = TreeForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
    name = models.CharField(max_length=50, unique=True)
    key_words = models.CharField(max_length=255)
    descriptions = models.CharField(max_length=255)
    image = models.ImageField(upload_to='uploads/categories/')
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
        return self.size

      
class Product(models.Model):
    profile_image = models.ImageField(upload_to='uploads/products', null=True, blank=True, default='media/default/product.png')
    name = models.CharField(max_length=255, verbose_name='product_name')
    price = models.DecimalField(max_digits=12, decimal_places=2)
    is_sale = models.BooleanField(default=False)
    sale_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    discount = models.DecimalField(default=0, max_digits=9, decimal_places=2, null=True, blank=True)
    percentage_discount = models.DecimalField(default=0, max_digits=5, decimal_places=0, null=True, blank=True)
    created_at = models.DateTimeField(auto_now=True)
    is_listed = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=True)
    slug = models.SlugField(unique=True, blank=True)
    key_words = models.CharField(max_length=255)
    stock_quantity = models.IntegerField(default=1)
    brand = models.CharField(max_length=255, blank=True, null=True)
    material = models.CharField(max_length=255, blank=True, null=True)
    category = TreeForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    color = models.ManyToManyField(Color, related_name='products')
    size = models.ManyToManyField(Size, related_name='products')

    def __str__(self):
        return self.name

    def clean(self):
        super().clean()
        if self.stock_quantity < 0:
            raise ValidationError({'stock_quantity': 'Stock quantity cannot be less than 0'})

    def save(self, *args, **kwargs):
        self.full_clean()  
        
        if self.stock_quantity == 0:
            self.is_listed = False
        else:
            self.is_listed = True

        if self.is_sale and self.sale_price and self.sale_price < self.price:
            self.discount = round(self.price - self.sale_price, 2)
            self.percentage_discount = round((self.discount / self.price) * 100)
        else:
            self.discount = 0
            self.percentage_discount = 0

        if not self.slug:
            self.slug = slugify(self.name)

        super().save(*args, **kwargs)

    @property
    def imageURL(self):
        try:
            url = self.profile_image.url
        except:
            url = ''
        return url

    
class ProductImage(models.Model):
    product = models.ForeignKey(Product, default=None, on_delete=models.CASCADE)
    product_images = models.ImageField(upload_to='uploads/products', null=True, blank=True)

    class Meta:
        verbose_name_plural = 'Product Images'

    def __str__(self):
        return self.product.name

    @property
    def imageURL(self):
        try:
            url = self.product_images.url
        except:
            url = ''
        return url

    
class WebBanner(models.Model):
    image = models.ImageField(upload_to='uploads/banners/', verbose_name="Image")
    caption = models.CharField(max_length=255, blank=True, null=True, verbose_name="Caption")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    in_use = models.BooleanField(default=False)

    def __str__(self):
        return self.caption  
    
    @property
    def imageURL(self):
        try:
            url = self.image.url
        except:
            url = ''
        return url
    
class MobileBanner(models.Model):
    image = models.ImageField(upload_to='uploads/banners/', verbose_name="Image")
    caption = models.CharField(max_length=255, blank=True, null=True, verbose_name="Caption")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    in_use = models.BooleanField(default=False)

    def __str__(self):
        return self.caption  
    
    @property
    def imageURL(self):
        try:
            url = self.image.url
        except:
            url = ''
        return url