class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final String category;
  final String brand;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.category,
    required this.brand,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
      category: json['category'],
      brand: json['brand'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'category': category,
      'brand': brand,
      'stock': stock,
    };
  }
}