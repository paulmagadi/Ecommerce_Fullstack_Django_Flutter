import datetime
from pyexpat.errors import messages
from django.forms import modelformset_factory
from django.shortcuts import render, redirect, get_object_or_404
from store.models import Product, ProductImage
from cart.models import Order, OrderItem
from .forms import CategoryForm, ProductImageForm, ProductModelForm

from django.contrib.auth.decorators import user_passes_test
from django.http import HttpResponse
from django.utils import timezone
# from users.decorators import group_required


from django.contrib import messages


def admin_or_staff_required(view_func):
    # Decorator that checks if the user is an admin or staff member
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_authenticated or not (request.user.is_staff or request.user.is_superuser):
            return HttpResponse(status=401)  # Or redirect to login page or show a 401 error page
        return view_func(request, *args, **kwargs)
    return _wrapped_view


# @group_required('Admin')
def admin_portal(request):
    products = Product.objects.all()
    latest_products = products.order_by('-created_at')[:10]
    orders = Order.objects.all()
    context = {
        'products':products,
        'latest_products': latest_products,
        'orders': orders
    }
    return render(request, 'admin_portal/admin_portal.html', context)

def add_category(request):
    products = Product.objects.all()
    products_count = products.count()
    now = timezone.now()
    new_products_count = products.filter(created_at__gte=now - datetime.timedelta(days=30)).count()
    out_of_stock_count = products.filter(stock_quantity__lte=0).count()
    is_listed_count = products.filter(is_listed=True).count()
    
    if request.method == 'POST':
        category_form = CategoryForm(request.POST, request.FILES)
        if category_form.is_valid():
            category_form.save()
            return redirect('add_category')  
        else:
            messages.error(request, 'Please correct the errors below.')
            
    else:
        category_form = CategoryForm()
        
    context = {
        'category_form': category_form,
        'products': products,
        'products_count': products_count,
        'new_products_count': new_products_count,
        'out_of_stock_count': out_of_stock_count,
        'is_listed_count': is_listed_count,
    }
    return render(request, 'admin_portal/add_category.html', context)



def add_product(request):
    products = Product.objects.all()
    products_count = products.count()
    now = timezone.now()
    new_products_count = products.filter(created_at__gte=now - datetime.timedelta(days=30)).count()
    out_of_stock_count = products.filter(stock_quantity__lte=0).count()
    is_listed_count = products.filter(is_listed=True).count()

    if request.method == 'POST':
        product_form = ProductModelForm(request.POST, request.FILES)
        product_image_form = ProductImageForm(request.POST, request.FILES)
        category_form = CategoryForm(request.POST)

        if product_form.is_valid() and product_image_form.is_valid():
            product = product_form.save()
            images = product_image_form.cleaned_data['product_images']
            for image in images:
                ProductImage.objects.create(product=product, product_images=image)

            messages.success(request, 'Product and images saved successfully!')
            return redirect('add_product')  
        else:
            messages.error(request, 'Please correct the errors below.')
    else:
        product_form = ProductModelForm()
        product_image_form = ProductImageForm()
        category_form = CategoryForm()

    context = {
        'product_form': product_form,
        'product_image_form': product_image_form,
        'category_form': category_form,
        'products': products,
        'products_count': products_count,
        'new_products_count': new_products_count,
        'out_of_stock_count': out_of_stock_count,
        'is_listed_count': is_listed_count,
    }

    return render(request, 'admin_portal/add_product.html', context)

def inventory(request):
    products = Product.objects.all()
    products_count = products.count()
    out_of_stock_count = products.filter(stock_quantity__lte=0).count() 
    is_listed_count = products.filter(is_listed=True).count()  
    context = {
        'products': products,
        'products_count': products_count,
        'out_of_stock_count': out_of_stock_count,
        'is_listed_count': is_listed_count,
    }
    return render(request, 'admin_portal/inventory.html', context)


def product_inventory(request, slug):
    product = get_object_or_404(Product, slug=slug)
    products = Product.objects.all()
    product_images = ProductImage.objects.filter(product=product)  
    products_count = products.count()
    out_of_stock_count = products.filter(stock_quantity__lte=0).count()
    is_listed_count = products.filter(is_listed=True).count()

    if request.method == 'POST':
        if 'product_form' in request.POST:
            product_form = ProductModelForm(request.POST, request.FILES, instance=product)
            product_image_form = ProductImageForm(request.POST, request.FILES)
            if product_form.is_valid() and product_image_form.is_valid():
                product_form.save()
                images = request.FILES.getlist('product_images')
                for image in images:
                    ProductImage.objects.create(product=product, product_images=image)
                messages.success(request, 'Product and images updated successfully!')
                return redirect('inventory')  
            else:
                messages.error(request, 'Please correct the errors below.')
        elif 'delete_image' in request.POST:
            image_id = request.POST.get('image_id')
            image_to_delete = get_object_or_404(ProductImage, id=image_id)
            image_to_delete.delete()
            messages.success(request, 'Image removed successfully!')
            return redirect('product_inventory', slug=slug)  

    else:
        product_form = ProductModelForm(instance=product)
        product_image_form = ProductImageForm()

    context = {
        'product': product,
        'product_images': product_images,
        'product_form': product_form,
        'product_image_form': product_image_form,
        'products_count': products_count,
        'out_of_stock_count': out_of_stock_count,
        'is_listed_count': is_listed_count
    }
    return render(request, 'admin_portal/product_inventory.html', context)


def orders(request):
    orders = Order.objects.all()
    shipped = orders.filter(is_shipped=True)
    pending = orders.filter(is_shipped=False)
    products = Product.objects.all()
    context = {
        'orders': orders,
        'shipped': shipped,
        'products': products,
        'pending': pending,
    }
    return render(request, 'admin_portal/orders.html', context)
     
