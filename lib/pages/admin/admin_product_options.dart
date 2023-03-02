import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/models/up_row.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_table.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/add_edit_product_option_dialog.dart';
import 'package:shop/dialogs/add_edit_product_option_value_dialog.dart';
import 'package:shop/dialogs/delete_product_option_dialog.dart';
import 'package:shop/dialogs/delete_product_option_value_dialog.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProductOptionsPage extends StatefulWidget {
  const AdminProductOptionsPage({Key? key}) : super(key: key);

  @override
  State<AdminProductOptionsPage> createState() =>
      _AdminProductOptionsPageState();
}

class _AdminProductOptionsPageState extends State<AdminProductOptionsPage> {
  String currentCollection = "", currentProductOption = "";
  List<ProductOption> productOptions = [];
  List<ProductOptionValue> productOptionValues = [];
  List<UpLabelValuePair> collectionDropdown = [];
  List<UpLabelValuePair> productOptionDropdown = [];
  User? user;
  bool isProductOptinsLoading = false;
  //  product option add dialog
  _productOptionAddDialog({ProductOption? productOption}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddEditProductOptionDialog(
          productOption: productOption,
          productOptions: productOptions,
          currentCollection: currentCollection.isNotEmpty
              ? int.parse(currentCollection)
              : null,
        );
      },
    ).then((result) {
      if (result == "success") {
        getProductOptions();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    user ??= Apiraiser.authentication.getCurrentUser();

    getProductOptions();
  }

  //by api
  getProductOptions() async {
    List<ProductOption>? newProductOptions =
        await AddEditProductService.getProductOptions();
    if (newProductOptions != null && newProductOptions.isNotEmpty) {
      productOptions = newProductOptions;

      productOptionDropdown.clear();

      productOptionDropdown.add(
        UpLabelValuePair(label: "Select", value: "-1"),
      );
      currentProductOption = productOptionDropdown.first.value;

      if (productOptions.isNotEmpty) {
        for (var p in productOptions) {
          productOptionDropdown
              .add(UpLabelValuePair(label: p.name, value: "${p.id}"));
        }
      }

      setState(() {});
    }
  }

  getCollection() async {
    List<Collection>? collections =
        await AddEditProductService.getCollections();

    if (collections != null && collections.isNotEmpty) {
      collectionDropdown.add(
        UpLabelValuePair(label: "All", value: "-1"),
      );
      if (collections.isNotEmpty) {
        for (var c in collections) {
          collectionDropdown
              .add(UpLabelValuePair(label: c.name, value: "${c.id}"));
        }
      }
      setState(() {});
    }
  }

  getProductOptionValues() async {
    if (currentCollection.isNotEmpty && currentProductOption.isNotEmpty) {
      List<ProductOptionValue>? newProductOptionValues =
          await AddEditProductService.getProductOptionValues(
        int.parse(currentCollection),
        int.parse(currentProductOption),
      );
      if (newProductOptionValues != null && newProductOptionValues.isNotEmpty) {
        productOptionValues = newProductOptionValues;

        isProductOptinsLoading = false;
        setState(() {});
      } else {
        productOptionValues = [];
        isProductOptinsLoading = false;
        setState(() {});
      }
    }
  }

  _productOptionValueAddDialog(
      {ProductOption? productOption, ProductOptionValue? productOptionValue}) {
    if (currentCollection.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddEditProductOptionValueDialog(
            productOptionValue: productOptionValue,
            productOption: productOption!,
            currentCollection: int.parse(currentCollection),
          );
        },
      ).then((result) {
        if (result == "success") {
          getProductOptionValues();
        }
      });
    }
  }

  _deleteProductOptionValueDialog(int productOptionValueId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteProductOptionValueDialog(
          productOptionValueId: productOptionValueId,
        );
      },
    ).then((result) {
      if (result == "success") {
        getProductOptionValues();
      }
    });
  }

  _deleteProductOptionDialog(int productOptionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteProductOptionDialog(
          productOptionId: productOptionId,
        );
      },
    ).then((result) {
      if (result == "success") {
        getProductOptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (collectionDropdown.isEmpty) {
      getCollection();
    }
    return Scaffold(
      body: user != null &&
              user!.roleIds != null &&
              (user!.roleIds!.contains(2) || user!.roleIds!.contains(1))
          ? productOptionDropdown.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 200,
                                child: UpDropDown(
                                  label: "Product Option",
                                  value: currentProductOption,
                                  itemList: productOptionDropdown,
                                  onChanged: (value) {
                                    currentProductOption = value.toString();
                                    getProductOptionValues();
                                    if (currentCollection.isNotEmpty &&
                                        currentProductOption.isNotEmpty) {
                                      isProductOptinsLoading = true;
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            UpButton(
                              onPressed: () {
                                _productOptionAddDialog();
                              },
                              type: UpButtonType.icon,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: UpTable(
                            columns: const [
                              "Id",
                              "Name",
                              "Actions",
                            ],
                            rows: currentProductOption.isNotEmpty
                                ? productOptions
                                    .where((element) =>
                                        element.id ==
                                        int.parse(currentProductOption))
                                    .map(
                                      (e) => UpRow(
                                        [
                                          SizedBox(
                                            child: UpText(
                                              e.id.toString(),
                                            ),
                                          ),
                                          SizedBox(
                                            child: UpText(
                                              e.name.toString(),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              UpButton(
                                                onPressed: () {
                                                  _productOptionAddDialog(
                                                    productOption: e,
                                                  );
                                                },
                                                type: UpButtonType.icon,
                                                child: const Icon(Icons.edit),
                                              ),
                                              SizedBox(
                                                child: UpButton(
                                                  type: UpButtonType.icon,
                                                  onPressed: () {
                                                    _deleteProductOptionDialog(
                                                        e.id!);
                                                  },
                                                  child:
                                                      const Icon(Icons.delete),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList()
                                : const []),
                      ),
                      Visibility(
                        visible: currentProductOption.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 200,
                            child: UpDropDown(
                              label: "Collection",
                              value: currentCollection,
                              itemList: collectionDropdown,
                              onChanged: (value) {
                                currentCollection = value.toString();
                                getProductOptionValues();
                                if (currentCollection.isNotEmpty &&
                                    currentProductOption.isNotEmpty) {
                                  isProductOptinsLoading = true;
                                  setState(() {});
                                }
                                // setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: currentCollection.isNotEmpty &&
                            currentProductOption.isNotEmpty,
                        child: Row(
                          children: [
                            const UpText("Product Option Value"),
                            UpButton(
                              onPressed: () {
                                _productOptionValueAddDialog(
                                    productOption: productOptions
                                        .where((element) =>
                                            element.id ==
                                            int.parse(currentProductOption))
                                        .first);
                              },
                              type: UpButtonType.icon,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      isProductOptinsLoading
                          ? const UpCircularProgress()
                          : Visibility(
                              visible: currentCollection.isNotEmpty &&
                                  currentProductOption.isNotEmpty,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: UpTable(
                                  columns: const [
                                    "Id",
                                    "Name",
                                    "Actions",
                                  ],
                                  rows: productOptionValues.isNotEmpty
                                      ? productOptionValues
                                          .map(
                                            (p) => UpRow(
                                              [
                                                SizedBox(
                                                  child: UpText(
                                                    p.id.toString(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: UpText(
                                                    p.name.toString(),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      child: UpButton(
                                                        type: UpButtonType.icon,
                                                        onPressed: () {
                                                          _productOptionValueAddDialog(
                                                              productOption:
                                                                  productOptions
                                                                      .where(
                                                                        (element) =>
                                                                            element.id ==
                                                                            int.parse(currentProductOption),
                                                                      )
                                                                      .first,
                                                              productOptionValue:
                                                                  p);
                                                        },
                                                        child: const Icon(
                                                            Icons.edit),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: UpButton(
                                                        type: UpButtonType.icon,
                                                        onPressed: () {
                                                          _deleteProductOptionValueDialog(
                                                              p.id!);
                                                        },
                                                        child: const Icon(
                                                            Icons.delete),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList()
                                      : [],
                                ),
                              ),
                            )
                    ],
                  ),
                )
              : const Center(
                  child: UpCircularProgress(),
                )
          : const UnAuthorizedWidget(),
    );
  }
}
