from datetime import datetime
from django.shortcuts import render, redirect, get_object_or_404
from .models import Product, Category, WebBanner
from django.contrib import messages
from django.utils import timezone
from django.db.models import Q
import datetime

# def home(request):
#     all_products = Product.objects.all()
#     products = all_products.filter(is_listed=True)
#     banners = WebBanner.objects.filter(in_use=True)
#     sale_products = products.filter(is_sale=True)
#     now = timezone.now()
#     new_products= all_products.filter(created_at__gte=now - datetime.timedelta(days=30))
#     featured_products = products.filter(is_featured=True)

#     context = {
#         'products': products,
#         'sale_products': sale_products,
#         'new_products': new_products,
#         'featured_products': featured_products,
#         'banners': banners,
#     }
#     return render(request, 'mains/index.html', context)


def product(request, pk):
    product = Product.objects.get(id=pk)
    stock_quantity = product.stock_quantity
    context = {
        'product': product,
        'stock_quantity': stock_quantity
    }
    return render(request, 'store/product.html', context)


def category(request, pk):
    category = Category.objects.get(id=pk)
    products = Product.objects.filter(category=category)
    context = {
        'category': category,
        'products': products,
    }
    return render(request, 'store/category.html', context)


def categories(request):
    categories = Category.objects.all()
    products = Product.objects.all()
    context = {
        'categories': categories,
        'products': products,
    }
    return render(request, 'store/all_categories.html', context)
    

def sale(request):
    products = Product.objects.filter(is_sale=True)
    now = timezone.now()
    new_products = products.filter(created_at__gte=now - datetime.timedelta(days=30))
    context = {
        'products': products,
        'new_products': new_products,
    }
    return render(request, 'store/sale.html', context)


def new(request):
    products = Product.objects.all()
    now = timezone.now()
    new_product_ids = products.filter(created_at__gte=now - datetime.timedelta(days=30)).values_list('id', flat=True)
    context = {
        'products': products, 'new_products': new_product_ids
    }
    return render(request, 'store/new.html', context)
    


def featured(request):
    products = Product.objects.filter(is_featured=True)
    now = timezone.now()
    new_product_ids = products.filter(created_at__gte=now - datetime.timedelta(days=30)).values_list('id', flat=True)
    context = {
        'products': products, 'new_products': new_product_ids,
    }
    return render(request, 'store/featured.html', context)


def search(request):
    query = request.GET.get('query')
    products = Product.objects.filter(Q(name__contains=query) | Q(description__contains=query) | Q(category__name__icontains=query))
    now = timezone.now()
    new_product_ids = products.filter(created_at__gte=now - datetime.timedelta(days=30)).values_list('id', flat=True)
    context = {
        'query': query,
        'products': products,
        'new_products': new_product_ids,
    }
    return render(request, 'store/search.html', context)

