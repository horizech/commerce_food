import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';

class CartItem extends Equatable {
  Product product;
  Map<int, int> selectedVariationsValues;
  int quantity;

  CartItem(
      {required this.product,
      required this.selectedVariationsValues,
      required this.quantity});

  Map<String, dynamic> toJson() {
    try {
      Map<String, dynamic> newVariations = {};
      for (var entry in selectedVariationsValues.entries) {
        newVariations['${entry.key}'] = entry.value;
      }

      Map<String, dynamic> item = {
        'Product': Product.toJson(product),
        'Variations': newVariations,
        'Quantity': '$quantity'
      };
      return item;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  factory CartItem.fromJson(Map<String, dynamic> instance) {
    try {
      Map<int, int> newVariations = {};
      for (var entry
          in (instance['Variations'] as Map<String, dynamic>).entries) {
        newVariations[int.parse(entry.key)] = entry.value;
      }

      CartItem item = CartItem(
          product:
              Product.fromJson(instance['Product'] as Map<String, dynamic>),
          selectedVariationsValues: newVariations,
          quantity: int.parse(instance['Quantity'] as String));
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
