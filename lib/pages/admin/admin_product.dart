import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/date_time_picker.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/pages/admin/add_edit_addons.dart';
import 'package:shop/pages/admin/add_edit_filter_widget.dart';
import 'package:shop/pages/admin/add_edit_keyword_widget.dart';
import 'package:shop/pages/admin/add_edit_product_attributes.dart';
import 'package:shop/pages/admin/admin_product_variations.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/add_media_widget.dart';
import 'package:shop/widgets/gallery_dropdown.dart';

class AdminProduct extends StatefulWidget {
  final Product? currentProduct;
  final Collection collection;
  bool isReset;
  AdminProduct(
      {Key? key,
      this.currentProduct,
      required this.collection,
      this.isReset = false})
      : super(key: key);

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
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
  Map<String, dynamic> menuOptions = {};
  List<int> keywords = [];
  bool isVariedProduct = false;
  Map<String, dynamic> options = {};
  Map<String, dynamic> meta = {};
  int? selectedMedia;
  List<AddOn> addons = [];
  Product? currentProduct;
  int view = 1;
  bool isProductDetailEnabled = false;

  _initializeFields() {
    Map<String, int> newOptions = {};
    if (currentProduct!.options != null &&
        currentProduct!.options!.isNotEmpty) {
      currentProduct!.options!.forEach((key, value) {
        if (value != null && key.length == 1) {
          newOptions[key] = value;
        }
      });
    }
    _nameController.text = currentProduct!.name;
    _descriptionController.text = currentProduct!.description ?? "";
    isVariedProduct = currentProduct!.isVariedProduct;
    _priceController.text =
        currentProduct!.price != null ? currentProduct!.price!.toString() : "";
    _skuController.text = currentProduct!.sku.toString();

    _discountPriceController.text = currentProduct!.discounPrice != null
        ? currentProduct!.discounPrice.toString()
        : "";
    _discountStartController.text = currentProduct!.discountStartDate != null
        ? currentProduct!.discountStartDate.toString()
        : "";
    _discountEndController.text = currentProduct!.discountEndDate != null
        ? currentProduct!.discountEndDate.toString()
        : "";
    gallery = currentProduct!.gallery;
    thumbnail = currentProduct!.thumbnail;
    keywords = currentProduct!.keywords ?? [];
    options = newOptions;
    meta = currentProduct!.meta ?? {};
    selectedMedia = currentProduct!.thumbnail;

    setState(() {});
  }

