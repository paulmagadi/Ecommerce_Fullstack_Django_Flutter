from rest_framework.response import Response
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from rest_framework.response import Response
from users.models import Profile
from .serializers import ProfileSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, mixins


from store.models import Category, Product, ProductImage, MobileBanner
from users.models import Profile, ShippingAddress
from .serializers import CategorySerializer, ProductSerializer, ProductImageSerializer, MobileBannerSerializer, ProfileSerializer, ShippingAddressSerializer

from django.http import JsonResponse
from django.views.decorators.csrf import ensure_csrf_cookie, csrf_exempt

from django.http import JsonResponse
from django.utils.decorators import method_decorator
from django.views import View
from users.models import CustomUser
from store.models import Product
from cart.models import Order, OrderItem
from rest_framework.decorators import api_view
from rest_framework import status
import json


@ensure_csrf_cookie
def get_csrf_token(request):
    return JsonResponse({'csrfToken': 'set'}) 

class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class ProductImageViewSet(viewsets.ModelViewSet):
    queryset = ProductImage.objects.all()
    serializer_class = ProductImageSerializer


class ProductViewSet(viewsets.GenericViewSet, mixins.ListModelMixin):
    products = Product.objects.all()
    queryset = products.filter(is_listed=True)
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
    
    


class MobileBannerViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MobileBanner.objects.filter(in_use=True) 
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
    
    
# class ShippingAddressViewSet(mixins.RetrieveModelMixin, mixins.UpdateModelMixin, viewsets.GenericViewSet):
#     permission_classes = [IsAuthenticated]
#     queryset = ShippingAddress.objects.all()
#     serializer_class = ShippingAddressSerializer

#     def get_object(self):
#         return self.queryset.get(user=self.request.user)

#     def update(self, request, *args, **kwargs):
#         instance = self.get_object()
#         serializer = self.get_serializer(instance, data=request.data, partial=True)
#         serializer.is_valid(raise_exception=True)
#         self.perform_update(serializer)
#         return Response(serializer.data)


# class ShippingAddressViewSet(mixins.RetrieveModelMixin, mixins.UpdateModelMixin, viewsets.GenericViewSet):
#     permission_classes = [IsAuthenticated]
#     queryset = ShippingAddress.objects.all()
#     serializer_class = ShippingAddressSerializer

#     def get_object(self):
#         try:
#             return self.queryset.get(user=self.request.user)
#         except ShippingAddress.DoesNotExist:
#             # Handle the case where the shipping address does not exist
#             raise NotFound('Shipping address does not exist for this user')

#     def update(self, request, *args, **kwargs):
#         instance = self.get_object()
#         serializer = self.get_serializer(instance, data=request.data, partial=True)
#         serializer.is_valid(raise_exception=True)
#         self.perform_update(serializer)
#         return Response(serializer.data)



class ShippingAddressViewSet(viewsets.GenericViewSet, mixins.UpdateModelMixin):
    permission_classes = [IsAuthenticated]
    queryset = ShippingAddress.objects.all()
    serializer_class = ShippingAddressSerializer

    def get_object(self):
        # Try to get the shipping address for the current user
        try:
            return self.queryset.get(user=self.request.user)
        except ShippingAddress.DoesNotExist:
            # Return None if no address is found
            return None

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance is not None:
            serializer = self.get_serializer(instance)
            return Response(serializer.data)
        else:
            return Response(
                {"detail": "Shipping address does not exist."},
                status=status.HTTP_404_NOT_FOUND
            )

    def create_or_update(self, request, *args, **kwargs):
        # Check if the user already has a shipping address
        instance = self.get_object()
        if instance:
            # Update existing shipping address
            serializer = self.get_serializer(instance, data=request.data, partial=True)
        else:
            # Create a new shipping address
            data = request.data.copy()
            data['user'] = request.user.id
            serializer = self.get_serializer(data=data)

        serializer.is_valid(raise_exception=True)
        self.perform_create_or_update(serializer)
        return Response(serializer.data)

    def perform_create_or_update(self, serializer):
        serializer.save()

    def update(self, request, *args, **kwargs):
        return self.create_or_update(request, *args, **kwargs)

    def create(self, request, *args, **kwargs):
        return self.create_or_update(request, *args, **kwargs)




