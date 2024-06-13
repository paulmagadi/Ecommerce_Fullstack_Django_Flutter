class Profile {
  final String user;
  final String? image;
  final String? phone;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  Profile({
    required this.user,
     this.image,
     this.phone,
     this.address1,
     this.address2,
     this.city,
     this.state,
     this.zipcode,
     this.country,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user: json['user'],
      image: json['image'] ?? 'default/pic.png',
      phone: json['phone'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
