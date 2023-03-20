import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/date_time_picker.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/pages/admin/add_edit_keyword_widget.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/add_media_widget.dart';
import 'package:shop/widgets/gallery_dropdown.dart';

class AdminProduct extends StatefulWidget {
  final Product? currentProduct;
  final Collection collection;
  const AdminProduct({
    Key? key,
    this.currentProduct,
    required this.collection,
  }) : super(key: key);

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
  Map<String, int> options = {};
  Map<String, dynamic> meta = {};
  int? selectedMedia;
  List<AddOn> addons = [];
  Product? currentProduct;
  int view = 1;
  bool isProductDetailEnabled = false;

  _initializeFields() {
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
    options = currentProduct!.options ?? {};
    meta = currentProduct!.meta ?? {};
    selectedMedia = currentProduct!.thumbnail;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (widget.currentProduct != null) {
      currentProduct = widget.currentProduct;
      isProductDetailEnabled = true;
      _initializeFields();
    } else {
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
      // if (currentProduct == null) {
      //   List<AddOn> newAddons = [];
      //   for (var element in addons) {
      //     newAddons.add(
      //       AddOn(
      //           addOn: element.addOn,
      //           price: element.price,
      //           product: result.data),
      //     );
      //   }
      //   addons = newAddons;

      //   for (var element in addons) {
      //     await AddEditProductService.addProductAddon(AddOn.toJson(element));
      //   }
      // }
      // if (mounted) {}
      // Navigator.pop(context, "success");

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
                  view = 2;
                  setState(() {});
                }),
                child: Container(
                    color: view == 2
                        ? UpConfig.of(context).theme.primaryColor[100]
                        : Colors.transparent,
                    child: const ListTile(
                      title: UpText(
                        "Product Attributes",
                      ),
                    ))),
            Container(
                child: const ListTile(
              title: UpText(
                "Product Variations",
              ),
            )),
            Container(
                child: const ListTile(
              title: UpText(
                "Product Addons",
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget rightSide() {
    if (view == 2) {
      return _productAttributeView();
    } else {
      return _productInfoView();
    }
  }

  Widget _productAttributeView() {
    return const AddEditProductAttributes();
  }

  Widget _productInfoView() {
    return Padding(
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
                // options value
                // widget.collection.id! > 0 && isVariedProduct == false
                //     ? Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: AddEditAttributesWidget(
                //           change: (newOptions) {
                //             options = newOptions;
                //           },
                //           options: options,
                //           currentCollection: widget.collection.id!,
                //         ),
                //       )
                //     : const SizedBox(),

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: AddonsWidget(
                //     productId: currentProduct?.id,
                //     onChange: (value) {
                //       if (value != null) {
                //         addons = value;
                //       }
                //     },
                //   ),
                // )

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leftSide(),
            rightSide(),
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
                ))
          ],
        ),
      ),
    );
  }
}

class AddEditProductAttributes extends StatefulWidget {
  const AddEditProductAttributes({Key? key}) : super(key: key);

  @override
  State<AddEditProductAttributes> createState() =>
      _AddEditProductAttributesState();
}

class _AddEditProductAttributesState extends State<AddEditProductAttributes> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
