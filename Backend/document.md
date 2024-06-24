# Ecommerce Application Web Backend

To run the application: `py manage.py runserver`


**NOTE:** Check the Database settings. Use the `SQLITE` database settings for testing with localhost

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

# Dependencies
1. Python
2. Django
3. Pillow
4. Django Rest Framework
5. Djoser
6. jwt


# Apps
1. Main
2. Users
3. Store
4. api
5. cart
6. admin
7. payment


# Models
 1. Categories
 2. Products
 3. Product Images
 4. Profile
 6. User
 7. Shipping
 8. Banners
