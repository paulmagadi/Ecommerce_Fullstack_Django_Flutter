from django.shortcuts import redirect, render, get_object_or_404
from django.contrib.auth.decorators import login_required
from .cart import Cart
from store.models import Product
from django.contrib import messages
from django.http import JsonResponse
from users.forms import ShippingAddressForm
from users.models import ShippingAddress


def cart(request):
    cart_instance = Cart(request)  
    cart_items = cart_instance.get_prods() 
    cart_quantities = cart_instance.get_quants()
    total_quantity = sum(cart_quantities.values())
    order_total = cart_instance.order_total()

    context = {
        'cart_items': cart_items,
        'cart_quantities': cart_quantities,
        'total_quantity': total_quantity,
        'order_total': order_total
    }
    return render(request, 'cart/cart.html', context)


def cart_add(request):
    cart = Cart(request)
    if request.POST.get('product_id'):
        product_id = int(request.POST.get('product_id'))
        product_qty = int(request.POST.get('product_qty'))
        product = get_object_or_404(Product, id=product_id)
        cart.add(product=product, quantity=product_qty, request=request)
        
        cart_quantity = cart.__len__()
        response = JsonResponse({'qty': cart_quantity})
        return response
    
    
def cart_update(request):
    cart = Cart(request)
    if request.POST.get('action') == 'post':
        product_id = int(request.POST.get('product_id'))
        product = get_object_or_404(Product, id=product_id) 
        product_qty = int(request.POST.get('product_qty'))

        cart.update(request, product=product, quantity=product_qty)  

        response = JsonResponse({'qty': product_qty})
        return response


def cart_delete(request):
    cart = Cart(request)
    if request.POST.get('action') == 'post':
        product_id = int(request.POST.get('product_id'))
        product = get_object_or_404(Product, id=product_id)
        cart.delete(product=product_id)

        response = JsonResponse({'product': product_id})
        messages.info(request, f'{product.name} removed from cart')
        return response

@login_required
def checkout(request):
    cart_instance = Cart(request)  
    cart_items = cart_instance.get_prods() 
    cart_quantities = cart_instance.get_quants()
    total_quantity = sum(cart_quantities.values())
    order_total = cart_instance.order_total()
    products = Product.objects.all()

    try:
        shipping_address = ShippingAddress.objects.get(user=request.user)
    except ShippingAddress.DoesNotExist:
        shipping_address = None

    if request.method == 'POST':
        form = ShippingAddressForm(request.POST, instance=shipping_address)
        shipping = request.POST
        request.session['shipping'] = shipping
        if form.is_valid():
            shipping_address = form.save(commit=False)
            shipping_address.user = request.user
            shipping_address.save()
            messages.success(request, "Your shipping information has been updated.")
            return redirect('payment')
        else:
            messages.error(request, "Please correct the errors below.")
    else:
        form = ShippingAddressForm(instance=shipping_address)

    user_profile = request.user.profile  # Assuming the profile is related to CustomUser as a OneToOneField

    context = {
        'cart_items': cart_items,
        'cart_quantities': cart_quantities,
        'total_quantity': total_quantity,
        'order_total': order_total,
        'products': products,
        'form': form,
        'user_profile': user_profile,
    }
    return render(request, 'cart/checkout.html', context)
