from django.shortcuts import render, get_object_or_404
from store.models import Product, Category, WebBanner
from django.utils import timezone
from django.db.models import Q
import datetime

def home(request):
    all_products = Product.objects.all()
    products = all_products.filter(is_listed=True)
    banners = WebBanner.objects.filter(in_use=True)
    categories = Category.objects.all()
    sale_products = products.filter(is_sale=True)
    featured_products = products.filter(is_featured=True)

    context = {
        'products': products,
        'sale_products': sale_products,
        'featured_products': featured_products,
        'categories': categories,
        'banners': banners,
    }
    return render(request, 'main/index.html', context)
