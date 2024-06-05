# views.py
from django.shortcuts import render, redirect
from django.conf import settings
from paypalrestsdk import Payment
from .models import Order, OrderItem
import paypalrestsdk
import json

# Initialize PayPal SDK
paypalrestsdk.configure({
    "mode": settings.PAYPAL_MODE,
    "client_id": settings.PAYPAL_CLIENT_ID,
    "client_secret": settings.PAYPAL_CLIENT_SECRET,
})

def checkout_view(request):
    cart = Cart(request)
    if request.method == 'POST':
        form = CheckoutForm(request.POST)
        if form.is_valid():
            order = Order.objects.create(
                user=request.user,
                total_price=cart.order_total(),
                address=form.cleaned_data['address'],
                city=form.cleaned_data['city'],
                state=form.cleaned_data['state'],
                zip_code=form.cleaned_data['zip_code']
            )
            for item in cart.get_prods():
                OrderItem.objects.create(
                    order=order,
                    product=item,
                    quantity=item.quantity,
                    price=item.price if not item.is_sale else item.sale_price,
                    color=item.color,
                    size=item.size
                )

            # Create PayPal payment
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
                            "sku": item.id,
                            "price": str(item.price if not item.is_sale else item.sale_price),
                            "currency": "USD",
                            "quantity": item.quantity
                        } for item in cart.get_prods()]
                    },
                    "amount": {
                        "total": str(cart.order_total()),
                        "currency": "USD"
                    },
                    "description": f"Order {order.id}"
                }]
            })

            if payment.create():
                request.session['order_id'] = order.id
                for link in payment.links:
                    if link.rel == "approval_url":
                        return redirect(link.href)
            else:
                print(payment.error)
                # Handle payment creation error

    else:
        form = CheckoutForm()

    return render(request, 'checkout.html', {'form': form, 'cart': cart})

def payment_execute_view(request):
    order_id = request.session.get('order_id')
    order = Order.objects.get(id=order_id)
    payment_id = request.GET.get('paymentId')
    payer_id = request.GET.get('PayerID')

    payment = Payment.find(payment_id)

    if payment.execute({"payer_id": payer_id}):
        order.status = 'completed'
        order.save()
        return redirect('order_success')
    else:
        print(payment.error)
        # Handle payment execution error

def payment_cancel_view(request):
    return render(request, 'payment_cancel.html')
