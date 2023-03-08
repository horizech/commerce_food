import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProductOptions extends StatefulWidget {
  const AdminProductOptions({Key? key}) : super(key: key);

  @override
  State<AdminProductOptions> createState() => _AdminProductOptionsState();
}

class _AdminProductOptionsState extends State<AdminProductOptions> {
  String currentCollection = "", currentProductOption = "";
  List<ProductOption> productOptions = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController productOptionValueNameController =
      TextEditingController();

  List<ProductOptionValue> productOptionValues = [];
  List<UpLabelValuePair> collectionDropdown = [];
  List<UpLabelValuePair> productOptionDropdown = [];
  User? user;
  ProductOption selectedProductOption = const ProductOption(name: "", id: -1);
  bool isProductOptinsLoading = false;
  List<ProductOptionValue> filteredProductOptionValues = [];
  @override
  void initState() {
    super.initState();
    user ??= Apiraiser.authentication.getCurrentUser();

    getProductOptions();
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.grey[200],
        width: 300,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            GestureDetector(
                onTap: (() {
                  selectedProductOption = const ProductOption(name: "", id: -1);
                  nameController.text = selectedProductOption.name;

                  setState(() {});
                }),
                child: Container(
                  color: selectedProductOption.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new product option"),
                  ),
                )),
            ...productOptions
                .map(
                  (e) => GestureDetector(
                    onTap: (() {
                      selectedProductOption = e;
                      nameController.text = selectedProductOption.name;
                      _setProductOptionValues();
                      setState(() {});
                    }),
                    child: Container(
                      color: selectedProductOption.id == e.id
                          ? UpConfig.of(context).theme.primaryColor[100]
                          : Colors.transparent,
                      child: ListTile(
                        title: UpText(e.name),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }

  _updateProductOption(ProductOption? option) async {
    ProductOption newProductOption = ProductOption(
      name: nameController.text,
    );
    APIResult? result = await AddEditProductService.addEditProductOption(
        data: newProductOption.toJson(newProductOption),
        productOptionId: option?.id);

    if (result != null) {
      showUpToast(
        context: context,
        text: result.message ?? "",
      );
      getProductOptions();
    } else {
      showUpToast(
        context: context,
        text: "An Error Occurred",
      );
    }
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
    if (currentCollection.isNotEmpty && selectedProductOption.id != -1) {
      List<ProductOptionValue>? newProductOptionValues =
          await AddEditProductService.getProductOptionValues();
      if (newProductOptionValues != null && newProductOptionValues.isNotEmpty) {
        productOptionValues = newProductOptionValues;
        _setProductOptionValues();
        setState(() {});
      }
    }
  }

  _deleteProductOption(int productOptionId) async {
    APIResult? result =
        await AddEditProductService.deleteProductOption(productOptionId);
    if (result != null && result.success) {
      showUpToast(context: context, text: result.message ?? "");
      nameController.text = "";
      selectedProductOption = const ProductOption(name: "", id: -1);
      getProductOptions();
    } else {
      showUpToast(
        context: context,
        text: "An Error Occurred",
      );
    }
  }

  _deleteProductOptionValue(int productOptionValueId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteProductOptionValue(
                productOptionValueId);
        if (result != null && result.success) {
          showUpToast(context: context, text: result.message ?? "");
          getProductOptionValues();
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    });
  }

  _updateProductOptionValue() async {
    if (currentCollection.isNotEmpty &&
        productOptionValueNameController.text.isNotEmpty &&
        selectedProductOption.id != -1) {
      ProductOptionValue newProductOptionValue = ProductOptionValue(
        name: productOptionValueNameController.text,
        productOption: selectedProductOption.id!,
        collection: int.parse(currentCollection),
      );
      APIResult? result =
          await AddEditProductService.addEditProductOptionValues(
        data: newProductOptionValue.toJson(newProductOptionValue),
      );
      if (result != null) {
        showUpToast(
          context: context,
          text: result.message ?? "",
        );
        productOptionValueNameController.text = "";
        getProductOptionValues();
      } else {
        showUpToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    } else {
      showUpToast(
        context: context,
        text: "Please enter all fields",
      );
    }
  }

  _setProductOptionValues() {
    filteredProductOptionValues = [];

    if (currentCollection.isNotEmpty && selectedProductOption.id! > -1) {
      for (var element in productOptionValues) {
        if (element.collection == int.parse(currentCollection) &&
            selectedProductOption.id == element.productOption) {
          filteredProductOptionValues.add(element);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (collectionDropdown.isEmpty) {
      getCollection();
    }
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: user != null &&
              user!.roleIds != null &&
              (user!.roleIds!.contains(2) || user!.roleIds!.contains(1))
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (productOptionValues.isEmpty) {
                  if (state.productOptionValues != null &&
                      state.productOptionValues!.isNotEmpty) {
                    productOptionValues = state.productOptionValues!.toList();
                  }
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftSide(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                          right: 20,
                          top: 10,
                        ),
                        child: SizedBox(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: UpText(
                                    "Product Option",
                                    type: UpTextType.heading5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: UpTextField(
                                          controller: nameController,
                                          label: 'Name',
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 70,
                                              child: UpButton(
                                                onPressed: () {
                                                  _updateProductOption(
                                                    selectedProductOption.id !=
                                                            -1
                                                        ? selectedProductOption
                                                        : null,
                                                  );
                                                },
                                                text: "Save",
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                selectedProductOption.id != -1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 70,
                                                child: UpButton(
                                                  onPressed: () {
                                                    _deleteProductOption(
                                                        selectedProductOption
                                                            .id!);
                                                  },
                                                  text: "Delete",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: selectedProductOption.id != -1,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: UpText(
                                          "Product Option Values",
                                          type: UpTextType.heading5,
                                        ),
                                      ),
                                    ),
                                    collectionDropdown.isNotEmpty
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Visibility(
                                                visible: currentProductOption
                                                    .isNotEmpty,
                                                child: SizedBox(
                                                  width: 300,
                                                  child: UpDropDown(
                                                    label: "Collection",
                                                    value: currentCollection,
                                                    itemList:
                                                        collectionDropdown,
                                                    onChanged: (value) {
                                                      currentCollection =
                                                          value.toString();
                                                      _setProductOptionValues();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: UpText(
                                          "Add new product option value",
                                          type: UpTextType.heading6,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: UpTextField(
                                              controller:
                                                  productOptionValueNameController,
                                              label: "Product Option Value",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: UpButton(
                                                onPressed: () {
                                                  _updateProductOptionValue();
                                                },
                                                text: "Add",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Visibility(
                                          visible: filteredProductOptionValues
                                              .isNotEmpty,
                                          child: SizedBox(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ...filteredProductOptionValues
                                                      .map((e) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              bottom: 8.0,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 400,
                                                                    child:
                                                                        UpText(
                                                                      e.name,
                                                                      style:
                                                                          UpStyle(
                                                                        textSize:
                                                                            16,
                                                                        textWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    _deleteProductOptionValue(
                                                                        e.id!);
                                                                  },
                                                                  child: UpIcon(
                                                                    icon: Icons
                                                                        .delete,
                                                                    style: UpStyle(
                                                                        iconSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                ]),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
