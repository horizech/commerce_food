import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/widgets/media/add_media_widget.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_combo.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/app_bars/admin_appbar.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';

import 'package:shop/widgets/media/gallery_dropdown.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminCombos extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AdminCombos({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AdminCombos> createState() => _AdminCombosState();
}

class _AdminCombosState extends State<AdminCombos> {
  List<Product> products = [];
  int? selectedMedia;

  List<UpLabelValuePair> productsDropdown = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<Combo> combos = [];
  List<ProductCombo> productCombos = [];
  String currentSelectedProduct = "";
  List<Product> comboBasedProducts = [];
  int? gallery;
  Combo selectedCombo = const Combo(name: "", price: 0, id: -1);
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  getAllProducts() async {
    products = await ProductService.getProducts([], {}, null, null, {});
    setState(() {});
  }

  getCombos() async {
    combos = await AddEditProductService.getCombos() ?? combos;
    if (combos.isNotEmpty) {
      setState(() {});
    }
  }

  getProductCombos() async {
    productCombos =
        await AddEditProductService.getProductCombos() ?? productCombos;
    if (productCombos.isNotEmpty) {
      _setProducts();
      setState(() {});
    }
  }

  _updateCombos(Combo? c) async {
    Combo combo = Combo(
        name: nameController.text,
        price: priceController.text.isNotEmpty
            ? double.parse(priceController.text)
            : 0,
        gallery: gallery,
        thumbnail: selectedMedia ?? 1,
        description: descriptionController.text);
    APIResult? result = await AddEditProductService.addEditCombos(
        data: Combo.toJson(combo), comboId: c != null ? c.id! : null);
    if (result != null && result.success) {
      if (mounted) {
        UpToast().showToast(
          context: context,
          text: result.message ?? "",
        );
      }
      getCombos();
    } else {
      if (mounted) {
        UpToast().showToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    }
  }

  _deleteCombo(int comboId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result = await AddEditProductService.deleteCombo(comboId);
        if (result != null && result.success) {
          if (mounted) {
            UpToast().showToast(context: context, text: result.message ?? "");
          }
          selectedCombo =
              const Combo(name: "", price: 0, id: -1, thumbnail: null);
          nameController.text = "";
          priceController = TextEditingController();
          descriptionController.text = "";
          selectedMedia = null;
          getCombos();
        } else {
          if (mounted) {
            UpToast().showToast(
              context: context,
              text: "An Error Occurred",
            );
          }
        }
      }
    });
  }

  _addProductCombo() async {
    if (currentSelectedProduct.isNotEmpty &&
        selectedCombo.id != null &&
        selectedCombo.id != -1) {
      ProductCombo productCombo = ProductCombo(
          product: int.parse(currentSelectedProduct), combo: selectedCombo.id!);
      APIResult? result = await AddEditProductService.insertProductCombo(
          ProductCombo.toJson(productCombo));
      if (result != null && result.success) {
        if (mounted) {
          UpToast().showToast(
            context: context,
            text: result.message ?? "",
          );
        }

        getProductCombos();
      } else {
        if (mounted) {
          UpToast().showToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    }
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: UpCard(
        style: UpStyle(cardWidth: 300),
        body: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height - 80),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                GestureDetector(
                    onTap: (() {
                      selectedCombo = const Combo(name: "", price: 0, id: -1);
                      nameController.text = selectedCombo.name;
                      priceController = TextEditingController();
                      descriptionController.text =
                          selectedCombo.description ?? "";
                      selectedMedia = null;
                      setState(() {});
                    }),
                    child: Container(
                      color: selectedCombo.id == -1
                          ? UpConfig.of(context).theme.primaryColor
                          : Colors.transparent,
                      child: UpListTile(
                        title: "Create a new combo",
                        style: UpStyle(
                          listTileTextColor: selectedCombo.id == -1
                              ? UpThemes.getContrastColor(
                                  UpConfig.of(context).theme.primaryColor)
                              : UpConfig.of(context).theme.baseColor.shade900,
                        ),
                      ),
                    )),
                ...combos
                    .map(
                      (e) => GestureDetector(
                        onTap: (() {
                          selectedCombo = e;
                          nameController.text = selectedCombo.name;
                          priceController.text = selectedCombo.price.toString();
                          descriptionController.text =
                              selectedCombo.description ?? "";
                          gallery = selectedCombo.gallery;
                          selectedMedia = selectedCombo.thumbnail;
                          _setProducts();
                          setState(() {});
                        }),
                        child: Container(
                          color: selectedCombo.id == e.id
                              ? UpConfig.of(context).theme.primaryColor
                              : Colors.transparent,
                          child: UpListTile(
                            title: (e.name),
                            style: UpStyle(
                              listTileTextColor: selectedCombo.id == e.id
                                  ? UpThemes.getContrastColor(
                                      UpConfig.of(context).theme.primaryColor)
                                  : UpConfig.of(context).theme.baseColor.shade900,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteProductCombo(int productId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        if (productCombos.any((element) =>
            element.combo == selectedCombo.id &&
            element.product == productId)) {
          int id = productCombos
              .where((element) =>
                  element.combo == selectedCombo.id &&
                  element.product == productId)
              .first
              .id!;
          APIResult? result =
              await AddEditProductService.deleteProductCombo(id);
          if (result != null && result.success) {
            if (mounted) {
              UpToast().showToast(
                context: context,
                text: result.message ?? "",
              );
            }

            getProductCombos();
          } else {
            if (mounted) {
              UpToast().showToast(
                context: context,
                text: "An Error Occurred",
              );
            }
          }
        }
      }
    });
  }

  _setProducts() {
    comboBasedProducts = [];
    if (selectedCombo.id != null && selectedCombo.id != -1) {
      List<int> productsIds = productCombos
          .where((element) => element.combo == selectedCombo.id)
          .map((e) => e.product)
          .toList();

      for (var element in productsIds) {
        comboBasedProducts
            .add(products.where((product) => product.id == element).first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: const AdminAppbar(),
      drawer: const NavDrawer(),
      body: isUserAdmin()
          ? products.isNotEmpty
              ? BlocConsumer<StoreCubit, StoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (combos.isEmpty) {
                      if (state.combos != null && state.combos!.isNotEmpty) {
                        combos = state.combos!.toList();
                      }
                    }
                    if (productCombos.isEmpty) {
                      if (state.productCombos != null &&
                          state.productCombos!.isNotEmpty) {
                        productCombos = state.productCombos!.toList();
                      }
                    }

                    if (productsDropdown.isEmpty) {
                      if (products.isNotEmpty) {
                        for (var product in products) {
                          productsDropdown.add(
                            UpLabelValuePair(
                                label: product.name, value: "${product.id}"),
                          );
                        }
                      }
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            leftSide(),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 300,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: SizedBox(
                                    width: 400,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: UpText(
                                              "Combo",
                                              type: UpTextType.heading4,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 300,
                                                    child: UpTextField(
                                                      controller:
                                                          nameController,
                                                      label: 'Name',
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 300,
                                                    child: UpTextField(
                                                      controller:
                                                          descriptionController,
                                                      label: 'Description',
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 300,
                                                    child: UpTextField(
                                                      controller:
                                                          priceController,
                                                      label: 'Price',
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 300,
                                                    child: AddMediaWidget(
                                                      selectedMedia:
                                                          selectedMedia,
                                                      onChnage: (media) {
                                                        selectedMedia = media;
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 300,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GalleryDropdown(
                                                        gallery: gallery,
                                                        onChange: (value) {
                                                          gallery =
                                                              int.parse(value);
                                                        }),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Visibility(
                                                      visible:
                                                          selectedCombo.id !=
                                                              -1,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          width: 70,
                                                          height: 30,
                                                          child: UpButton(
                                                            onPressed: () {
                                                              _deleteCombo(
                                                                  selectedCombo
                                                                      .id!);
                                                            },
                                                            text: "Delete",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: 70,
                                                        height: 30,
                                                        child: UpButton(
                                                          onPressed: () {
                                                            _updateCombos(
                                                                selectedCombo
                                                                            .id !=
                                                                        -1
                                                                    ? selectedCombo
                                                                    : null);
                                                          },
                                                          text: "Save",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Visibility(
                                          visible: selectedCombo.id != -1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 300,
                                                child: Divider(
                                                  color: UpConfig.of(context)
                                                      .theme
                                                      .primaryColor,
                                                  thickness: 1,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: UpText(
                                                    "Products",
                                                    type: UpTextType.heading4,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: UpText(
                                                    "Add new product",
                                                    type: UpTextType.heading6,
                                                  ),
                                                ),
                                              ),
                                              productsDropdown.isNotEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: UpDropDown(
                                                              value:
                                                                  currentSelectedProduct,
                                                              label: "Product",
                                                              itemList:
                                                                  productsDropdown,
                                                              onChanged:
                                                                  ((value) {
                                                                currentSelectedProduct =
                                                                    value ?? "";

                                                                setState(() {});
                                                              }),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              width: 100,
                                                              child: UpButton(
                                                                onPressed: () {
                                                                  _addProductCombo();
                                                                },
                                                                text: "Add",
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Visibility(
                                                  visible: comboBasedProducts
                                                      .isNotEmpty,
                                                  child: SizedBox(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ...comboBasedProducts
                                                            .map(
                                                          (e) => Padding(
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
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
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
                                                                        UpText(
                                                                          e.description ??
                                                                              "",
                                                                          style:
                                                                              UpStyle(textSize: 12),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    _deleteProductCombo(
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
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              : const UpCircularProgress()
          : const UnAuthorizedWidget(),
    );
  }
}
