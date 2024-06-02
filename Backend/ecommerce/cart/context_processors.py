from .cart import Cart

# Make the cart session available in all pages
def cart(request):
    return {'cart': Cart(request)}