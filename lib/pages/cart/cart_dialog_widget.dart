import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/direction.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/counter.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

List<UpLabelValuePair> _items = [
  UpLabelValuePair(label: "Remove it from my order", value: '1'),
  UpLabelValuePair(label: "Cancel the entire order", value: '2'),
  UpLabelValuePair(label: "Call me and confirm", value: '3'),
];

class CartDialogWidget extends StatefulWidget {
  final Function onChange;
  const CartDialogWidget(
      {super.key, required this.onChange, required this.product});
  final Product product;

  @override
  State<CartDialogWidget> createState() => _CartDialogWidgetState();
}

class _CartDialogWidgetState extends State<CartDialogWidget> {
  @override
  String currentSelection = _items.first.value;
  List<UpRadioButtonItem> variationRadios = [];
  final TextEditingController _instructionsController = TextEditingController();
  List<Product>? addonsProducts;
  List<Widget> variationWidgets = [];
  List<ProductVariation> productVariations = [];
  List<AddOn> addons = [];
  int? selectedVariationId;
  ProductVariation? selectedVariation;

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    getProductVariationsByApi();
  }

  getProductVariationsByApi() async {
    productVariations = await ProductDetailService.getProductVariationsById(
            widget.product.id!) ??
        [];
    if (productVariations.isNotEmpty) {
      initalizeRadios();
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

  // setVariationWidget() {
  //   variationWidgets = [];
  //   for (int i = 0; i < quantity; i++) {
  //     variationWidgets.add(variationWidget(i + 1));
  //   }
  // }

  // Widget variationWidget(int index) {
  //   return

  // }

  initalizeRadios() {
    if (productVariations.isNotEmpty) {
      variationRadios = productVariations
          .map(
            (el) => UpRadioButtonItem(
              value: el.id,
              widget: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 12.0, right: 8.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UpText(el.name ?? ''),
                    UpText("£${el.price}"),
                  ],
                ),
              ),
            ),
          )
          .toList();
    }
    selectedVariationId = variationRadios.first.value;
  }

  Widget _getProductVariations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 600,
          height: 350,
          child: MediaWidget(
            mediaId: widget.product.thumbnail,
            height: 350,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.product.name),
              Text("£${widget.product.price}")
            ],
          ),
        ),

        const Divider(),
        productVariations.isNotEmpty && variationRadios.isNotEmpty
            ? Visibility(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const UpText("Select variation",
                              type: UpTextType.heading5),
                          UpText(
                            "1 Required",
                            style: UpStyle(
                                textColor: UpConfig.of(context)
                                    .theme
                                    .primaryColor[200]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UpRadioButton(
                        items: variationRadios,
                        labelDirection: UpTextDirection.right,
                        direction: UpDirection.vertical,
                        onChange: (radiovalue) {
                          selectedVariationId = radiovalue;

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              )
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
                    child: UpRadioButton(
                      initialValue: false,
                      items: addonsProducts!
                          .map(
                            (addon) => UpRadioButtonItem(
                              value: addon.id,
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UpText(addon.name),
                                    UpText(getAddonPrice(addon)),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      labelDirection: UpTextDirection.right,
                      direction: UpDirection.vertical,
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
              // const UpText("If this product is not available",
              //     type: UpTextType.heading5),
              // const SizedBox(height: 4),
              // UpDropDown(
              //   label: '',
              //   value: currentSelection,
              //   itemList: _items,
              //   onChanged: (value) => _onChange(value),
              // ),
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

                          if (productVariations.isNotEmpty) {
                            if (selectedVariationId != null) {
                              selectedVariation = productVariations
                                  .where((element) =>
                                      element.id == selectedVariationId!)
                                  .first;
                              CartItem item = CartItem(
                                product: widget.product,
                                selectedVariation: selectedVariation,
                                quantity: quantity,
                                instructions: _instructionsController.text,
                              );
                              item;

                              cubit.addToCart(item);
                              Navigator.pop(context, "Success");
                            }
                          } else {
                            CartItem item = CartItem(
                              product: widget.product,
                              selectedVariation: selectedVariation,
                              quantity: quantity,
                              instructions: _instructionsController.text,
                            );
                            cubit.addToCart(item);
                            Navigator.pop(context, "Success");
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
          if (state.addOns != null &&
              state.addOns!.isNotEmpty &&
              addonsProducts == null) {
            List<int> addonProductIds = [];
            addons = state.addOns!
                .where((element) => element.product == widget.product.id!)
                .toList();
            addonProductIds = state.addOns!
                .where((element) => element.product == widget.product.id!)
                .map((e) => e.addOn)
                .toList();

            getAddOnProductsApiCall(addonProductIds);
          }
          return widget.product.isVariedProduct && productVariations.isNotEmpty
              ? SizedBox(
                  child: _getProductVariations(),
                )
              : widget.product.isVariedProduct == false
                  ? SizedBox(
                      child: _getProductVariations(),
                    )
                  : const SizedBox(
                      width: 600,
                      height: 600,
                      child: UpCircularProgress(),
                    );
        });
  }
}
