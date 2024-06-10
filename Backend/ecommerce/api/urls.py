from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoryViewSet, ProductViewSet, ProductImageViewSet, WebBannerViewSet, MobileBannerViewSet, profile_view

router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'products', ProductViewSet)
router.register(r'product-images', ProductImageViewSet)
router.register(r'web-banners', WebBannerViewSet)
router.register(r'mobile-banners', MobileBannerViewSet)
# router.register(r'profiles', ProfileViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('api/profile/', profile_view, name='profile'),
]


