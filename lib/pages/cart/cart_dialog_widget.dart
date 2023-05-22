import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/cart/cart_combo_variation_widget.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/cart/cart_requried_product_attributes_widget.dart';
import 'package:shop/widgets/cart/cart_varied_variations_widget.dart';
import 'package:shop/widgets/counter.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

// List<UpLabelValuePair> _items = [
//   UpLabelValuePair(label: "Remove it from my order", value: '1'),
//   UpLabelValuePair(label: "Cancel the entire order", value: '2'),
//   UpLabelValuePair(label: "Call me and confirm", value: '3'),
// ];

class CartDialogWidget extends StatefulWidget {
  final Combo? combo;
  final Function onChange;
  final List<Product>? products;
  const CartDialogWidget({
    super.key,
    required this.onChange,
    this.product,
    this.combo,
    this.products,
  });
  final Product? product;

  @override
  State<CartDialogWidget> createState() => _CartDialogWidgetState();
}

class _CartDialogWidgetState extends State<CartDialogWidget> {
  // List<UpRadioButtonItem> variationRadios = [];
  final TextEditingController _instructionsController = TextEditingController();
  List<Product>? addonsProducts;
  List<ProductVariation> productVariations = [];
  List<AddOn> addons = [];
  int quantity = 1;
  List<bool> addonCheckboxes = [];
  List<AttributeValue> attributeValues = [];
  List<ProductAttribute> productAttributes = [];
  List<ProductAttribute> variedProductAttributes = [];
  List<ProductAttribute> requriedProductAttributes = [];
  List<Attribute> attributes = [];
  Map<String, dynamic> selectedVarriedVariations = {};
  Map<String, dynamic> selectedProductAttributes = {};
  int? selectedProductVariationId;
  List<String> keys = [];
  List<CartItem> combosProducts = [];
  bool isFurtherRun = false;

  @override
  void initState() {
    super.initState();
    getProductVariationsByApi();
  }

  getProductVariationsByApi() async {
    productVariations = await ProductDetailService.getProductVariationsByIds(
            (widget.products != null && widget.products!.isNotEmpty
                ? widget.products!.map((e) => e.id!).toList()
                : [widget.product!.id!])) ??
        [];

    if (productVariations.isNotEmpty) {
      isFurtherRun = true;
      setState(() {});
    } else if (productAttributes
        .every((element) => element.useForVariation == false)) {
      isFurtherRun = true;
      setState(() {});
    }
  }

  String getAddonPrice(Product product) {
    String price = "";
    if (addons.any((element) => element.addOn == product.id) &&
        addons.where((element) => element.addOn == product.id!).first.price !=
            null) {
      price =
          "£${addons.where((element) => element.addOn == product.id!).first.price}";
    } else {
      price = "£${product.price}";
    }
    return price;
  }

  String getProductPrice() {
    String price = "";
    if (widget.combo != null) {
      price = "£${widget.combo!.price}";
    } else if (widget.product != null && widget.product!.price != null) {
      price = "£${widget.product!.price}";
    } else if (productVariations.isNotEmpty) {
      productVariations.sort(
        (a, b) => (a.price ?? 0).compareTo(b.price ?? 0),
      );
      price =
          "£${productVariations.first.price} - £${productVariations.last.price}";
    }
    return price;
  }

