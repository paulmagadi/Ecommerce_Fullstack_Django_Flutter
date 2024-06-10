from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework import viewsets
from rest_framework import generics
# from rest_framework.decorators import api_view

from store.models import Category, Product, ProductImage, WebBanner, MobileBanner
from .serializers import CategorySerializer, ProductSerializer, ProductImageSerializer, WebBannerSerializer, MobileBannerSerializer


    
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

from users.models import Profile
from users.serializers import ProfileSerializer

class ProfileViewSet(viewsets.ModelViewSet):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_authenticated:
            return Profile.objects.filter(user=user)
        return Profile.objects.none()

def profile_view(request):
    try:
        profile = Profile.objects.get(user=request.user)
    except Profile.DoesNotExist:
        profile = Profile(user=request.user)

    serializer = ProfileSerializer(profile, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    