# @method_decorator(csrf_exempt, name='dispatch')
# class CreateOrderView(View):
#     def post(self, request):
#         data = json.loads(request.body)
#         user_id = data.get('user_id')
#         full_name = data.get('full_name')
#         email = data.get('email')
#         amount_paid = data.get('amount_paid')
#         shipping_address = data.get('shipping_address')
#         items = data.get('items')

#         try:
#             user = CustomUser.objects.get(id=user_id)
#             order = Order.objects.create(
#                 user=user,
#                 full_name=full_name,
#                 email=email,
#                 amount_paid=amount_paid,
#                 shipping_address=json.dumps(shipping_address)
#             )

#             for item in items:
#                 product = Product.objects.get(id=item['product_id'])
#                 order_item = OrderItem.objects.create(
#                     order=order,
#                     product=product,
#                     user=user,
#                     quantity=item['quantity'],
#                     price=item['price']
#                 )
#                 product.stock_quantity -= item['quantity']
#                 product.save()

#             return JsonResponse({'status': 'success', 'order_id': order.id}, status=201)

#         except CustomUser.DoesNotExist:
#             return JsonResponse({'status': 'error', 'message': 'User not found'}, status=400)
#         except Product.DoesNotExist:
#             return JsonResponse({'status': 'error', 'message': 'Product not found'}, status=400)
#         except Exception as e:
#             return JsonResponse({'status': 'error', 'message': str(e)}, status=500)

    
# import logging

# logger = logging.getLogger(__name__)

# @csrf_exempt
# @api_view(['POST'])
# def create_order(request):
#     try:
#         data = request.data
#         user_id = data.get('user')

#         if not user_id:
#             raise ValueError("User ID is required")

#         user = CustomUser.objects.get(id=user_id)

#         order = Order.objects.create(
#             user=user,
#             full_name=data.get('full_name', ''),
#             email=data.get('email', ''),
#             amount_paid=data.get('amount_paid', 0),
#             shipping_address=json.dumps(data.get('shipping_address', {}))
#         )

#         items = data.get('items', [])
#         for item in items:
#             product_id = item.get('product_id')
#             if not product_id:
#                 continue  # or handle the error appropriately

#             product = Product.objects.get(id=product_id)
#             OrderItem.objects.create(
#                 order=order,
#                 product=product,
#                 user=user,
#                 quantity=item.get('quantity', 1),
#                 price=item.get('price', 0)
#             )

#         return Response({'message': 'Order created successfully'}, status=status.HTTP_201_CREATED)

#     except CustomUser.DoesNotExist:
#         return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
#     except Product.DoesNotExist:
#         return Response({'error': 'Product not found'}, status=status.HTTP_404_NOT_FOUND)
#     except ValueError as e:
#         return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
#     except Exception as e:
#         logger.error(f"Error creating order: {e}")
#         return Response({'error': 'An error occurred while creating the order'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


import logging
logger = logging.getLogger(__name__)

@csrf_exempt
@api_view(['POST'])
def create_order(request):
    try:
        data = request.data
        user_id = data.get('user')

        if not user_id:
            raise ValueError("User ID is required")

        user = CustomUser.objects.get(id=user_id)
        
        

        order = Order.objects.create(
            user=user,
            full_name=data.get('full_name', ''),
            email=data.get('email', ''),
            amount_paid=data.get('amount_paid', 0),
            shipping_address=data.get('shipping_address', {})
        )

        items = data.get('items', [])
        for item in items:
            product_id = item.get('product_id')
            if not product_id:
                continue  # or handle the error appropriately

            product = Product.objects.get(id=product_id)
            
            # Check if enough quantity is available
            if product.stock_quantity < item.get('quantity', 1):
                return Response({'error': f'Insufficient stock for product {product.name}'}, status=status.HTTP_400_BAD_REQUEST)

            # Reduce the quantity
            product.stock_quantity -= item.get('quantity', 1)
            product.save()
            
            OrderItem.objects.create(
                order=order,
                product=product,
                user=user,
                quantity=item.get('quantity', 1),
                price=item.get('price', 0)
            )

        return Response({'message': 'Order created successfully'}, status=status.HTTP_201_CREATED)

    except CustomUser.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
    except Product.DoesNotExist:
        return Response({'error': 'Product not found'}, status=status.HTTP_404_NOT_FOUND)
    except ValueError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        logger.error(f"Error creating order: {e}")
        return Response({'error': 'An error occurred while creating the order'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
