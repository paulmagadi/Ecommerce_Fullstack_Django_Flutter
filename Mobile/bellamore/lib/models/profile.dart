

class Profile {
  final String? image; // URL to the profile image
  final String? phone;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  Profile({
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
      image: json['image'], // Assumes the JSON has an 'image' field
      phone: json['phone'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipcode'],
      country: json['country'],
    );
  }
}
