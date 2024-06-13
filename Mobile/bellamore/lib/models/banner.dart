
class MobileBanner {
  final String image;
  final String? caption;
  final DateTime createdAt;
  final bool inUse;

  MobileBanner({
    required this.image,
    this.caption,
    required this.createdAt,
    required this.inUse,
  });

  factory MobileBanner.fromJson(Map<String, dynamic> json) {
    return MobileBanner(
      image: json['image'],
      caption: json['caption'],
      createdAt: DateTime.parse(json['created_at']),
      inUse: json['in_use'],
    );
  }
}
