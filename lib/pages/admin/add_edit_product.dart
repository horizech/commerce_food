import 'dart:io';

import 'package:apiraiser/apiraiser.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/helpers/up_datetime_helper.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/pages/admin/add_edit_product_options_widget.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AddEditProduct extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AddEditProduct({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  Product? product;
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
  int? thumbnail;
  List<int> keywords = [];

  List<ProductOption> productOptions = [];
  List<ProductOptionValue> productOptionValues = [];
  List<Collection> collections = [];
  String currentCollection = "";
  String previousSelectCollection = "";

  List<UpLabelValuePair> collectionDropdown = [];
  int? productId;
  bool isVariedProduct = false;
  Map<String, int> options = {};
  Map<String, dynamic> meta = {};
  List<bool> checkboxes = [];
  List<TextEditingController> priceFields = [];
  List<TextEditingController> nameFields = [];

  Future<DateTime> _getPicker() async {
    DateTime? pickedDate = await UpDateTimeHelper.upDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    TimeOfDay? pickedTime = await UpDateTimeHelper.upTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null) {
      if (pickedTime != null) {
        pickedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return pickedDate ?? DateTime.now();
  }

  _discountStartDate() async {
    DateTime date = await _getPicker();
    setState(() {
      _discountStartController.text = date.toString();
    });
  }

  _discountEndDate() async {
    DateTime date = await _getPicker();

    setState(() {
      _discountEndController.text = date.toString();
    });
  }

// in case of edit
  getProductDetail() async {
    if (productId != null) {
      product = await ProductDetailService.getProductById(productId ?? 0);
      if (product != null && product != null) {
        setState(() {
          _nameController.text = product!.name;
          _descriptionController.text = product!.description ?? "";
          isVariedProduct = product!.isVariedProduct;
          _priceController.text = product!.price.toString();
          _skuController.text = product!.sku.toString();

          currentCollection = "${product!.collection}";
          _discountPriceController.text = product!.discounPrice != null
              ? product!.discounPrice.toString()
              : "";
          _discountStartController.text = product!.discountStartDate != null
              ? product!.discountStartDate.toString()
              : "";
          _discountEndController.text = product!.discountEndDate != null
              ? product!.discountEndDate.toString()
              : "";
          gallery = product!.gallery;
          thumbnail = product!.thumbnail;
          keywords = product!.keywords ?? [];
          options = product!.options ?? {};
          meta = product!.meta ?? {};
        });
      }
    }
  }

  addEditProduct() async {
    Product product = Product(
      name: _nameController.text,
      id: productId,
      collection: int.parse(currentCollection),
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      sku: _skuController.text,
      isVariedProduct: isVariedProduct,
      gallery: gallery ?? 1,
      keywords: keywords,
      thumbnail: thumbnail ?? 1,
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
      meta: meta,
    );

    APIResult? result1 = await AddEditProductService.addEditProduct(
        Product.toJson(product), productId);

    if (result1 != null && result1.success && result1.data != null) {
      List<ProductVariation>? productVariations =
          getProductVariationsList(result1.data!);
      if (productVariations != null && productVariations.isNotEmpty) {
        List<Map<String, dynamic>> jsonMaps =
            productVariations.map((e) => ProductVariation.toJson(e)).toList();
        APIResult? result =
            await AddEditProductService.addEditProductVariations(
                jsonMaps, result1.data!);

        if (result != null) {
          showUpToast(
            context: context,
            text: result.message ?? "",
          );
        } else {
          showUpToast(
            context: context,
            text: "An error occurred",
          );
        }
      }
    }
  }

  List<ProductVariation>? getProductVariationsList(int productId) {
    List<ProductVariation> productVariations = [];
    for (var productOption in productOptionValues) {
      int index = productOptionValues.indexOf(productOption);
      if (checkboxes[index]) {
        if (priceFields[index].text.isNotEmpty) {
          productVariations.add(getProductVariation(index, productId));
        }
      }
    }
    return productVariations;
  }

  ProductVariation getProductVariation(int index, int productId) {
    ProductVariation productVariation = ProductVariation(
      product: productId,
      sku: _skuController.text,
      price: priceFields[index].text.isNotEmpty
          ? double.parse(priceFields[index].text)
          : 0,
      options: {
        productOptions
            .where((element) =>
                element.id == productOptionValues[index].productOption)
            .first
            .name: productOptionValues[index].id ?? 0
      },
      gallery: 1,
      name: nameFields[index].text,
    );

    return productVariation;
  }

  _uploadThumbnail(BuildContext context) async {
    FilePickerCross? result = await FilePickerCross.importFromStorage();
    File file = File(result.path ?? "");
    AddEditProductService.uploadFile(result.path ?? "");
  }

  @override
  void initState() {
    super.initState();
    if (widget.queryParams != null &&
        widget.queryParams!.isNotEmpty &&
        widget.queryParams!['productId'] != null &&
        widget.queryParams!['productId']!.isNotEmpty) {
      productId = int.parse(widget.queryParams!['productId']!);

      if (productId != null) {
        getProductDetail();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.collections != null && state.collections!.isNotEmpty) {
                collections = state.collections!.toList();
              }

              if (collectionDropdown.isEmpty) {
                if (collections.isNotEmpty) {
                  for (var c in collections) {
                    collectionDropdown
                        .add(UpLabelValuePair(label: c.name, value: "${c.id}"));
                  }
                }
              }
              if (currentCollection.isNotEmpty &&
                  currentCollection != previousSelectCollection) {
                previousSelectCollection = currentCollection;
                if (state.productOptionValues != null &&
                    state.productOptionValues!.isNotEmpty) {
                  productOptionValues = state.productOptionValues!.where(
                    (element) {
                      return element.collection == int.parse(currentCollection);
                    },
                  ).toList();
                }
                if (productOptionValues.isNotEmpty) {
                  for (var element in productOptionValues) {
                    checkboxes.add(false);
                    priceFields.add(TextEditingController());
                    nameFields.add(TextEditingController());
                  }
                }
              }

              if (state.productOptions != null &&
                  state.productOptions!.isNotEmpty) {
                productOptions = state.productOptions!.toList();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpDropDown(
                          label: "Collection",
                          value: currentCollection,
                          itemList: collectionDropdown,
                          onChanged: (value) {
                            currentCollection = value.toString();
                            setState(() {});
                          },
                        ),
                      ),
                      // name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                          controller: _nameController,
                          label: "Name",
                        ),
                      ),
                      // description
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                          controller: _descriptionController,
                          label: "Description",
                          maxLines: 4,
                        ),
                      ),
                      // price
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          label: "Price",
                        ),
                      ),
                      // sku
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                          controller: _skuController,
                          label: "Sku",
                        ),
                      ),
                      // discount price
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                          controller: _discountPriceController,
                          label: "Discound Price",
                        ),
                      ),
                      // discount start date
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                            controller: _discountStartController,
                            prefixIcon: const Icon(Icons.calendar_today),
                            label: "Discound Start Date",
                            onTap: () {
                              _discountStartDate();
                            }),
                      ),
                      // discount end date
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpTextField(
                            controller: _discountEndController,
                            prefixIcon: const Icon(Icons.calendar_today),
                            label: "Discound End Date",
                            onTap: () {
                              _discountEndDate();
                            }),
                      ),
                      // is varried checkbox
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpCheckbox(
                          initialValue: isVariedProduct,
                          label: "Is Varied",
                          onChange: (newCheck) => {
                            isVariedProduct = newCheck,
                            setState(() {}),
                          },
                        ),
                      ),
                      // options value
                      Visibility(
                        visible: currentCollection.isNotEmpty &&
                            isVariedProduct == false,
                        child: AddEditProductOptionsWidget(
                          change: (newOptions) {
                            options = newOptions;
                          },
                          options: options,
                          currentCollection: currentCollection.isNotEmpty
                              ? int.parse(currentCollection)
                              : null,
                        ),
                      ),

                      Visibility(
                        visible:
                            isVariedProduct && productOptionValues.isNotEmpty,
                        child: Column(
                          children: productOptionValues
                              .asMap()
                              .entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            width: 150,
                                            alignment: Alignment.centerLeft,
                                            child: UpCheckbox(
                                              label: e.value.name,
                                              initialValue: checkboxes[e.key],
                                              onChange: (check) {
                                                checkboxes[e.key] = check;
                                                nameFields[e.key].text =
                                                    e.value.name;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: UpTextField(
                                            controller: nameFields[e.key],
                                            label: "Name",
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: UpTextField(
                                            controller: priceFields[e.key],
                                            label: "Price",
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),

                      //  productId != null
                      //   ? product != null
                      //       ? Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: AddEditProductMetaWidget(
                      //             meta: meta,
                      //             onChange: (value) {
                      //               meta = value;
                      //             },
                      //           ),
                      //         )
                      //       : const SizedBox()
                      //   : Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: AddEditProductMetaWidget(
                      //         meta: meta,
                      //         onChange: (value) {
                      //           meta = value;
                      //         },
                      //       ),
                      //     ),

                      // add edit button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpButton(
                            text: productId != null
                                ? "Edit Product"
                                : "Add Product",
                            onPressed: () {
                              addEditProduct();
                            }),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
