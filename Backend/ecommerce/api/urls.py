from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoryViewSet, CreateOrderView, ProductViewSet, ProductImageViewSet, ProfileViewSet, WebBannerViewSet, MobileBannerViewSet, ShippingAddressViewSet
from . import views

router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'products', ProductViewSet)
router.register(r'product-images', ProductImageViewSet)
router.register(r'web-banners', WebBannerViewSet)
router.register(r'banners', MobileBannerViewSet)
router.register(r'profile', ProfileViewSet, basename='profile')
router.register(r'shipping-address', ShippingAddressViewSet)


urlpatterns = [
    path('', include(router.urls)),
    path('get_csrf_token/', views.get_csrf_token, name='get_csrf_token'),
    path('create_order/', CreateOrderView.as_view(), name='create_order'),
	
]



