from django.shortcuts import render
from rest_framework import viewsets
# from rest_framework.decorators import api_view

from store.models import Category, Product, ProductImage, WebBanner, MobileBanner
from .serializers import CategorySerializer, ProductSerializer, ProductImageSerializer, WebBannerSerializer, MobileBannerSerializer

# @api_view(['GET'])
class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


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
