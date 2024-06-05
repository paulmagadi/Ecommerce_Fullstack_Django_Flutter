from django.shortcuts import get_object_or_404, render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.conf import settings
from paypalrestsdk import Payment
import paypalrestsdk

from cart.cart import Cart
from cart.models import Order, OrderItem
from store.models import Product
from users.models import ShippingAddress
from . import paypal
import json

paypalrestsdk.configure({
    "mode": settings.PAYPAL_MODE,
    "client_id": settings.PAYPAL_CLIENT_ID,
    "client_secret": settings.PAYPAL_CLIENT_SECRET,
})


@login_required
def payment(request):
    cart_instance = Cart(request)
    cart_items = cart_instance.get_prods()
    cart_quantities = cart_instance.get_quants()
    total_quantity = sum(cart_quantities.values())
    order_total = cart_instance.order_total()

    shipping = ShippingAddress.objects.get(user=request.user)
    
    request.session['shipping'] = {
        'email': shipping.email,
        'phone': shipping.phone,
        'shipping_address1': shipping.address1,
        'shipping_address2': shipping.address2,
        'city': shipping.city,
        'state': shipping.state,
        'zipcode': shipping.zipcode,
        'country': shipping.country
    }

    context = {
        'cart_items': cart_items,
        'order_total': order_total,
        'total_quantity': total_quantity,
        'shipping': request.session['shipping']
    }
    return render(request, 'payment/payment.html', context)


@login_required
def process_payment(request):
    cart_instance = Cart(request)
    cart_items = cart_instance.get_prods()
    total_amount = str(cart_instance.order_total())

    payment = Payment({
        "intent": "sale",
        "payer": {
            "payment_method": "paypal"
        },
        "redirect_urls": {
            "return_url": request.build_absolute_uri('/payment/execute/'),
            "cancel_url": request.build_absolute_uri('/payment/cancel/')
        },
        "transactions": [{
            "item_list": {
                "items": [{
                    "name": item.name,
                    "sku": str(item.id),
                    "price": str(item.price if not item.is_sale else item.sale_price),
                    "currency": "USD",
                    "quantity": item.quantity
                } for item in cart_items]
            },
            "amount": {
                "total": total_amount,
                "currency": "USD"
            },
            "description": "Order payment."
        }]
    })

    if payment.create():
        for link in payment.links:
            if link.rel == "approval_url":
                approval_url = str(link.href)
                return redirect(approval_url)
    else:
        print(payment.error)
        messages.error(request, 'An error occurred while creating the PayPal payment.')
        return redirect('payment')


@login_required
def payment_execute(request):
    cart_instance = Cart(request)
    cart_items = cart_instance.get_prods() 
    cart_quantities = cart_instance.get_quants()
    total_quantity = sum(cart_quantities.values())
    order_total = cart_instance.order_total()
    products = Product.objects.all()
    payment_id = request.GET.get('paymentId')
    payer_id = request.GET.get('PayerID')

    payment = Payment.find(payment_id)

    if payment.execute({"payer_id": payer_id}):
        messages.success(request, 'Payment executed successfully.')

        user = request.user
        shipping = request.session.get('shipping')
        items = request.session.get('items')
        order_total = cart_instance.order_total()
         
        amount_paid = order_total
        full_name = f"{user.first_name} {user.last_name}"
        email = user.email
        shipping_address = f"{shipping['phone']} \n {shipping['shipping_address1']} \n {shipping['shipping_address2']} \n {shipping['city']} \n {shipping['state']} \n {shipping['zipcode']} \n {shipping['country']}"

        order = Order(user=user, full_name=full_name, email=email, amount_paid=amount_paid, shipping_address=shipping_address)
        order.save()

        order_id = order.pk
        for product in cart_items():
            product_id = product.id
            if product.is_sale:
                price = product.sale_price
            else:
                price = product.price
        
        for key, value in cart_quantities().items():
            if int(key) == product.id:
                order_item = OrderItem(order_id=order_id, product_id=product_id, user=user, quantity=value, price=price)
                order_item.save()
            
        


        return redirect('order_success')
    else:
        messages.error(request, 'Payment execution failed.')
        return redirect('payment')


    
def order_success(request):
    return render(request, 'payment/order_success.html')


def payment_cancel(request):
    messages.warning(request, 'Payment canceled.')
    return render(request, 'payment_cancel.html')