import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/date_time_picker.dart';
import 'package:shop/dialogs/delete_dialog.dart';
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
  int index = 0;
  List<int> createdVariations = [];
  @override
  void initState() {
    super.initState();
    _getProductAttribute();
  }

  _getProductAttribute() async {
    productAttributes =
        await AddEditProductService.getProductAttributes() ?? [];
    if (productAttributes.isNotEmpty) {
      productAttributes = productAttributes
          .where((element) => element.product == widget.currentProduct.id)
          .toList();

      _getProductVariations();
    }
  }

  _getProductVariations() async {
    productVariations =
        await AddEditProductService.getProductVariationByProductId(
            widget.currentProduct.id!);
    if (productVariations.isNotEmpty) {
      setState(() {});
    }
    setState(() {});
  }

  _deleteDialog(int productVariationId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) {
      if (result == "success") {
        _deleteProductVariations(productVariationId);
      }
    });
  }

  _deleteProductVariations(int productVariationId) async {
    APIResult? result =
        await AddEditProductService.deleteProductVariation(productVariationId);
    if (result != null && result.success) {
      showUpToast(
        context: context,
        text: result.message ?? "",
      );
      _getProductVariations();
    } else {
      if (result != null) {
        showUpToast(
          context: context,
          text: result.message ?? "",
        );
      }
    }
  }

  _addEditProductVariation(ProductVariation newVariation, int? value) async {
    APIResult? result = await AddEditProductService.addEditProductVariation(
      ProductVariation.toJson(newVariation),
      newVariation.id != null ? newVariation.id! : null,
    );

    if (result != null && result.success) {
      if (value != null) {
        createdVariations.removeWhere(
          (element) => element == value,
        );
      }
      showUpToast(
        context: context,
        text: result.message ?? "",
      );
      _getProductVariations();
    } else {
      showUpToast(
        context: context,
        text: "An error occurred",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return productAttributes.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SizedBox(
                width: 500,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: UpButton(
                                  onPressed: () {
                                    index++;
                                    createdVariations.add(index);
                                    setState(() {});
                                  },
                                  text: "Add variation",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              createdVariations.isNotEmpty
                                  ? Column(
                                      children: [
                                        ...createdVariations
                                            .map(
                                              (e) => SizedBox(
                                                width: 500,
                                                child:
                                                    ProductVariationExpansion(
                                                  onChange: (newVariation) {
                                                    _addEditProductVariation(
                                                        newVariation, e);
                                                  },
                                                  attributeValues:
                                                      attributeValues,
                                                  attributes: attributes,
                                                  product:
                                                      widget.currentProduct.id!,
                                                  productAttributes:
                                                      productAttributes,
                                                ),
                                              ),
                                            )
                                            .toList()
                                      ],
                                    )
                                  : const SizedBox(),
                              productVariations.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...productVariations
                                            .map((e) => SizedBox(
                                                  width: 500,
                                                  child:
                                                      ProductVariationExpansion(
                                                    onDelete: (id) {
                                                      _deleteDialog(id);
                                                    },
                                                    onChange: (newVariation) {
                                                      _addEditProductVariation(
                                                          newVariation, null);
                                                    },
                                                    currentProductVariation: e,
                                                    attributeValues:
                                                        attributeValues,
                                                    attributes: attributes,
                                                    product: widget
                                                        .currentProduct.id!,
                                                    productAttributes:
                                                        productAttributes,
                                                  ),
                                                ))
                                            .toList()
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          )
                        : const SizedBox();
                  },
                )),
          )
        : const Center(
            child: SizedBox(
              width: 10,
              child: UpText(""),
            ),
          );
  }
}

