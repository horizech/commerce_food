import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/direction.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
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
  int? selectedVariationId;
  ProductVariation? selectedVariation;
  int quantity = 1;
  List<bool> addonCheckboxes = [];
  List<AttributeValue> attributeValues = [];
  List<Attribute> attributes = [];

  Map<String, int> selectedProductVariations = {};
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
      setState(() {});
    }
  }

  String getAddonPrice(Product product) {
    String price = "";
    if (addons.where((element) => element.addOn == product.id!).first.price !=
        null) {
      price =
          "£${addons.where((element) => element.addOn == product.id!).first.price}";
    } else {
      price = "£${product.price}";
    }
    return price;
  }

  Widget getProductVariationsView() {
    // keys
    List<String> keys = [];
    for (var variation in productVariations) {
      if (variation.options.isNotEmpty) {
        variation.options.forEach((key, value) {
          keys.add(key);
        });
      }
    }
    keys = keys.toSet().toList();

    // Values
    Map<String, List<int>> keyValues = {};
    for (var key in keys) {
      keyValues[key] = [];
    }
    for (var variation in productVariations) {
      if (variation.options.isNotEmpty) {
        variation.options.forEach((key, value) {
          if (keyValues[key] != null) {
            keyValues[key]!.add(value);
          }
        });
      }
    }

    keyValues.forEach((key, value) {
      keyValues[key] = value.toSet().toList();
    });

    for (var key in keys) {
      selectedProductVariations['key'] = 0;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...keys
            .map(
              (key) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UpText("Select $key", type: UpTextType.heading5),
                        UpText(
                          "1 Required",
                          style: UpStyle(
                              textColor:
                                  UpConfig.of(context).theme.primaryColor[200]),
                        ),
                      ],
                    ),
                  ),
                  keyValues[key] != null && keyValues[key]!.length > 1
                      ? productRadioButton(key, keyValues)
                      : const SizedBox()
                ],
              ),
            )
            .toList()
      ],
    );
  }

  Widget productRadioButton(String key, Map<String, List> keyValues) {
    List<UpRadioButtonItem> radioButtonValues = [];

    for (var keyV in keyValues[key]!) {
      radioButtonValues.add(UpRadioButtonItem(
        value: keyV,
        isDisabled: selectedProductVariations[key] == 0 &&
                selectedProductVariations.values.any((element) => element > 0)
            ? true
            : false,
        widget: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 12.0,
            right: 8.0,
            bottom: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UpText(
                attributeValues
                    .where((element) => element.id == keyV)
                    .first
                    .name,
              ),
            ],
          ),
        ),
      ));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: UpRadioButton(
            initialValue: false,
            items: radioButtonValues,
            labelDirection: UpTextDirection.right,
            direction: UpDirection.vertical,
            onChange: (radiovalue) {
              // selectedVariationId = radiovalue;
              selectedProductVariations[key] = radiovalue;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget getComboVariationView() {
    return Column(
      children: [
        ...widget.products!
            .map((e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UpText("Select ${e.name} variation",
                              type: UpTextType.heading5),
                          UpText(
                            "1 Required",
                            style: UpStyle(
                              textColor:
                                  UpConfig.of(context).theme.primaryColor[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                    getVariationRadioButton(e.id!)
                  ],
                ))
            .toList(),
      ],
    );
  }

  Widget getVariationRadioButton(int product) {
    List<ProductVariation> productBasedVariations = productVariations
        .where((element) => element.product == product)
        .toList();
    if (widget.combo != null &&
        widget.combo!.fixedVariations != null &&
        widget.combo!.fixedVariations!.isNotEmpty &&
        widget.combo!.fixedVariations!['$product'] != null &&
        productBasedVariations.isNotEmpty &&
        productBasedVariations.any((element) => false)) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: productVariations.any((element) => element.product == product)
            ? UpRadioButton(
                items: productVariations
                    .where((variation) => variation.product == product)
                    .map((e) => UpRadioButtonItem(
                          value: e.id,
                          widget: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 12.0, right: 8.0, bottom: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UpText(e.name ?? ''),
                                UpText("£${e.price}"),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                labelDirection: UpTextDirection.right,
                direction: UpDirection.vertical,
                onChange: (radiovalue) {
                  selectedVariationId = radiovalue;

                  setState(() {});
                },
              )
            : const SizedBox(),
      );
    }
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
            mediaId: widget.combo != null
                ? widget.combo!.thumbnail
                : widget.product!.thumbnail,
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
                    : widget.product!.name,
              ),
              Text(
                  "£${widget.combo != null ? widget.combo!.price : widget.product!.price}")
            ],
          ),
        ),

        const Divider(),

        // in case of single product
        productVariations.isNotEmpty && widget.product != null
            ? getProductVariationsView()
            : const SizedBox(),

        // in case of combo

        productVariations.isNotEmpty &&
                widget.products != null &&
                widget.products!.isNotEmpty
            ? getComboVariationView()
            : const SizedBox(),
        // addon
        addonsProducts != null && addonsProducts!.isNotEmpty
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
                                  product: addonsProducts!
                                      .asMap()
                                      .entries
                                      .where((element) => element.key == c.key)
                                      .first
                                      .value,
                                  quantity: 1,
                                );
                                cubit.addToCart(item);
                              }
                            }
                          }

                          //product add to cart
                          if (productVariations.isNotEmpty &&
                              widget.product != null) {
                            if (selectedVariationId != null) {
                              selectedVariation = productVariations
                                  .where((element) =>
                                      element.id == selectedVariationId!)
                                  .first;
                              CartItem item = CartItem(
                                product: widget.product!,
                                selectedVariation: selectedVariation,
                                quantity: quantity,
                                instructions: _instructionsController.text,
                              );
                              cubit.addToCart(item);
                              Navigator.pop(context, "Success");
                            }
                          } else if (widget.product != null) {
                            CartItem item = CartItem(
                              product: widget.product!,
                              selectedVariation: selectedVariation,
                              quantity: quantity,
                              instructions: _instructionsController.text,
                            );
                            cubit.addToCart(item);
                            Navigator.pop(context, "Success");
                          }

                          //combo add to cart
                          if (productVariations.isNotEmpty &&
                              widget.products != null) {
                            if (selectedVariationId != null) {
                              selectedVariation = productVariations
                                  .where((element) =>
                                      element.id == selectedVariationId!)
                                  .first;
                              CartItem item = CartItem(
                                product: widget.product!,
                                selectedVariation: selectedVariation,
                                quantity: quantity,
                                instructions: _instructionsController.text,
                              );
                              cubit.addToCart(item);
                              Navigator.pop(context, "Success");
                            }
                          }
                        },
                      ),
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
        return (widget.product != null && widget.product!.isVariedProduct) ||
                (widget.products != null &&
                        widget.products!
                            .any((element) => element.isVariedProduct)) &&
                    productVariations.isNotEmpty
            ? SizedBox(
                child: _getDialogView(),
              )
            : (widget.product != null &&
                        widget.product!.isVariedProduct == false) ||
                    (widget.products != null &&
                        widget.products!.every(
                            (element) => element.isVariedProduct == false))
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
