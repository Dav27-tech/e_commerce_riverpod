class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final double rating;
  final String category;
  final String brand;
  final int stock;
  final double discountPercentage;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
    required this.category,
    required this.brand,
    required this.stock,
    required this.discountPercentage,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      rating: (json['rating'] as num).toDouble(),
      category: json['category'],
      brand: json['brand'],
      stock: json['stock'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'rating': rating,
      'category': category,
      'brand': brand,
      'stock': stock,
      'discountPercentage': discountPercentage,
      'images': images,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? thumbnail,
    double? rating,
    String? category,
    String? brand,
    int? stock,
    double? discountPercentage,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price)';
  }
}
