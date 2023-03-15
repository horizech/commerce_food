import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';

class CartItem extends Equatable {
  Product product;
  ProductVariation? selectedVariation;
  int quantity;
  String? instructions;

  CartItem({
    required this.product,
    this.selectedVariation,
    required this.quantity,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    try {
      Map<String, dynamic> newVariations = {};
      // for (var entry in selectedVariationsValues.entries) {
      //   newVariations['${entry.key}'] = entry.value;
      // }

      Map<String, dynamic> item = {
        'Product': Product.toJson(product),
        'Variations': selectedVariation != null
            ? ProductVariation.toJson(selectedVariation!)
            : null,
        'Quantity': '$quantity',
        'Instructions': '$instructions'
      };
      return item;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  factory CartItem.fromJson(Map<String, dynamic> instance) {
    try {
      CartItem item = CartItem(
          product:
              Product.fromJson(instance['Product'] as Map<String, dynamic>),
          selectedVariation: ProductVariation.fromJson(instance['Variations']),
          quantity: int.parse(instance['Quantity'] as String),
          instructions: instance['Instructions'] as String?);
      return item;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static bool areVariationsEqual(Map<int, dynamic> a, Map<int, dynamic> b) {
    bool result = true;

    List<int> aKeys = a.keys.toList();
    List<int> bKeys = b.keys.toList();
    if (aKeys.length != bKeys.length) {
      result = false;
    }

    for (var i in aKeys) {
      if (!b.keys.contains(i)) {
        result = false;
      } else if (a[i] != b[i]) {
        result = false;
      }
    }

    return result;
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
