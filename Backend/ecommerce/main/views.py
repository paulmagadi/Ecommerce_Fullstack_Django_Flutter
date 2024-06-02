from django.shortcuts import render, redirect, get_object_or_404
from store.models import Product, Category, WebBanner
from django.contrib import messages
import datetime
from django.db.models import Q

def home(request):
    all_products = Product.objects.all()
    products = all_products.filter(is_listed=True)
    banners = WebBanner.objects.filter(in_use=True)
    sale_products = products.filter(is_sale=True)
    # new_products = products.filter(is_new=True)
    featured_products = products.filter(is_featured=True)
    context = {
        'products': products,
        'sale_products': sale_products,
        # 'new_products': new_products,
        'featured_products': featured_products,
        'banners': banners,
    }
    return render(request, 'main/index.html', context)