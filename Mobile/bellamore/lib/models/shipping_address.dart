class ShippingAddress {
  String? fullName;
  String? email;
  String? phone;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zipcode;
  String? country;

  ShippingAddress({
    this.fullName,
    this.email,
    this.phone,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  Map<String, String> toMap() {
    return {
      'fullName': fullName ?? '',
      'email': email ?? '',
      'phone': phone ?? '',
      'address1': address1 ?? '',
      'address2': address2 ?? '',
      'city': city ?? '',
      'state': state ?? '',
      'zipcode': zipcode ?? '',
      'country': country ?? '',
    };
  }
}
