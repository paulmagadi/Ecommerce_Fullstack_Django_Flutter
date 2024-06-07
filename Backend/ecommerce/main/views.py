from django.shortcuts import render, get_object_or_404
from store.models import Product, Category, WebBanner
from django.utils import timezone
from django.db.models import Q
import datetime

def home(request):
    all_products = Product.objects.all()
    products = all_products.filter(is_listed=True)
    banners = WebBanner.objects.filter(in_use=True)
    sale_products = products.filter(is_sale=True)
    # now = timezone.now()
    # new_product_ids = all_products.filter(created_at__gte=now - datetime.timedelta(days=30)).values_list('id', flat=True)
    featured_products = products.filter(is_featured=True)

    context = {
        'products': products,
        'sale_products': sale_products,
        # 'new_products': new_product_ids,
        'featured_products': featured_products,
        'banners': banners,
    }
    return render(request, 'main/index.html', context)
