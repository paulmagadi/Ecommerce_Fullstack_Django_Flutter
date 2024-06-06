from datetime import timezone
from django.db import models
from django.utils.text import slugify
from mptt.models import MPTTModel, TreeForeignKey
from django.core.exceptions import ValidationError
from PIL import Image


class Category(MPTTModel):
    parent = TreeForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
    name = models.CharField(max_length=50, unique=True, blank=True, null=True)
    key_words = models.CharField(max_length=255, blank=True, null=True)
    descriptions = models.CharField(max_length=255, blank=True, null=True)
    image = models.ImageField(upload_to='uploads/categories/', blank=True, null=True)
    slug = models.SlugField(unique=True, blank=True, null=True)

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
        self.resize_image()

    def resize_image(self):
        if self.image:
            img = Image.open(self.image.path)
            if img.height > 1125 or img.width > 1125:
                img.thumbnail((1125, 1125))
                img.save(self.image.path, quality=70, optimize=True)

class Color(models.Model):
    color = models.CharField(max_length=100, unique=True, blank=True, null=True)

    def __str__(self):
        return self.color

class Size(models.Model):
    size = models.CharField(max_length=255, unique=True, blank=True, null=True)

    def __str__(self):
        return self.size

class Product(models.Model):
    profile_image = models.ImageField(upload_to='uploads/products', null=True, blank=True, default='media/default/product.png')
    name = models.CharField(max_length=255, verbose_name='Product Name')
    price = models.DecimalField(max_digits=12, decimal_places=2)
    description = models.TextField(verbose_name='Product Description', blank=True, null=True)
    is_sale = models.BooleanField(default=False)
    sale_price = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    discount = models.DecimalField(default=0, max_digits=9, decimal_places=2, null=True, blank=True)
    percentage_discount = models.DecimalField(default=0, max_digits=5, decimal_places=0, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_listed = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=True)
    slug = models.SlugField(unique=True, blank=True, null=True)
    key_words = models.CharField(max_length=255, blank=True, null=True)
    stock_quantity = models.IntegerField(default=1)
    brand = models.CharField(max_length=255, blank=True, null=True)
    material = models.CharField(max_length=255, blank=True, null=True)
    category = TreeForeignKey(Category, on_delete=models.CASCADE, related_name='products', null=True, blank=True)
    color = models.ManyToManyField(Color, related_name='products', blank=True)
    size = models.ManyToManyField(Size, related_name='products', blank=True)

    def __str__(self):
        return self.name

    def clean(self):
        super().clean()
        if self.stock_quantity < 0:
            raise ValidationError({'stock_quantity': 'Stock quantity cannot be less than 0'})

    def save(self, *args, **kwargs):
        self.full_clean()
        
        if self.stock_quantity <= 0:
            self.is_listed = False
        # else:
        #     self.is_listed = True
        
        if self.sale_price:
            self.is_sale=True
        else:
            self.is_sale=False

        if self.is_sale and self.sale_price and self.sale_price < self.price:
            self.discount = round(self.price - self.sale_price, 2)
            self.percentage_discount = round((self.discount / self.price) * 100)
        else:
            self.discount = 0
            self.percentage_discount = 0

        if not self.slug:
            self.slug = slugify(self.name)

        super().save(*args, **kwargs)
        self.resize_image()

    def resize_image(self):
        if self.profile_image:
            img = Image.open(self.profile_image.path)
            if img.height > 1125 or img.width > 1125:
                img.thumbnail((1125, 1125))
                img.save(self.profile_image.path, quality=70, optimize=True)

    @property
    def imageURL(self):
        try:
            url = self.profile_image.url
        except:
            url = ''
        return url

    @property
    def is_new(self):
        now = timezone.now()
        return (now - self.created_at).days <= 30
    
    @property
    def in_stock(self):
        return self.stock_quantity > 0


class ProductImage(models.Model):
    product = models.ForeignKey(Product, default=None, on_delete=models.CASCADE, related_name='product_images')
    product_images = models.ImageField(upload_to='uploads/products', null=True, blank=True)

    class Meta:
        verbose_name_plural = 'Product Images'

    def __str__(self):
        return self.product.name

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        self.resize_image()

    def resize_image(self):
        if self.product_images:
            img = Image.open(self.product_images.path)
            if img.height > 600 or img.width > 400:
                img.thumbnail((600, 400))
                img.save(self.product_images.path, quality=70, optimize=True)

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

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        self.resize_image()

    def resize_image(self):
        if self.image:
            img = Image.open(self.image.path)
            if img.height > 1125 or img.width > 1125:
                img.thumbnail((1125, 1125))
                img.save(self.image.path, quality=70, optimize=True)

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

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        self.resize_image()

    def resize_image(self):
        if self.image:
            img = Image.open(self.image.path)
            if img.height > 1125 or img.width > 1125:
                img.thumbnail((1125, 1125))
                img.save(self.image.path, quality=70, optimize=True)

    @property
    def imageURL(self):
        try:
            url = self.image.url
        except:
            url = ''
        return url
