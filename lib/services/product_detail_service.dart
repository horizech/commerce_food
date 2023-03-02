import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_detail.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/models/stock.dart';

class ProductDetailService {
  static Future<ProductDetail?> getProductDetail(int productId) async {
    List<QuerySearchItem> variationConditions = [],
        productConditions = [],
        stockConditions = [];
    List<ProductVariation>? productVariations;
    List<Stock>? stock;

    Product? product;
    variationConditions = [
      QuerySearchItem(
        name: "Product",
        condition: ColumnCondition.equal,
        value: productId,
      )
    ];
    productConditions = [
      QuerySearchItem(
        name: "Id",
        condition: ColumnCondition.equal,
        value: productId,
      )
    ];
    stockConditions = [
      QuerySearchItem(
        name: "Product",
        condition: ColumnCondition.equal,
        value: productId,
      )
    ];

    // APIResult productVariationResult =
    //     await Apiraiser.data.getByConditions("ProductVariations", conditions);

    dynamic futureResult = await Future.wait([
      Apiraiser.data.getByConditions("Products", productConditions),
      Apiraiser.data.getByConditions("ProductVariations", variationConditions),
      Apiraiser.data.getByConditions("ProductStock", stockConditions),
    ]);

    List<APIResult> result = futureResult as List<APIResult>;
    if (result.any((element) => !element.success)) {
      return null;
    } else {
      try {
        if ((result[0].data as List<dynamic>).isNotEmpty &&
            result[0].data != null) {
          if (result[1].data != null &&
              (result[1].data as List<dynamic>).isNotEmpty) {
            productVariations = (result[1].data as List<dynamic>)
                .map(
                    (k) => ProductVariation.fromJson(k as Map<String, dynamic>))
                .toList();
          }
          if (result[2].data != null &&
              (result[2].data as List<dynamic>).isNotEmpty) {
            stock = (result[2].data as List<dynamic>)
                .map((k) => Stock.fromJson(k as Map<String, dynamic>))
                .toList();
          }

          product = (result[0].data as List<dynamic>)
              .map((k) => Product.fromJson(k as Map<String, dynamic>))
              .first;

          return ProductDetail(
            product: product,
            productVariations: productVariations,
            stock: stock,
          );
        } else {
          return null;
        }
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }
  }

  static Future<Product?> getProductById(int productId) async {
    List<QuerySearchItem> productConditions = [];

    Product? product;

    productConditions = [
      QuerySearchItem(
        name: "Id",
        condition: ColumnCondition.equal,
        value: productId,
      )
    ];
    try {
      APIResult result =
          await Apiraiser.data.getByConditions("Products", productConditions);

      if (result.success &&
          result.data != null &&
          (result.data as List<dynamic>).isNotEmpty) {
        product = (result.data as List<dynamic>)
            .map((k) => Product.fromJson(k as Map<String, dynamic>))
            .first;

        return product;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return null;
  }
}
