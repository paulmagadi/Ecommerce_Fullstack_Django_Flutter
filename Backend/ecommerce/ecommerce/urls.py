
from django.contrib import admin
from django.urls import path, include
from django.conf.urls.static import static
from . import settings

from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi


schema_view = get_schema_view(
   openapi.Info(
      title="Bellamore API",
      default_version='v1',
      description="Backend Documentation",
      terms_of_service="https://www.google.com/policies/terms/",
      contact=openapi.Contact(email="sqcodes@gmail.com"),
      license=openapi.License(name="BSD License"),
   ),
   public=True,
   permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('main.urls')),
    path('users/', include('users.urls')),
    path('', include('store.urls')),
    path('cart/', include('cart.urls')),
    path('', include('admin_portal.urls')),
    path('payment/', include('payment.urls')),
    path('api/', include('api.urls')),
    path('api/auth/', include('djoser.urls')),  
    path('api/auth/', include('djoser.urls.jwt')),
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)