  Widget getProductVariationsView() {
    if (productVariations.isNotEmpty) {
      for (var variation in productVariations) {
        if (variation.options.isNotEmpty) {
          variation.options.forEach((key, value) {
            if (key.length == 1) {
              keys.add(key);
            }
          });
        }
      }
      keys = keys.toSet().toList();
    }
    return Column(
      children: [
        variedProductAttributes.isNotEmpty && productVariations.isNotEmpty
            ? Column(
                children: variedProductAttributes
                    .map((e) => CartVariedVariationsWidget(
                          keys: keys,
                          selectedvariation: selectedVarriedVariations,
                          attributeValues: attributeValues,
                          onChange: (map, key) {
                            if ((map as Map<String, dynamic>).isNotEmpty) {
                              (map).forEach((key, value) {
                                selectedVarriedVariations[key] = value;
                              });
                            }
                            selectedVarriedVariations;

                            setState(() {});
                          },
                          attributes: attributes,
                          currentProductAttribute: e,
                          productVariations: productVariations,
                        ))
                    .toList(),
              )
            : const SizedBox(),
        requriedProductAttributes.isNotEmpty
            ? Column(
                children: requriedProductAttributes
                    .map((e) => CarProductAttributesWidget(
                        currentProductAttribute: e,
                        onChange: (map) {
                          if ((map as Map<String, dynamic>).isNotEmpty) {
                            (map).forEach((key, value) {
                              selectedProductAttributes[key] = value;
                            });
                          }
                        }))
                    .toList(),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget getComboVariationView() {
    return Column(
      children: [
        ...widget.products!
            .map((e) => CombosVariationWidget(
                  product: e,
                  attributeValues: attributeValues,
                  attributes: attributes,
                  productAttributes: productAttributes,
                  productVariations: productVariations,
                  requiredProductAttributes: requriedProductAttributes,
                  variedProductAttributes: variedProductAttributes,
                  combo: widget.combo!,
                  onChange: (CartItem item) {
                    if (combosProducts.any(
                        (element) => element.product!.id == item.product!.id)) {
                      combosProducts.removeWhere(
                          (c) => c.product!.id == item.product!.id);
                    }
                    combosProducts.add(item);
                  },
                ))
            .toList(),
      ],
    );
  }

  Widget _getDialogView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 600,
          height: 350,
          child: MediaWidget(
            mediaId: widget.combo != null && widget.combo!.thumbnail != null
                ? widget.combo!.thumbnail
                : widget.product != null
                    ? widget.product!.thumbnail
                    : 1,
            height: 350,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.combo != null
                    ? widget.combo!.name
                    : (widget.product != null ? widget.product!.name : ""),
              ),
              Text(getProductPrice())
            ],
          ),
        ),
        const Divider(),
        // in case of single product
        productAttributes.isNotEmpty && widget.product != null
            ? getProductVariationsView()
            : const SizedBox(),

        // in case of combo
        productAttributes.isNotEmpty &&
                widget.products != null &&
                widget.products!.isNotEmpty
            ? getComboVariationView()
            : const SizedBox(),
        // addon
        addonsProducts != null &&
                addonsProducts!.isNotEmpty &&
                addonCheckboxes.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const UpText("Addons", type: UpTextType.heading5),
                        UpText(
                          "Optional",
                          style: UpStyle(
                              textColor:
                                  UpConfig.of(context).theme.primaryColor[200]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: addonsProducts!
                          .asMap()
                          .entries
                          .map(
                            (addon) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                UpCheckbox(
                                  label: addon.value.name,
                                  initialValue: addonCheckboxes[addon.key],
                                  onChange: (newCheck) {
                                    addonCheckboxes[addon.key] = newCheck;
                                  },
                                ),
                                UpText(getAddonPrice(addon.value)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UpText("Special instructions", type: UpTextType.heading5),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 2, top: 4),
                child: UpText(
                  "Any specific preferences? Let the restaurant know.",
                  style: UpStyle(
                      textColor: const Color.fromARGB(255, 80, 79, 79),
                      textSize: 12),
                ),
              ),
              UpTextField(
                controller: _instructionsController,
                hint: "e.g. No mayo",
                maxLines: 3,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
              visible: productAttributes.isNotEmpty &&
                  productAttributes.any((element) => element.useForVariation) &&
                  selectedVarriedVariations.isNotEmpty &&
                  keys.isNotEmpty &&
                  productVariations.isNotEmpty &&
                  selectedVarriedVariations.keys.length == keys.length &&
                  (!productVariations.any(
                    (element) =>
                        mapEquals(element.options, selectedVarriedVariations),
                  )),
              child: const UpText("*Invalid Variation Selected")),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Counter(
                    defaultValue: quantity,
                    onChange: (q) {
                      quantity = q;

                      setState(() {});
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 100,
                      child: UpButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 100,
                      child: UpButton(
                          text: "Add to cart",
                          onPressed: () {
                            CartCubit cubit = context.read<CartCubit>();

                            //add on products add to cart
                            if (addonCheckboxes
                                .any((element) => element == true)) {
                              for (var c in addonCheckboxes.asMap().entries) {
                                if (addonCheckboxes[c.key] == true) {
                                  CartItem item = CartItem(
                                    type: "Product",
                                    product: addonsProducts!
                                        .asMap()
                                        .entries
                                        .where(
                                            (element) => element.key == c.key)
                                        .first
                                        .value,
                                    quantity: 1,
                                  );
                                  cubit.addToCart(item);
                                }
                              }
                            }

                            //product add to cart
                            if (selectedVarriedVariations.isNotEmpty &&
                                widget.product != null &&
                                selectedVarriedVariations.length ==
                                    keys.length &&
                                productAttributes.any(
                                    (element) => element.useForVariation)) {
                              if (productVariations.any(
                                (element) => mapEquals(
                                    element.options, selectedVarriedVariations),
                              )) {
                                selectedProductVariationId = productVariations
                                    .where(
                                      (element) => mapEquals(element.options,
                                          selectedVarriedVariations),
                                    )
                                    .first
                                    .id!;
                              }

                              if (selectedProductVariationId != null) {
                                ProductVariation selectedVariation =
                                    productVariations
                                        .where((element) =>
                                            element.id ==
                                            selectedProductVariationId!)
                                        .first;
                                CartItem item = CartItem(
                                  product: widget.product!,
                                  selectedVariation: selectedVariation,
                                  quantity: quantity,
                                  type: "Product",
                                  selectedProductAttributes:
                                      selectedProductAttributes,
                                  instructions: _instructionsController.text,
                                );
                                cubit.addToCart(item);
                                Navigator.pop(context, "Success");
                              }
                            } else if (widget.product != null &&
                                productAttributes.every((element) =>
                                    element.useForVariation == false)) {
                              CartItem item = CartItem(
                                product: widget.product!,
                                selectedVariation: null,
                                quantity: quantity,
                                type: "Product",
                                selectedProductAttributes:
                                    selectedProductAttributes,
                                instructions: _instructionsController.text,
                              );
                              cubit.addToCart(item);
                              Navigator.pop(context, "Success");
                            } else if (widget.combo != null) {
                              List<CartItem> notVariedProducts = [];
                              // products without any variations
                              if (widget.products != null &&
                                  widget.products!.isNotEmpty &&
                                  combosProducts.length !=
                                      widget.products!.length) {
                                for (var p in widget.products!) {
                                  if (combosProducts
                                      .every((cp) => cp.product!.id != p.id)) {
                                    notVariedProducts.add(CartItem(
                                      quantity: 1,
                                      type: "Product",
                                      product: p,
                                    ));
                                  }
                                }
                              }

                              // products with variations
                              if (notVariedProducts.isNotEmpty) {
                                for (var element in notVariedProducts) {
                                  combosProducts.add(element);
                                }
                              }
                              CartItem comboItem = CartItem(
                                quantity: quantity,
                                combo: widget.combo,
                                comboItems: combosProducts,
                                instructions: _instructionsController.text,
                              );

                              cubit.addToCart(comboItem);
                              Navigator.pop(context, "Success");
                            } else {
                              UpToast().showToast(
                                  context: context,
                                  text: "Select All Variations");
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  getAddOnProductsApiCall(List<int> addonProductIds) async {
    addonsProducts =
        await AddEditProductService.getProductByIds(addonProductIds) ?? [];
    if (addonsProducts != null && addonsProducts!.isNotEmpty) {
      for (var addonP in addonsProducts!) {
        addonCheckboxes.add(false);
      }
      setState(() {});
    } else {
      addonsProducts = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (attributeValues.isEmpty) {
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            attributeValues = state.attributeValues!.toList();
          }
        }
        if (productAttributes.isEmpty) {
          if (state.productAttributes != null &&
              state.productAttributes!.isNotEmpty) {
            if (widget.product != null) {
              productAttributes = state.productAttributes!
                  .where((element) => element.product == widget.product!.id)
                  .toList();
            } else if (widget.products != null && widget.products!.isNotEmpty) {
              for (var p in widget.products!) {
                if (state.productAttributes!
                    .any((element) => element.product == p.id)) {
                  productAttributes.add(state.productAttributes!
                      .where((element) => element.product == p.id)
                      .first);
                }
              }
            }
          }
        }
        if (variedProductAttributes.isEmpty) {
          if (productAttributes.isNotEmpty) {
            variedProductAttributes = productAttributes
                .where((element) => element.useForVariation == true)
                .toList();
          }
          variedProductAttributes;
        }
        if (requriedProductAttributes.isEmpty) {
          if (productAttributes.isNotEmpty) {
            requriedProductAttributes = productAttributes
                .where((element) => element.useForVariation == false)
                .toList();
          }
          requriedProductAttributes;
        }
        if (attributes.isEmpty) {
          if (state.attributes != null && state.attributes!.isNotEmpty) {
            attributes = state.attributes!.toList();
          }
        }
        if (state.addOns != null &&
            state.addOns!.isNotEmpty &&
            addonsProducts == null) {
          List<int> addonProductIds = [];
          if (widget.product != null) {
            addons = state.addOns!
                .where((element) => element.product == widget.product!.id!)
                .toList();
            addonProductIds = state.addOns!
                .where((element) => element.product == widget.product!.id!)
                .map((e) => e.addOn)
                .toList();
          } else {
            if (widget.products != null && widget.products!.isNotEmpty) {
              for (var p in widget.products!) {
                List<int> ids = [];
                ids = state.addOns!
                    .where((element) => element.product == p.id)
                    .map((e) => e.addOn)
                    .toList();
                for (var id in ids) {
                  addonProductIds.add(id);
                }
              }
            }
          }
          getAddOnProductsApiCall(addonProductIds);
        }

        return ((widget.product != null && widget.product!.isVariedProduct) ||
                (widget.products != null &&
                        widget.products!
                            .any((element) => element.isVariedProduct)) &&
                    isFurtherRun)
            ? SizedBox(
                child: _getDialogView(),
              )
            : ((widget.product != null &&
                        widget.product!.isVariedProduct == false) ||
                    (widget.products != null &&
                        widget.products!.every(
                            (element) => element.isVariedProduct == false)))
                ? SizedBox(
                    child: _getDialogView(),
                  )
                : const SizedBox(
                    width: 600,
                    height: 600,
                    child: UpCircularProgress(),
                  );
      },
    );
  }
}
