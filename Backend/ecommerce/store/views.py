from datetime import datetime
from django.shortcuts import render, redirect, get_object_or_404
from .models import Product, Category, WebBanner
from django.contrib import messages
from django.utils import timezone
from django.db.models import Q
import datetime


def product(request, slug):
    product = get_object_or_404(Product, slug=slug)
    product_images = product.product_images.all() 
    stock_quantity = product.stock_quantity
    context = {
        'product': product,
        'product_images': product_images,
        'stock_quantity': stock_quantity
    }
    return render(request, 'store/product.html', context)


def category(request, pk):
    category = Category.objects.get(slug=pk)
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
    # products = Product.objects.filter(Q(is_sale=True) | Q(sale_price__isnull=False))
    context = {
        'products': products,
    }
    return render(request, 'store/sale.html', context)


def new(request):
    products = Product.objects.all()
    context = {
        'products': products, 
    }
    return render(request, 'store/new.html', context)
    


def featured(request):
    products = Product.objects.filter(is_featured=True)
    context = {
        'products': products, }
    return render(request, 'store/featured.html', context)

def products(request):
    all_products = Product.objects.all()
    products = all_products.filter(is_listed=True)
    banners = WebBanner.objects.filter(in_use=True)
    sale_products = products.filter(is_sale=True)
    featured_products = products.filter(is_featured=True)

    context = {
        'products': products,
        'sale_products': sale_products,
        'featured_products': featured_products,
        'banners': banners,
    }
    return render(request, 'store/all_products.html', context)


def search(request):
    query = request.GET.get('query')
    products = Product.objects.filter(Q(name__contains=query) | Q(key_words__contains=query) |  Q(description__contains=query) | Q(category__name__contains=query))
  
    context = {
        'query': query,
        'products': products,
    }
    return render(request, 'store/search.html', context)



