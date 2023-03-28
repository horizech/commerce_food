import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';

class CartItem extends Equatable {
  Product? product;
  ProductVariation? selectedVariation;
  Map<String, int>? selectedProductAttributes;
  Combo? combo;
  String type;
  int quantity;
  String? instructions;
  List<CartItem>? comboItems;

  CartItem({
    this.product,
    this.selectedVariation,
    this.combo,
    required this.quantity,
    this.instructions,
    this.type = "product",
    this.selectedProductAttributes,
    this.comboItems,
  });

  Map<String, dynamic> toJson() {
    try {
      Map<String, dynamic> item = {
        'Product': product != null ? Product.toJson(product!) : null,
        'Variations': selectedVariation != null
            ? ProductVariation.toJson(selectedVariation!)
            : null,
        'Combo': combo != null ? Combo.toJson(combo!) : null,
        'Quantity': '$quantity',
        'Instructions': '$instructions',
        'Type': type,
        "SelectedProductAttributes": selectedProductAttributes,
        "ComboItems": comboItems,
      };
      return item;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  factory CartItem.fromJson(Map<String, dynamic> instance) {
    try {
      instance['ComboItems'];
      CartItem item = CartItem(
        product: instance['Product'] != null
            ? Product.fromJson(instance['Product'] as Map<String, dynamic>)
            : null,
        selectedVariation: instance['Variations'] != null
            ? ProductVariation.fromJson(
                instance['Variations'] as Map<String, dynamic>)
            : null,
        combo: instance['Combo'] != null
            ? Combo.fromJson(instance['Combo'] as Map<String, dynamic>)
            : null,
        type: instance['Type'] as String,
        quantity: int.parse(instance['Quantity'] as String),
        instructions: instance['Instructions'] as String?,
        comboItems: (instance['ComboItems'] != null
            ? (instance['ComboItems'] as List<CartItem>?)
            : null),
        selectedProductAttributes:
            instance["SelectedProductAttributes"] as Map<String, int>?,
      );
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
