from rest_framework import serializers
from store.models import Category, Product, Color, Size, ProductImage, WebBanner

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ColorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Color
        fields = '__all__'

class SizeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Size
        fields = '__all__'

class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        fields = '__all__'

class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer()
    color = ColorSerializer(many=True)
    size = SizeSerializer(many=True)
    product_images = ProductImageSerializer(many=True, read_only=True)

    class Meta:
        model = Product
        fields = '__all__'

class WebBannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = WebBanner
        fields = '__all__'
