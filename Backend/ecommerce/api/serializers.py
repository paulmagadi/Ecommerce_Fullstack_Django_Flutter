from rest_framework import serializers
from store.models import Category, Product , ProductImage, WebBanner, MobileBanner

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        fields = '__all__'

class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer()
    product_images = ProductImageSerializer(many=True, read_only=True)

    class Meta:
        model = Product
        fields = '__all__'

class WebBannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = WebBanner
        fields = '__all__'

class MobileBannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = MobileBanner
        fields = '__all__'