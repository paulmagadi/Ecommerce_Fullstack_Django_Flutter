# views.py
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.conf import settings
from paypalrestsdk import Payment
import paypalrestsdk

from cart.cart import Cart
from cart.models import Order, OrderItem
from . import paypal
import json

paypalrestsdk.configure({
    "mode": settings.PAYPAL_MODE,
    "client_id": settings.PAYPAL_CLIENT_ID,
    "client_secret": settings.PAYPAL_CLIENT_SECRET,
})


@login_required
def payment(request):
    if request.user.is_authenticated:
        cart_instance = Cart(request)  
        cart_items = cart_instance.get_prods() 
        cart_quantities = cart_instance.get_quants()
        total_quantity = sum(cart_quantities.values())
        order_total = cart_instance.order_total()
        cart_items = cart_instance.get_prods()
        
        shipping = request.session.get('shipping')
        
        user = request.user
        full_name = f"{shipping['first_name']} {shipping['last_name']}"
        email = shipping['email']
        amount_paid = order_total
        shipping_address = f"{shipping['phone']} \n {shipping['shipping_address1']} \n {shipping['shipping_address2']} \n {shipping['city']} \n {shipping['state']} \n {shipping['zipcode']} \n {shipping['country']}"
        
        order = Order(user=user, full_name=full_name, email=email, amount_paid=amount_paid, shipping_address=shipping_address)
    
        

        context = {
            'cart_items': cart_items,
            'order_total': order_total,
            'total_quantity':total_quantity
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
    cart = Cart(request)
    payment_id = request.GET.get('paymentId')
    payer_id = request.GET.get('PayerID')

    payment = Payment.find(payment_id)

    if payment.execute({"payer_id": payer_id}):
        messages.success(request, 'Payment executed successfully.')
        cart.clear()
        return redirect('home')
    else:
        print(payment.error)
        messages.error(request, 'Payment execution failed.')
        return redirect('payment')


def payment_cancel(request):
    messages.warning(request, 'Payment canceled.')
    return render(request, 'payment_cancel.html')