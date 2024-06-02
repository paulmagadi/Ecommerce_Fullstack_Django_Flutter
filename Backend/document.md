# Ecommerce Application Web Backend

# Dependencies
1. Python
2. Django
3. Pillow
4. Django Rest Framework
5. Djoser
6. MPTT

# Apps
1. Main
2. Users
3. Store
4. api
5. cart
6. admin


# Models
 1. Categories
 2. Products
 3. Specifications
 4. Profile
 6. User
 7. Shipping
 8. Color
 9. Size
 10. Brand
 11. Material

Core Models:

User: Represents the customer or user interacting with the website. Includes information such as email, name, address, and payment methods.
Product: Represents the item being sold. Includes details like name, description, price, and availability.
Category: Organizes products into logical groups, such as clothing, electronics, or furniture.
Order: Represents a transaction made by a user. Includes information such as order date, items purchased, and total amount.
Order Item: Represents an individual item purchased in an order. Includes quantity, unit price, and other details.
Shipping and Fulfillment Models:

Shipping Address: Stores the user's preferred shipping address.
Shipping Carrier: Represents the company responsible for delivering orders.
Shipping Method: Specifies the type of shipping service (e.g., standard, express, overnight).
Fulfillment Center: The warehouse or facility where products are stored and shipped from.
Payment Models:

Payment Gateway: The service that handles secure payment processing.
Payment Method: The specific type of payment method used (e.g., credit card, PayPal, bank transfer).
Payment Transaction: Represents an individual payment made by a user.
Additional Models:

Review: Stores customer feedback on products.
Promotion: Represents discounts, coupons, or other promotional offers.
Cart: Temporarily stores items added to the user's shopping cart.
Wishlist: Stores items that users have saved for future reference or purchase.
Notification: Keeps track of notifications sent to users, such as order updates or abandoned cart reminders.
Consider Additional Models Based on Your Specific Business Needs:

Inventory Item: Tracks the quantity and availability of specific products on hand.
Product Image: Stores images associated with products.
Tax Rate: Represents different tax rates applicable to various products and locations.
Subscription: Manages recurring orders or subscriptions made by users.
Affiliate: Tracks affiliate partners and their sales referrals.