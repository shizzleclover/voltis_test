class ProductDetails {
  final String id;
  final String name;
  final String description;
  final double originalPrice;
  final double currentPrice;
  final String brand;
  final String category;
  final String condition;
  final List<String> images;
  final int likes;
  final String sellerId;
  final bool isOnSale;
  final int discountPercentage;
  final String size;

  ProductDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.currentPrice,
    required this.brand,
    required this.category,
    required this.condition,
    required this.images,
    required this.likes,
    required this.sellerId,
    required this.isOnSale,
    required this.discountPercentage,
    required this.size,
  });
}
