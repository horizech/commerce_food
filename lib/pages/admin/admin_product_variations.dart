import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/date_time_picker.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/gallery_dropdown.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AdminProductVariations extends StatefulWidget {
  final Product currentProduct;
  const AdminProductVariations({
    Key? key,
    required this.currentProduct,
  }) : super(key: key);

  @override
  State<AdminProductVariations> createState() => _AdminProductVariationsState();
}

class _AdminProductVariationsState extends State<AdminProductVariations> {
  User? user;
  List<Attribute> attributes = [];
  List<AttributeValue> attributeValues = [];
  List<ProductVariation> productVariations = [];
  List<ProductAttribute> productAttributes = [];
  int totalLen = 0;
  @override
  void initState() {
    super.initState();
    getProductAttribute();
  }

  getProductAttribute() async {
    productAttributes =
        await AddEditProductService.getProductAttributes() ?? [];
    if (productAttributes.isNotEmpty) {
      productAttributes = productAttributes
          .where((element) => element.product == widget.currentProduct.id)
          .toList();

      getProductVariations();
    }
  }

  getProductVariations() async {
    productVariations =
        await AddEditProductService.getProductVariationByProductId(
            widget.currentProduct.id!);
    if (productVariations.isNotEmpty) {}
    setState(() {});
  }

  // _addEditProductVariationsDialog(ProductVariation? productVariation) {
  //   if (selectedCollection != null && selectedProduct != null) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AddEditProductVariationDialog(
  //           currentCollection: selectedCollection!,
  //           currentProduct: selectedProduct!,
  //           currentProductVariation: productVariation,
  //         );
  //       },
  //     ).then((result) async {
  //       if (result == "success") {
  //         setState(() {});
  //       }
  //     });
  //   }
  // }

  // _deleteProduct(int productVariationId) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return const DeleteDialog();
  //     },
  //   ).then((result) async {
  //     if (result == "success") {
  //       APIResult? result = await AddEditProductService.deleteProductVariation(
  //           productVariationId);
  //       if (result != null && result.success) {
  //         showUpToast(
  //           context: context,
  //           text: result.message ?? "",
  //         );
  //         setState(() {});
  //       } else {
  //         showUpToast(
  //           context: context,
  //           text: "An Error Occurred",
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return productAttributes.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SizedBox(
                child: BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (attributes.isEmpty) {
                  if (state.attributes != null &&
                      state.attributes!.isNotEmpty) {
                    attributes = state.attributes!.toList();
                  }
                }

                if (attributeValues.isEmpty) {
                  if (state.attributeValues != null &&
                      state.attributeValues!.isNotEmpty) {
                    attributeValues = state.attributeValues!.toList();
                  }
                }

                return widget.currentProduct.isVariedProduct
                    ? Column(
                        children: [
                          SizedBox(
                            width: 100,
                            child: UpButton(
                              onPressed: () {
                                totalLen++;
                                setState(() {});
                              },
                              text: "Add variation",
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 600,
                            child: ListView.builder(
                                itemCount: totalLen,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductVariationExpansion(
                                    attributeValues: attributeValues,
                                    attributes: attributes,
                                    product: widget.currentProduct.id!,
                                    productAttributes: productAttributes,
                                  );
                                }),
                          ),
                        ],
                      )
                    : const SizedBox();
              },
            )),
          )
        : const UpCircularProgress();
  }
}

class ProductVariationExpansion extends StatefulWidget {
  final int product;
  final List<ProductAttribute> productAttributes;
  final List<Attribute> attributes;
  final List<AttributeValue> attributeValues;

  const ProductVariationExpansion({
    Key? key,
    required this.product,
    required this.productAttributes,
    required this.attributeValues,
    required this.attributes,
  }) : super(key: key);

  @override
  State<ProductVariationExpansion> createState() =>
      _ProductVariationExpansionState();
}

class _ProductVariationExpansionState extends State<ProductVariationExpansion> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountStartController =
      TextEditingController();
  final TextEditingController _discountEndController = TextEditingController();
  int? gallery;
  _discountStartDate() async {
    DateTime date = await getPicker(context);
    setState(() {
      _discountStartController.text = date.toString();
    });
  }

  _discountEndDate() async {
    DateTime date = await getPicker(context);

    setState(() {
      _discountEndController.text = date.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpExpansionTile(
      titleWidget: Row(
        children: widget.productAttributes
            .where((element) => element.useForVariation)
            .map(
              (e) => Expanded(
                child: ProductVariationDropdown(
                  attributeValues: widget.attributeValues,
                  productAttribute: e,
                  attributes: widget.attributes,
                ),
              ),
            )
            .toList(),
      ),
      children: [
        // name
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
              controller: _nameController,
              label: "Name",
            ),
          ),
        ),
        // description
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
              controller: _descriptionController,
              label: "Description",
              maxLines: 4,
            ),
          ),
        ),
        // price
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
              keyboardType: TextInputType.number,
              controller: _priceController,
              label: "Price",
            ),
          ),
        ),
        // sku
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
              controller: _skuController,
              label: "Sku",
            ),
          ),
        ),
        // discount price
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
              controller: _discountPriceController,
              label: "Discound Price",
            ),
          ),
        ),
        // discount start date
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
                controller: _discountStartController,
                prefixIcon: const Icon(Icons.calendar_today),
                label: "Discound Start Date",
                onTap: () {
                  _discountStartDate();
                }),
          ),
        ),
        // discount end date
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: UpTextField(
                controller: _discountEndController,
                prefixIcon: const Icon(Icons.calendar_today),
                label: "Discound End Date",
                onTap: () {
                  _discountEndDate();
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: GalleryDropdown(
                gallery: gallery,
                onChange: (value) {
                  gallery = int.parse(value);
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: 100,
              child: UpButton(
                text: "Save",
                onPressed: () {},
              )),
        ),
      ],
    );
  }
}

class ProductVariationDropdown extends StatefulWidget {
  final List<Attribute> attributes;
  final ProductAttribute productAttribute;
  final List<AttributeValue> attributeValues;

  const ProductVariationDropdown(
      {Key? key,
      required this.attributeValues,
      required this.productAttribute,
      required this.attributes})
      : super(key: key);

  @override
  State<ProductVariationDropdown> createState() =>
      _ProductVariationDropdownState();
}

class _ProductVariationDropdownState extends State<ProductVariationDropdown> {
  List<UpLabelValuePair> dropdown = [];
  String currentSelected = "";

  @override
  void initState() {
    super.initState();
    if (widget.attributes.isNotEmpty && widget.attributeValues.isNotEmpty) {
      for (var v in widget.productAttribute.attributeValues) {
        dropdown.add(
          UpLabelValuePair(
              label: widget.attributeValues
                  .where((element) => element.id == v)
                  .first
                  .name,
              value:
                  "${widget.attributeValues.where((element) => element.id == v).first.id}"),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return dropdown.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: UpDropDown(
                value: currentSelected,
                itemList: dropdown,
                label: widget.attributes
                    .where((element) =>
                        element.id == widget.productAttribute.attribute)
                    .first
                    .name,
              ),
            ),
          )
        : const SizedBox();
  }
}
