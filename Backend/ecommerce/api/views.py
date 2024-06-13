from rest_framework.response import Response
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from rest_framework.response import Response
from users.models import Profile
from .serializers import ProfileSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, mixins


from store.models import Category, Product, ProductImage, WebBanner, MobileBanner
from users.models import Profile
from .serializers import CategorySerializer, ProductSerializer, ProductImageSerializer, WebBannerSerializer, MobileBannerSerializer, ProfileSerializer


    
class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class ProductImageViewSet(viewsets.ModelViewSet):
    queryset = ProductImage.objects.all()
    serializer_class = ProductImageSerializer

# class ProductViewSet(viewsets.ModelViewSet):
#     queryset = Product.objects.all()
#     serializer_class = ProductSerializer

class ProductViewSet(viewsets.GenericViewSet, mixins.ListModelMixin):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def get_queryset(self):
        queryset = self.queryset
        query = Q()

        # Retrieve query parameters
        name = self.request.query_params.get('name', None)
        category_id = self.request.query_params.get('category', None)
        brand = self.request.query_params.get('brand', None)
        key_words = self.request.query_params.get('key_words', None)
        color = self.request.query_params.get('color', None)
        material = self.request.query_params.get('material', None)

        # Add filters dynamically based on the presence of query parameters
        if name:
            query &= Q(name__icontains=name)
        if category_id:
            try:
                category_id = int(category_id)
                query &= Q(category_id=category_id)
            except ValueError:
                # Handle invalid category_id gracefully
                queryset = queryset.none()
                return queryset
        if brand:
            query &= Q(brand__icontains=brand)
        if key_words:
            query &= Q(key_words__icontains=key_words)
        if color:
            query &= Q(color__icontains=color)
        if material:
            query &= Q(material__icontains=material)

        # Apply the dynamic query filters to the queryset
        queryset = queryset.filter(query)

        # Debug: Log the constructed query (for development purposes only)
        print(queryset.query)

        return queryset

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
    
    
    

    

class WebBannerViewSet(viewsets.ModelViewSet):
    queryset = WebBanner.objects.all()
    serializer_class = WebBannerSerializer

# class MobileBannerViewSet(viewsets.ModelViewSet):
#     queryset = MobileBanner.objects.all()
#     serializer_class = MobileBannerSerializer

class MobileBannerViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MobileBanner.objects.filter(in_use=True)  # Filter by in_use=True
    serializer_class = MobileBannerSerializer



class ProfileViewSet(mixins.RetrieveModelMixin, mixins.UpdateModelMixin, viewsets.GenericViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

    def get_object(self):
        return self.queryset.get(user=self.request.user)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)