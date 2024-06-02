from django.shortcuts import render
from rest_framework import viewsets
from store.models import Category, Product, Color, Size, ProductImage, WebBanner, MobileBanner
from .serializers import CategorySerializer, ProductSerializer, ColorSerializer, SizeSerializer, ProductImageSerializer, WebBannerSerializer, MobileBannerSerializer

class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class ColorViewSet(viewsets.ModelViewSet):
    queryset = Color.objects.all()
    serializer_class = ColorSerializer

class SizeViewSet(viewsets.ModelViewSet):
    queryset = Size.objects.all()
    serializer_class = SizeSerializer

class ProductImageViewSet(viewsets.ModelViewSet):
    queryset = ProductImage.objects.all()
    serializer_class = ProductImageSerializer

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class WebBannerViewSet(viewsets.ModelViewSet):
    queryset = WebBanner.objects.all()
    serializer_class = WebBannerSerializer

class MobileBannerViewSet(viewsets.ModelViewSet):
    queryset = MobileBanner.objects.all()
    serializer_class = MobileBannerSerializer
