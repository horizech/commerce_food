import 'package:apiraiser/apiraiser.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/helpers/up_datetime_helper.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/pages/admin/add_edit_product_options_widget.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AddEditProductVariation extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AddEditProductVariation({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AddEditProductVariation> createState() =>
      _AddEditProductVariationState();
}

class _AddEditProductVariationState extends State<AddEditProductVariation> {
  ProductVariation? productVariation;
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
  List<ProductOption> productOptions = [];
  List<ProductOptionValue> productOptionsValue = [];
  int? productVariationId, productId;
  int? currentCollection;
  User? user;
  Map<String, int> options = {};

  Future<DateTime> _picker() async {
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
    DateTime date = await _picker();
    setState(() {
      _discountStartController.text = date.toString();
    });
  }

  _discountEndDate() async {
    DateTime date = await _picker();

    setState(() {
      _discountEndController.text = date.toString();
    });
  }

// in case of edit
  getProductVariationDetail() async {
    if (productId != null) {
      Product? product = await AddEditProductService.getProductById(productId!);
      if (product != null) {
        if (productVariationId != null) {
          productVariation =
              await AddEditProductService.getProductVariationById(
                  productVariationId ?? 0);
          if (productVariation != null) {
            setState(() {
              _nameController.text = productVariation!.name ?? "";
              _descriptionController.text = productVariation!.description ?? "";
              _priceController.text = productVariation!.price.toString();
              _skuController.text = productVariation!.sku ?? "";

              _discountPriceController.text =
                  productVariation!.discounPrice != null
                      ? productVariation!.discounPrice.toString()
                      : "";
              _discountStartController.text =
                  productVariation!.discountStartDate != null
                      ? productVariation!.discountStartDate.toString()
                      : "";
              _discountEndController.text =
                  productVariation!.discountEndDate != null
                      ? productVariation!.discountEndDate.toString()
                      : "";
              gallery = productVariation!.gallery;
              options = productVariation!.options;
              currentCollection = product.collection;
            });
          }
        } else {
          setState(() {
            currentCollection = product.collection;
          });
        }
      }
    }
  }

  addEditProductVariation() async {
    ProductVariation productVariation = ProductVariation(
      name: _nameController.text,
      id: productId,
      product: productId!,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      sku: _skuController.text,
      gallery: gallery ?? 4,
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

    APIResult? result = await AddEditProductService.addEditProductVariation(
        ProductVariation.toJson(productVariation), productVariationId);
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

  _uploadThumbnail(BuildContext context) async {
    FilePickerCross? result = await FilePickerCross.importFromStorage();
  }

  @override
  void initState() {
    super.initState();

    // product variation id
    if (widget.queryParams != null &&
        widget.queryParams!.isNotEmpty &&
        widget.queryParams!['productVariationId'] != null &&
        widget.queryParams!['productVariationId']!.isNotEmpty) {
      productVariationId =
          int.parse(widget.queryParams!['productVariationId']!);
    }
    user ??= Apiraiser.authentication.getCurrentUser();

    if (widget.queryParams != null &&
        widget.queryParams!.isNotEmpty &&
        widget.queryParams!['productId'] != null &&
        widget.queryParams!['productId']!.isNotEmpty) {
      productId = int.parse(widget.queryParams!['productId']!);
    }
    if (productId != null) {
      getProductVariationDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user != null &&
              user!.roleIds != null &&
              (user!.roleIds!.contains(2) || user!.roleIds!.contains(1))
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BlocConsumer<StoreCubit, StoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.productOptions != null &&
                        state.productOptions!.isNotEmpty) {
                      productOptions = state.productOptions!.toList();
                    }
                    if (state.productOptionValues != null &&
                        state.productOptionValues!.isNotEmpty &&
                        currentCollection != null) {
                      productOptionsValue = state.productOptionValues!
                          .where(
                            (c) => c.collection == (currentCollection),
                          )
                          .toList();
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: UpText("Product Variation"),
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

                            // product option values

                            Visibility(
                              visible: currentCollection != null,
                              child: AddEditProductOptionsWidget(
                                change: (newOptions) {
                                  options = newOptions;
                                },
                                options: options,
                                currentCollection: currentCollection,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: UpButton(
                                  onPressed: () => _uploadThumbnail(context),
                                  text: 'Upload Gallery',
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UpButton(
                                text: productVariationId != null
                                    ? "Edit Product Variation"
                                    : "Add Product Variation",
                                onPressed: () {
                                  addEditProductVariation();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          : const UnAuthorizedWidget(),
    );
  }
}