class ProductVariationExpansion extends StatefulWidget {
  final int product;
  final List<ProductAttribute> productAttributes;
  final List<Attribute> attributes;
  final List<AttributeValue> attributeValues;
  final Function onChange;
  final Function? onDelete;
  final int? index;
  final ProductVariation? currentProductVariation;
  const ProductVariationExpansion({
    Key? key,
    required this.product,
    required this.onChange,
    this.onDelete,
    this.index,
    this.currentProductVariation,
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
  ProductVariation? oldProductVariation;
  Map<String, int> options = {};

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

  _createProductVariation() {
    ProductVariation productVariation = ProductVariation(
      name: _nameController.text,
      id: widget.currentProductVariation != null &&
              widget.currentProductVariation!.id != null
          ? widget.currentProductVariation!.id
          : null,
      price: _priceController.text.isNotEmpty
          ? double.parse(_priceController.text)
          : null,
      description: _descriptionController.text,
      sku: _skuController.text,
      product: widget.product,
      gallery: gallery ?? 1,
      options: options,
      discountStartDate: _discountStartController.text.isNotEmpty
          ? DateTime.parse(_discountStartController.text)
          : null,
      discountEndDate: _discountEndController.text.isNotEmpty
          ? DateTime.parse(_discountEndController.text)
          : null,
      discounPrice: _discountPriceController.text.isNotEmpty
          ? double.parse(_discountPriceController.text)
          : null,
    );
    if (widget.currentProductVariation == null) {
      _clearFields();
    }
    widget.onChange(productVariation);
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentProductVariation != null &&
        widget.currentProductVariation!.id != null) {
      _initializeFields();
    }
  }

  _clearFields() {
    _nameController.text = "";
    _descriptionController.text = "";
    _priceController.text = "";
    _skuController.text = "";

    _discountPriceController.text = "";
    _discountStartController.text = "";
    _discountEndController.text = "";
    gallery = null;
    options = {};
  }

  _initializeFields() {
    _nameController.text = widget.currentProductVariation!.name ?? "";
    _descriptionController.text =
        widget.currentProductVariation!.description ?? "";
    _priceController.text = widget.currentProductVariation!.price.toString();
    _skuController.text = widget.currentProductVariation!.sku.toString();

    _discountPriceController.text =
        widget.currentProductVariation!.discounPrice != null
            ? widget.currentProductVariation!.discounPrice.toString()
            : "";
    _discountStartController.text =
        widget.currentProductVariation!.discountStartDate != null
            ? widget.currentProductVariation!.discountStartDate.toString()
            : "";
    _discountEndController.text =
        widget.currentProductVariation!.discountEndDate != null
            ? widget.currentProductVariation!.discountEndDate.toString()
            : "";
    gallery = widget.currentProductVariation!.gallery;
    options = widget.currentProductVariation!.options;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return UpExpansionTile(
      key: GlobalKey(),
      initiallyExpanded: false,
      titleWidget: widget.productAttributes.isNotEmpty
          ? Row(
              children: widget.productAttributes
                  .where((element) => element.useForVariation)
                  .map(
                    (e) => Expanded(
                      child: ProductVariationDropdown(
                          options: widget.currentProductVariation != null
                              ? widget.currentProductVariation!.options
                              : {},
                          attributeValues: widget.attributeValues,
                          productAttribute: e,
                          attributes: widget.attributes,
                          onChange: (map) {
                            if ((map as Map<String, dynamic>).isNotEmpty) {
                              (map).forEach((key, value) {
                                options[key] = value;
                              });
                            }
                          }),
                    ),
                  )
                  .toList(),
            )
          : const UpText(""),
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
        Align(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 100,
                    child: UpButton(
                      text: "Save",
                      onPressed: () {
                        _createProductVariation();
                      },
                    )),
              ),
              widget.currentProductVariation != null &&
                      widget.currentProductVariation!.id != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: 100,
                          child: UpButton(
                            text: "Delete",
                            onPressed: () {
                              if (widget.onDelete != null) {
                                widget.onDelete!(
                                    widget.currentProductVariation!.id);
                              }
                            },
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}

class ProductVariationDropdown extends StatefulWidget {
  final List<Attribute> attributes;
  final ProductAttribute productAttribute;
  final List<AttributeValue> attributeValues;
  final Function onChange;
  final Map<String, dynamic> options;

  const ProductVariationDropdown({
    Key? key,
    required this.onChange,
    required this.attributeValues,
    required this.productAttribute,
    required this.attributes,
    required this.options,
  }) : super(key: key);

  @override
  State<ProductVariationDropdown> createState() =>
      _ProductVariationDropdownState();
}

class _ProductVariationDropdownState extends State<ProductVariationDropdown> {
  List<UpLabelValuePair> dropdown = [];
  String currentSelected = "";
  Map<String, dynamic> oldOptions = {};

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
    oldOptions = widget.options;
    _setOptions();
  }

  _setOptions() {
    if (widget.options.isNotEmpty) {
      if (widget.attributeValues.any((element) =>
          element.id ==
          widget.options[widget.attributes
              .where(
                  (element) => element.id == widget.productAttribute.attribute)
              .first
              .name])) {
        currentSelected =
            "${widget.attributeValues.where((element) => element.id == widget.options[widget.attributes.where((element) => element.id == widget.productAttribute.attribute).first.name]).first.id}";

        if (!dropdown.any((element) => element.value == currentSelected)) {
          currentSelected = "";
        }
      } else {
        currentSelected = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options != oldOptions) {
      _setOptions();
      oldOptions = widget.options;
    }
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
                onChanged: ((value) {
                  if (value != null && value.isNotEmpty) {
                    Map<String, dynamic> map = {};
                    map[widget.attributes
                        .where((element) =>
                            element.id == widget.productAttribute.attribute)
                        .first
                        .name] = int.parse(value);
                    widget.onChange(map);
                  }
                }),
              ),
            ),
          )
        : const SizedBox();
  }
}
