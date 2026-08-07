/// Produto do catálogo da loja.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageAsset;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageAsset,
    this.isFeatured = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageAsset': imageAsset,
        'isFeatured': isFeatured,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        category: json['category'] as String,
        imageAsset: json['imageAsset'] as String,
        isFeatured: json['isFeatured'] as bool? ?? false,
      );
}
