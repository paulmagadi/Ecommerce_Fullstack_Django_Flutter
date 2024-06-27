from django.shortcuts import get_object_or_404, render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.conf import settings
from paypalrestsdk import Payment
import paypalrestsdk

from cart.cart import Cart
from cart.models import Order, OrderItem
from store.models import Product
from users.models import ShippingAddress, Profile
from django.views.decorators.csrf import csrf_exempt

import paypalrestsdk
from django.conf import settings
import logging

logger = logging.getLogger(__name__)



paypalrestsdk.configure({
    "mode": settings.PAYPAL_MODE,
    "client_id": settings.PAYPAL_CLIENT_ID,
    "client_secret": settings.PAYPAL_CLIENT_SECRET,
})

@csrf_exempt
# @login_required
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

@csrf_exempt
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

@csrf_exempt
# @login_required
def payment_execute(request):
    cart_instance = Cart(request)
    cart_items = cart_instance.get_prods() 
    cart_quantities = cart_instance.get_quants()  
    order_total = cart_instance.order_total()
    payment_id = request.GET.get('paymentId')
    payer_id = request.GET.get('PayerID')

    payment = Payment.find(payment_id)

    if payment.execute({"payer_id": payer_id}):
        messages.success(request, 'Payment executed successfully.')

        user = request.user
        shipping = request.session.get('shipping')
        items = request.session.get('cart_items')
        amount_paid = order_total
        full_name = f"{user.first_name} {user.last_name}"
        email = user.email
        shipping_address = (
            f"{shipping['phone']} \n"
            f"{shipping['shipping_address1']} \n"
            f"{shipping['shipping_address2']} \n"
            f"{shipping['city']} \n"
            f"{shipping['state']} \n"
            f"{shipping['zipcode']} \n"
            f"{shipping['country']}"
        )

        # Create the order
        order = Order(
            user=user, 
            full_name=full_name, 
            email=email, 
            amount_paid=amount_paid, 
            shipping_address=shipping_address
        )
        order.save()

        # Create OrderItems
        for item in cart_items:
            product = Product.objects.get(id=item.id)
            order_item = OrderItem(
                order=order,
                product=product,
                user=user,
                quantity=cart_quantities[str(item.id)],  
                price=item.sale_price if item.is_sale else item.price
            )
            order_item.save()
            
        
        product.stock_quantity -= cart_quantities[str(item.id)]
        product.save()
        # Clear the cart
        for key in list(request.session.keys()):
            if key == "session_key":
                del request.session[key]

        Profile.objects.filter(user__id=request.user.id).update(old_cart="")



        return redirect('order_success')
    else:
        messages.error(request, 'Payment execution failed.')
        return redirect('payment')


    
def order_success(request):
    return render(request, 'payment/order_success.html')


def payment_cancel(request):
    messages.warning(request, 'Payment canceled.')
    return render(request, 'payment_cancel.html')