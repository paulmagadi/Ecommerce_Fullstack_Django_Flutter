from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoryViewSet, ProductViewSet, ProductImageViewSet, ProfileViewSet, WebBannerViewSet, MobileBannerViewSet
from . import views

router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'products', ProductViewSet)
router.register(r'product-images', ProductImageViewSet)
router.register(r'web-banners', WebBannerViewSet)
router.register(r'mobile-banners', MobileBannerViewSet)
# router.register(r'profile', ProfileViewSet, basename='profile')

urlpatterns = [
    path('', include(router.urls)),
    path('profile/', ProfileViewSet.as_view(), name='profile'),
]


