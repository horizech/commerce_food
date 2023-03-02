import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/models/stock.dart';

class ProductDetail {
  final Product? product;
  final List<ProductVariation>? productVariations;
  final List<Stock>? stock;

  ProductDetail({
    this.product,
    this.productVariations,
    this.stock,
  });
}