  clearFields() {
    _nameController.text = "";
    _descriptionController.text = "";
    isVariedProduct = false;
    _priceController.text = "";
    _skuController.text = "";

    _discountPriceController.text = "";
    _discountStartController.text = "";
    _discountEndController.text = "";
    gallery = null;
    thumbnail = null;
    keywords = [];
    options = {};
    meta = {};
    selectedMedia = null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.currentProduct != null) {
      currentProduct = widget.currentProduct;
      isProductDetailEnabled = true;
      _initializeFields();
    } else {
      view = 1;
      isProductDetailEnabled = false;
    }
  }

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

  addEditProduct() async {
    Product product = Product(
      name: _nameController.text,
      id: currentProduct != null && currentProduct!.id != null
          ? currentProduct!.id
          : null,
      collection: widget.collection.id!,
      price: _priceController.text.isNotEmpty
          ? double.parse(_priceController.text)
          : null,
      description: _descriptionController.text,
      sku: _skuController.text,
      isVariedProduct: isVariedProduct,
      gallery: gallery ?? 1,
      keywords: keywords,
      thumbnail: selectedMedia ?? 1,
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

    APIResult? result = await AddEditProductService.addEditProduct(
        Product.toJson(product),
        currentProduct != null ? currentProduct!.id! : null);

    if (result != null) {
      if (result.success) {
        currentProduct = await AddEditProductService.getProductById(
            currentProduct != null && currentProduct!.id != null
                ? currentProduct!.id
                : result.data);
        if (currentProduct != null && currentProduct!.id != null) {
          isProductDetailEnabled = true;
          showUpToast(
            context: context,
            text: result.message ?? "",
          );
          setState(() {});
        }
      } else {
        showUpToast(
          context: context,
          text: result.message ?? "",
        );
      }
    } else {
      showUpToast(
        context: context,
        text: "An error occurred",
      );
    }
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.grey[200],
        width: 200,
        height: 400,
        child: Column(
          children: [
            GestureDetector(
              onTap: (() {
                view = 1;
                setState(() {});
              }),
              child: Container(
                color: view == 1
                    ? UpConfig.of(context).theme.primaryColor[100]
                    : Colors.transparent,
                child: const ListTile(
                  title: UpText(
                    "Product Info",
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: (() {
                  if (isProductDetailEnabled) {
                    view = 2;
                    setState(() {});
                  }
                }),
                child: Container(
                    color: view == 2
                        ? UpConfig.of(context).theme.primaryColor[100]
                        : Colors.transparent,
                    child: ListTile(
                      title: UpText(
                        style: UpStyle(
                            textColor: isProductDetailEnabled
                                ? UpConfig.of(context).theme.primaryColor[700]
                                : Colors.grey[700]),
                        "Product Attributes",
                      ),
                    ))),
            Visibility(
              visible: currentProduct != null &&
                  currentProduct!.isVariedProduct &&
                  currentProduct!.id != null,
              child: GestureDetector(
                onTap: (() {
                  if (isProductDetailEnabled) {
                    view = 3;
                    setState(() {});
                  }
                }),
                child: Container(
                  color: view == 3
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: ListTile(
                    title: UpText(
                      style: UpStyle(
                          textColor: isProductDetailEnabled
                              ? UpConfig.of(context).theme.primaryColor[700]
                              : Colors.grey[700]),
                      "Product Variations",
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: currentProduct != null &&
                  currentProduct!.isVariedProduct == false &&
                  currentProduct!.id != null,
              child: GestureDetector(
                onTap: (() {
                  if (isProductDetailEnabled) {
                    view = 5;
                    setState(() {});
                  }
                }),
                child: Container(
                  color: view == 5
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: ListTile(
                    title: UpText(
                      style: UpStyle(
                          textColor: isProductDetailEnabled
                              ? UpConfig.of(context).theme.primaryColor[700]
                              : Colors.grey[700]),
                      "Product Filters",
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                if (isProductDetailEnabled) {
                  view = 4;
                  setState(() {});
                }
              }),
              child: Container(
                color: view == 4
                    ? UpConfig.of(context).theme.primaryColor[100]
                    : Colors.transparent,
                child: ListTile(
                  title: UpText(
                    "Product Addons",
                    style: UpStyle(
                        textColor: isProductDetailEnabled
                            ? UpConfig.of(context).theme.primaryColor[700]
                            : Colors.grey[700]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSide() {
    if (view == 2) {
      return _productAttributeView();
    } else if (view == 3) {
      return _productVariationView();
    } else if (view == 4) {
      return _productAddonView();
    } else if (view == 5) {
      return _productFiltersView();
    } else {
      return _productInfoView();
    }
  }

  Widget _productVariationView() {
    return AdminProductVariations(
      currentProduct: currentProduct!,
    );
  }

  Widget _productFiltersView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AddEditFiltersWidget(
        onChange: (newOptions) {
          options = newOptions;
          addEditProduct();
        },
        options: options,
      ),
    );
  }

  Widget _productAddonView() {
    return AddEditAddonWidget(
      currentProduct: currentProduct!,
    );
  }

  Widget _productAttributeView() {
    return AddEditProductAttributes(
      currentProduct: currentProduct!,
    );
  }

  Widget _productInfoView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SizedBox(
              width: 500,
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: UpTextField(
                        controller: _nameController,
                        label: "Name",
                      ),
                    ),
                    // description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: UpTextField(
                        controller: _descriptionController,
                        label: "Description",
                        maxLines: 4,
                      ),
                    ),
                    // price
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: UpTextField(
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        label: "Price",
                      ),
                    ),
                    // sku
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: UpTextField(
                        controller: _skuController,
                        label: "Sku",
                      ),
                    ),
                    // discount price
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: UpTextField(
                        controller: _discountPriceController,
                        label: "Discound Price",
                      ),
                    ),
                    // discount start date
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: UpTextField(
                          controller: _discountEndController,
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: "Discound End Date",
                          onTap: () {
                            _discountEndDate();
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddEditKeywordWidget(
                        keywordList: keywords,
                        change: (value) {
                          if (value != null) {
                            keywords.clear();

                            for (var element in (value as List<String>)) {
                              keywords.add(int.parse(element));
                            }
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GalleryDropdown(
                        gallery: gallery,
                        onChange: (value) {
                          gallery = int.parse(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddMediaWidget(
                        selectedMedia: selectedMedia,
                        onChnage: (media) {
                          selectedMedia = media;
                          setState(() {});
                        },
                      ),
                    ),

                    // is varried checkbox
                    UpCheckbox(
                      initialValue: isVariedProduct,
                      label: "Is Varied",
                      onChange: (newCheck) => {
                        isVariedProduct = newCheck,
                        setState(() {}),
                      },
                    ),

                    // currentProduct != null
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: AddEditProductMetaWidget(
                    //           meta: meta,
                    //           onChange: (value) {
                    //             meta = value;
                    //           },
                    //         ),
                    //       )
                    //     : Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: AddEditProductMetaWidget(
                    //           meta: meta,
                    //           onChange: (value) {
                    //             meta = value;
                    //           },
                    //         ),
                    //       ),
                  ],
                ),
              )),
        ),
        const SizedBox(
          width: 20,
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: 100,
            child: UpButton(
              onPressed: () {
                addEditProduct();
              },
              text: "Save",
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReset) {
      view = 1;
      clearFields();
      widget.isReset = false;
    }

    return SizedBox(
      key: GlobalKey(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leftSide(),
          rightSide(),
        ],
      ),
    );
  }
}
