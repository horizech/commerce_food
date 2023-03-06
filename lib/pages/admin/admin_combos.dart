import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/models/up_row.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_table.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/add_edit_combos_dialog.dart';
import 'package:shop/dialogs/delete_combo_dialog.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_combo.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AdminCombos extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AdminCombos({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AdminCombos> createState() => _AdminCombosState();
}

class _AdminCombosState extends State<AdminCombos> {
  List<Product> products = [];
  List<int> productIds = [];
  List<UpLabelValuePair> productsDropdown = [];
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  getAllProducts() async {
    products = await ProductService.getProducts([], {}, null, null, {});
    setState(() {});
  }

  List<Combo> combos = [];
  List<ProductCombo> productCombos = [];

  String currentSelectedCombo = "";
  List<String> currentSelectedProducts = [];
  List<UpLabelValuePair> combosDropdown = [];
  _comboAddEditDialog({Combo? combo}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddEditComboDialog(
          combo: combo,
        );
      },
    ).then((result) {
      if (result == "success") {
        getCombos();
      }
    });
  }

  getCombos() async {
    combos = await AddEditProductService.getCombos() ?? combos;
    if (combos.isNotEmpty) {
      combosDropdown.clear();
      for (var element in combos) {
        combosDropdown
            .add(UpLabelValuePair(label: element.name, value: "${element.id}"));
      }
      setState(() {});
    }
  }

  getProductCombos() async {
    productCombos =
        await AddEditProductService.getProductCombos() ?? productCombos;
    if (productCombos.isNotEmpty) {
      setState(() {});
    }
  }

  _updateProductCombos() {
    List<int> deleteIds = [];
    List<ProductCombo> updatedProductCombos = [];

    // add product combos
    if (currentSelectedCombo.isNotEmpty) {
      for (var p in currentSelectedProducts) {
        if (!productCombos.any((element) =>
            element.product == int.parse(p) &&
            element.combo == int.parse(currentSelectedCombo))) {
          updatedProductCombos.add(ProductCombo(
              product: int.parse(p), combo: int.parse(currentSelectedCombo)));
        }

        // delete product combo
        List<ProductCombo> comboBasedProduct = productCombos
            .where(
                (element) => element.combo == int.parse(currentSelectedCombo))
            .toList();
      }
    }
  }

  _comboDeleteDialog(int comboId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteCombo(
          comboId: comboId,
        );
      },
    ).then((result) {
      if (result == "success") {
        getCombos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BlocConsumer<StoreCubit, StoreState>(
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
                    if (combosDropdown.isEmpty) {
                      for (var element in combos) {
                        combosDropdown.add(UpLabelValuePair(
                            label: element.name, value: "${element.id}"));
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UpButton(
                                onPressed: () {
                                  _comboAddEditDialog();
                                },
                                text: "Add combo",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: combos.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: UpTable(
                                      columns: const [
                                        "Name",
                                        "Description",
                                        "Price",
                                        // "Gallery",
                                        "Actions"
                                      ],
                                      rows: combos
                                          .map(
                                            (e) => UpRow(
                                              [
                                                UpText(e.name),
                                                UpText(
                                                  e.description ?? "",
                                                ),
                                                UpText(
                                                  e.price.toString(),
                                                ),
                                                // UpText(
                                                //   e.gallery.toString(),
                                                // ),
                                                Row(
                                                  children: [
                                                    UpButton(
                                                      onPressed: () {
                                                        _comboAddEditDialog(
                                                            combo: e);
                                                      },
                                                      type: UpButtonType.icon,
                                                      child: const Icon(
                                                          Icons.edit),
                                                    ),
                                                    SizedBox(
                                                      child: UpButton(
                                                        type: UpButtonType.icon,
                                                        onPressed: () {
                                                          _comboDeleteDialog(
                                                              e.id!);
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
                                          .toList()),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                combosDropdown.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 300,
                                          child: UpDropDown(
                                            value: currentSelectedCombo,
                                            label: "Combo",
                                            itemList: combosDropdown,
                                            onChanged: ((value) {
                                              currentSelectedCombo =
                                                  value ?? "";
                                              if (currentSelectedCombo
                                                  .isNotEmpty) {
                                                if (productCombos.any((element) =>
                                                    element.combo ==
                                                    int.parse(
                                                        currentSelectedCombo))) {
                                                  for (var element
                                                      in productCombos) {
                                                    if (element.combo ==
                                                        int.parse(
                                                            currentSelectedCombo)) {
                                                      productIds
                                                          .add(element.product);
                                                      currentSelectedProducts.add(
                                                          "${element.product}");
                                                    }
                                                  }
                                                }
                                              }
                                              setState(() {});
                                            }),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                productsDropdown.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 300,
                                          child: UpDropDown(
                                            values: currentSelectedProducts,
                                            isMultipleSelect: true,
                                            label: "Product",
                                            itemList: productsDropdown,
                                            onMultipleChanged: ((value) {
                                              currentSelectedProducts =
                                                  value ?? [];

                                              setState(() {});
                                            }),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                UpButton(
                                  onPressed: () {
                                    _updateProductCombos();
                                  },
                                  text: "Update product combos",
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          : const UpCircularProgress(),
    );
  }
}
