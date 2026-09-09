class Product {
  final int id;
  final String title;
  final String? description;
  final double price;
  final String category;
  final String? imageUrl;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.category,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }
}