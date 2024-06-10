from rest_framework import serializers
from djoser.serializers import UserCreateSerializer
from .models import CustomUser, Profile




class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'email', 'first_name', 'last_name']

# class CustomUserCreateSerializer(serializers.ModelSerializer):
#     password = serializers.CharField(write_only=True)

#     class Meta:
#         model = CustomUser
#         fields = ['email', 'first_name', 'last_name', 'password']

#     def create(self, validated_data):
#         user = CustomUser.objects.create_user(
#             email=validated_data['email'],
#             first_name=validated_data['first_name'],
#             last_name=validated_data['last_name'],
#             password=validated_data['password']
#         )
#         return user
    
class CustomUserCreateSerializer(serializers.ModelSerializer):
    password1 = serializers.CharField(write_only=True, required=True)
    password2 = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = CustomUser
        fields = ('email', 'first_name', 'last_name', 'password1', 'password2')

    def validate(self, data):
        if data['password1'] != data['password2']:
            raise serializers.ValidationError("Passwords do not match")
        return data

    def create(self, validated_data):
        validated_data.pop('password2')
        password = validated_data.pop('password1')
        user = CustomUser.objects.create(**validated_data)
        user.set_password(password)
        user.save()
        return user
    
    
class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ('phone', 'address1', 'address2', 'city', 'state', 'zipcode', 'country', 'old_cart')
