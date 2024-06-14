
class ShippingAddress {
  final int id;
  final int user;
  final String? phone;
  final String? fullName;
  final String? email;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  ShippingAddress({
    required this.id,
    required this.user,
    this.phone,
    this.fullName,
    this.email,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      user: json['user'],
      phone: json['phone'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'phone': phone,
      'full_name': fullName,
      'email': email,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
    };
  }
}
