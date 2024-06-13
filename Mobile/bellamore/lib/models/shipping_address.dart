class ShippingAddress {
  final String user;
  final String phone;
  final String fullName;
  final String email;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zipcode;
  final String country;

  ShippingAddress({
    required this.user,
    required this.phone,
    required this.fullName,
    required this.email,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      user: json['user'],
      phone: json['phone'] ?? '',
      fullName: json['full_name'],
      email: json['email'],
      address1: json['address1'],
      address2: json['address2'] ?? '',
      city: json['city'],
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'],
    );
  }
}
