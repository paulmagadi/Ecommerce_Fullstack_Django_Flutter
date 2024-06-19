from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoryViewSet, ProductViewSet, ProductImageViewSet, ProfileViewSet, MobileBannerViewSet, ShippingAddressViewSet, create_order
from . import views

router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'products', ProductViewSet)
router.register(r'product-images', ProductImageViewSet)
router.register(r'banners', MobileBannerViewSet)
router.register(r'profile', ProfileViewSet, basename='profile')
router.register(r'shipping-address', ShippingAddressViewSet, basename='shipping_address')



urlpatterns = [
    path('', include(router.urls)),
    path('get_csrf_token/', views.get_csrf_token, name='get_csrf_token'),
    path('create-order/', create_order, name='create_order'),
	
]



