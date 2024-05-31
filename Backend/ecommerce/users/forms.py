from django.contrib.auth.forms import UserCreationForm, UserChangeForm, PasswordChangeForm
from django import forms
from .models import CustomUser, Profile, ShippingAddress


class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ("email",)


# class CustomUserChangeForm(UserChangeForm):
#     class Meta:
#         model = CustomUser
#         fields = ("email",)


# class CustomUserRegistrationForm(UserCreationForm):
#     first_name = forms.CharField(max_length=30, required=True)
#     last_name = forms.CharField(max_length=30, required=True)
#     email = forms.EmailField(required=True)

#     class Meta:
#         model = CustomUser
#         fields = ('first_name', 'last_name', 'email', 'password1', 'password2')


# class UpdateUserForm(UserChangeForm):
#     password = None

#     class Meta:
#         model = CustomUser
#         fields = ['first_name', 'last_name', 'email']


# class UpdateUserPassword(PasswordChangeForm):
#     class Meta:
#         model = CustomUser
#         fields = ['new_password1', 'new_password2']


# class UpdateInfoForm(forms.ModelForm):
#     phone = forms.CharField()
#     address1 = forms.CharField()
#     address2 = forms.CharField()
#     city = forms.CharField()
#     state = forms.CharField()
#     zipcode = forms.CharField()
#     country = forms.CharField()

#     class Meta:
#         model = Profile
#         fields = ["phone", "address1", "address2", "city", "state", "zipcode", "country"]


# class ShippingAddressForm(forms.ModelForm):
#     phone = forms.CharField()
#     address1 = forms.CharField()
#     address2 = forms.CharField()
#     city = forms.CharField()
#     state = forms.CharField()
#     zipcode = forms.CharField()
#     country = forms.CharField()

#     class Meta:
#         model = ShippingAddress
#         fields = ["phone", "address1", "address2", "city", "state", "zipcode", "country"]
        
