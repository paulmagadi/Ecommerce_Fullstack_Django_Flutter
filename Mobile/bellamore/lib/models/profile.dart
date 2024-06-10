class Profile {
    final String phone;
    final String address1;
    final String? address2;
    final String city;
    final String state;
    final String zipcode;
    final String country;

  Profile({
    required  this.phone,
    required  this.address1,
    this.address2,
    required  this.city,
    required  this.state,
    required  this.zipcode,
    required  this.country,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      phone : json['phone'],
      address1 : json['address1'],
      address2 : json['address2'],
      city : json['city'],
      state : json['state'],
      zipcode : json['zipcode'],
      country : json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'phone' : phone,
      'address1' : address1,
      'address2' : address2,
      'city' : city,
      'state' : state,
      'zipcode' : zipcode,
      'country' : country,
    };
  }
}