import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/widgets/cart/cart_requried_product_attributes_widget.dart';
import 'package:shop/widgets/cart/cart_varied_variations_widget.dart';

class CombosVariationWidget extends StatefulWidget {
  final Product product;
  final Function onChange;
  final List<ProductVariation> productVariations;
  final List<ProductAttribute> productAttributes;
  final List<ProductAttribute> variedProductAttributes;
  final List<ProductAttribute> requiredProductAttributes;
  final List<Attribute> attributes;
  final List<AttributeValue> attributeValues;
  final Combo combo;

  const CombosVariationWidget({
    Key? key,
    required this.combo,
    required this.product,
    required this.attributeValues,
    required this.attributes,
    required this.onChange,
    required this.productAttributes,
    required this.productVariations,
    required this.requiredProductAttributes,
    required this.variedProductAttributes,
  }) : super(key: key);

  @override
  State<CombosVariationWidget> createState() => _CombosVariationWidgetState();
}

class _CombosVariationWidgetState extends State<CombosVariationWidget> {
  Map<String, dynamic> selectedVarriedVariations = {};
  Map<String, dynamic> selectedProductAttributes = {};
  List<String> keys = [];
  CartItem? cartItem;
  createItem() {
    int len = widget.requiredProductAttributes
        .where((element) => element.product == widget.product.id)
        .length;
    if (len == selectedProductAttributes.length) {
      ProductVariation? selectedProductVariation;
      if (widget.productAttributes.any((element) => element.useForVariation)) {
        if (widget.productVariations.any(
          (element) => mapEquals(element.options, selectedVarriedVariations),
        )) {
          selectedProductVariation = widget.productVariations
              .where(
                (element) =>
                    mapEquals(element.options, selectedVarriedVariations),
              )
              .first;
        }
      }
      CartItem cartItem = CartItem(
        quantity: 1,
        product: widget.product,
        selectedProductAttributes: selectedProductAttributes,
        selectedVariation: selectedProductVariation,
        combo: widget.combo,
      );
      widget.onChange(cartItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productVariations.isNotEmpty) {
      for (var variation in widget.productVariations
          .where((element) => element.id == widget.product.id)) {
        if (variation.options.isNotEmpty) {
          variation.options.forEach((key, value) {
            if (keys.length == 1) {
              keys.add(key);
            }
          });
        }
      }
      keys = keys.toSet().toList();
    }
    return Column(
      children: [
        widget.variedProductAttributes.isNotEmpty &&
                widget.productVariations.isNotEmpty
            ? Column(
                children: widget.variedProductAttributes
                    .where((element) => element.product == widget.product.id)
                    .map((e) => CartVariedVariationsWidget(
                          keys: keys,
                          selectedvariation: selectedVarriedVariations,
                          attributeValues: widget.attributeValues,
                          onChange: (map, key) {
                            selectedVarriedVariations[key] = map[key];
                            createItem();
                          },
                          attributes: widget.attributes,
                          currentProductAttribute: e,
                          productVariations: widget.productVariations,
                        ))
                    .toList(),
              )
            : const SizedBox(),
        widget.requiredProductAttributes.isNotEmpty
            ? Column(
                children: widget.requiredProductAttributes
                    .where((element) => element.product == widget.product.id)
                    .map((e) => CarProductAttributesWidget(
                        currentProductAttribute: e,
                        onChange: (map) {
                          if ((map as Map<String, dynamic>).isNotEmpty) {
                            (map).forEach((key, value) {
                              selectedProductAttributes[key] = value;
                            });
                          }
                          selectedProductAttributes;
                          createItem();
                        }))
                    .toList(),
              )
            : const SizedBox(),
      ],
    );
  }
}
