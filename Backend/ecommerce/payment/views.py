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
    cart_instance = Cart(request)
    cart_items = cart_instance.get_prods()
    total_amount = str(cart_instance.order_total())

    context = {
        'cart_items': cart_items,
        'total_amount': total_amount,
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
    payment_id = request.GET.get('paymentId')
    payer_id = request.GET.get('PayerID')

    payment = Payment.find(payment_id)

    if payment.execute({"payer_id": payer_id}):
        messages.success(request, 'Payment executed successfully.')
        return redirect('order_success')
    else:
        print(payment.error)
        messages.error(request, 'Payment execution failed.')
        return redirect('payment')


def payment_cancel(request):
    messages.warning(request, 'Payment canceled.')
    return render(request, 'payment_cancel.html')