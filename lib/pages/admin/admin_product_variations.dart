import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/add_edit_product_variation_dialog.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProductVariations extends StatefulWidget {
  const AdminProductVariations({Key? key}) : super(key: key);

  @override
  State<AdminProductVariations> createState() => _AdminProductVariationsState();
}

class _AdminProductVariationsState extends State<AdminProductVariations> {
  User? user;
  List<Product> variedProducts = [];

  List<Collection> collections = [];
  List<Collection> variedProductCollections = [];

  bool isAuthorized = false;
  int? selectedProduct;
  int? selectedCollection;
  @override
  void initState() {
    super.initState();
    user ??= Apiraiser.authentication.getCurrentUser();
    if (user != null && user!.roleIds != null) {
      if (user!.roleIds!.contains(2) || user!.roleIds!.contains(1)) {
        isAuthorized = true;
      }
    }

    getVarriedProducts();
  }

  getVarriedProducts() async {
    variedProducts = await AddEditProductService.getVariedProducts();
    if (variedProducts.isNotEmpty) {
      setState(() {});
    }
  }

  Widget leftSide() {
    return Visibility(
      visible: variedProductCollections.isNotEmpty && variedProducts.isNotEmpty,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.grey[200],
          width: 300,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ...variedProductCollections
                  .map(
                    (collection) => UpExpansionTile(
                      title: collection.name,
                      children: [
                        ...variedProducts
                            .where((element) =>
                                element.collection == collection.id)
                            .map(
                              (product) => GestureDetector(
                                onTap: (() {
                                  selectedCollection = collection.id!;
                                  selectedProduct = product.id;

                                  setState(() {});
                                }),
                                child: Container(
                                  color: selectedProduct == product.id
                                      ? UpConfig.of(context)
                                          .theme
                                          .primaryColor[100]
                                      : Colors.transparent,
                                  child: ListTile(
                                    title: UpText(product.name),
                                  ),
                                ),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  _addEditProductVariationsDialog(ProductVariation? productVariation) {
    if (selectedCollection != null && selectedProduct != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddEditProductVariationDialog(
            currentCollection: selectedCollection!,
            currentProduct: selectedProduct!,
            currentProductVariation: productVariation,
          );
        },
      ).then((result) async {
        if (result == "success") {
          setState(() {});
        }
      });
    }
  }

  _deleteProduct(int productVariationId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result = await AddEditProductService.deleteProductVariation(
            productVariationId);
        if (result != null && result.success) {
          showUpToast(
            context: context,
            text: result.message ?? "",
          );
          setState(() {});
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: isAuthorized
          ? variedProducts.isNotEmpty
              ? BlocConsumer<StoreCubit, StoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (collections.isEmpty) {
                      if (state.collections != null) {
                        collections = state.collections!.toList();
                      }

                      if (state.collections != null) {
                        List<int> filteredCollections = [];

                        for (var product in variedProducts) {
                          filteredCollections.add(product.collection);
                        }

                        if (filteredCollections.isNotEmpty) {
                          filteredCollections =
                              filteredCollections.toSet().toList();
                          for (var collection in filteredCollections) {
                            variedProductCollections.add(collections
                                .where((element) => element.id == collection)
                                .first);
                          }
                        }
                      }
                    }

                    return variedProducts.isNotEmpty &&
                            variedProductCollections.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                leftSide(),
                                const SizedBox(
                                  height: 20,
                                ),
                                selectedProduct != null &&
                                        selectedCollection != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          left: 50.0,
                                          right: 20,
                                          top: 10,
                                        ),
                                        child: SizedBox(
                                          width: 500,
                                          child: Visibility(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: UpText(
                                                          "Product Variations",
                                                          type: UpTextType
                                                              .heading5,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _addEditProductVariationsDialog(
                                                            null);
                                                      },
                                                      child: UpIcon(
                                                        icon: Icons.add,
                                                        style: UpStyle(
                                                            iconSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                FutureBuilder<
                                                    List<ProductVariation>>(
                                                  future: AddEditProductService
                                                      .getProductVariationByProductId(
                                                          selectedProduct!),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              List<
                                                                  ProductVariation>>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      return snapshot.hasData &&
                                                              snapshot.data !=
                                                                  null &&
                                                              snapshot.data!
                                                                  .isNotEmpty
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: SizedBox(
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      ...snapshot
                                                                          .data!
                                                                          .map((e) =>
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                  bottom: 8.0,
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Flexible(
                                                                                      child: SizedBox(
                                                                                        width: 400,
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            UpText(
                                                                                              e.name ?? "",
                                                                                              style: UpStyle(
                                                                                                textSize: 16,
                                                                                                textWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            UpText(
                                                                                              e.description ?? "",
                                                                                              style: UpStyle(textSize: 12),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        _addEditProductVariationsDialog(e);
                                                                                      },
                                                                                      child: UpIcon(
                                                                                        icon: Icons.edit,
                                                                                        style: UpStyle(iconSize: 20),
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        _deleteProduct(e.id!);
                                                                                      },
                                                                                      child: UpIcon(
                                                                                        icon: Icons.delete,
                                                                                        style: UpStyle(iconSize: 20),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ))
                                                                    ]),
                                                              ),
                                                            )
                                                          : const Center(
                                                              child: SizedBox(),
                                                            );
                                                    } else {
                                                      return const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child:
                                                            UpCircularProgress(
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          )
                        : const SizedBox();
                  })
              : const UpCircularProgress()
          : const UnAuthorizedWidget(),
    );
  }
}
