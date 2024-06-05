# views.py
from django.shortcuts import get_object_or_404, render, redirect
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
def checkout(request):
    order_id = request.session.get('order_id')
    order = get_object_or_404(Order, id=order_id)

    context = {
        'order': order,
    }
    return render(request, 'cart/checkout.html', context)

@login_required
def payment(request):
    order_id = request.session.get('order_id')
    order = get_object_or_404(Order, id=order_id)

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
                    "name": item.product.name,
                    "sku": str(item.product.id),
                    "price": str(item.price),
                    "currency": "USD",
                    "quantity": item.quantity
                } for item in order.items.all()]
            },
            "amount": {
                "total": str(order.total_price),
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
        return redirect('checkout')

@login_required
def payment_execute(request):
    payment_id = request.GET.get('paymentId')
    payer_id = request.GET.get('PayerID')

    payment = Payment.find(payment_id)

    if payment.execute({"payer_id": payer_id}):
        order_id = request.session.get('order_id')
        order = get_object_or_404(Order, id=order_id)
        order.is_paid = True
        order.save()

        # Clear the cart after successful payment
        cart = Cart(request)
        cart.clear()

        messages.success(request, 'Payment executed successfully.')
        return redirect('home')
    else:
        print(payment.error)
        messages.error(request, 'Payment execution failed.')
        return redirect('checkout')

def payment_cancel(request):
    messages.warning(request, 'Payment canceled.')
    return render(request, 'payment/payment.html')