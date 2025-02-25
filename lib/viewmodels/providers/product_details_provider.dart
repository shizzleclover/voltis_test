import 'package:flutter/material.dart';
import '../../models/product_detail_model.dart';

class ProductDetailsProvider with ChangeNotifier {
  final List<ProductDetails> _products = [
    ProductDetails(
      id: '1',
      name: 'Nike Air Max',
      description: 'Premium sports shoes',
      originalPrice: 199.99,
      currentPrice: 149.99,
      brand: 'Nike',
      category: 'Shoes',
      condition: 'New',
      images: [
        'lib/core/Images/demo.png',
      ],
      likes: 234,
      sellerId: 'seller123',
      isOnSale: true,
      discountPercentage: 25,
      size: 'US 10',
    ),
    
  ];

  List<ProductDetails> get products => _products;
  
  List<ProductDetails> filterProducts({
    String? category,
    String? brand,
    String? condition,
    bool? onSale,
  }) {
    return _products.where((product) {
      if (category != null && product.category != category) return false;
      if (brand != null && product.brand != brand) return false;
      if (condition != null && product.condition != condition) return false;
      if (onSale != null && product.isOnSale != onSale) return false;
      return true;
    }).toList();
  }
}
