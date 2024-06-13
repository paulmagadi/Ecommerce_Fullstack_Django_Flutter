
class Banner {
  final int id;
  final String name;
  final String description;


  Banner({
    required this.id,
    required this.name,
    required this.description,
    
  });



    return Banner(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      
     
    );
  }
}