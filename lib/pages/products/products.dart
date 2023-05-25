import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
// import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_combo.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/pages/cart/cart_dialog_widget.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_widget.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class Products extends StatefulWidget {
  const Products({
    Key? key,
  }) : super(key: key);

  @override
  State<Products> createState() => _AllProductsState();
}

class _AllProductsState extends State<Products> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  List<Product>? products;
  List<Collection> collections = [];

  List<ProductVariation> productVariations = [];
  List<GlobalKey> collectionKeys = [];
  List<Combo> combos = [];
  List<ProductCombo> productCombos = [];
  @override
  void initState() {
    super.initState();

    getProducts();
  }

  getProducts() async {
    products = await ProductService.getProducts([], {}, null, null, {});
    if (products != null && products!.isNotEmpty) {
      setState(() {});
    }
  }

  _showDialog({Product? product, Combo? combo}) {
    List<Product> gProducts = [];
    if (combo != null) {
      List<int> productIds = productCombos
          .where(((element) => element.combo == combo.id))
          .map((e) => e.product)
          .toList();
      if (productIds.isNotEmpty && products != null && products!.isNotEmpty) {
        for (var element in productIds) {
          gProducts
              .add(products!.where((product) => product.id == element).first);
        }
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: 600,
                child: CartDialogWidget(
                  product: product,
                  combo: combo,
                  products: gProducts,
                  onChange: () {},
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(0),
        );
      },
    ).then((value) {
      if (value == "success") {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Container(
      decoration: BoxDecoration(
        color: UpConfig.of(context).theme.secondaryColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        appBar: FoodAppbar(),
        // bottomNavigationBar: const FooterWidget(),
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: products != null && products!.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: BlocConsumer<StoreCubit, StoreState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (productCombos.isEmpty) {
                        if (state.productCombos != null &&
                            state.productCombos!.isNotEmpty) {
                          productCombos = state.productCombos!.toList();
                        }
                      }
                      if (combos.isEmpty) {
                        if (state.combos != null && state.combos!.isNotEmpty) {
                          combos = state.combos!.toList();
                        }
                      }

                      if (state.collections != null &&
                          state.collections!.isNotEmpty) {
                        int parentId = state.collections!
                            .where((element) => element.name == "Main")
                            .first
                            .id!;
                        for (var product in products!) {
                          if (state.collections!
                                  .where((element) =>
                                      element.id == product.collection)
                                  .first
                                  .parent ==
                              parentId) {
                            collections.add(state.collections!
                                .where((element) =>
                                    element.id == product.collection)
                                .first);
                          }
                          if (combos.isNotEmpty) {
                            collections
                                .add(const Collection(name: "Combos", id: -1));
                          }
                          collections = collections.toSet().toList();
                        }

                        if (collections.isNotEmpty) {
                          for (var element in collections.toSet()) {
                            collectionKeys.add(GlobalKey());
                          }
                        }
                      }

                      return collections.isNotEmpty
                          ? Column(
                              children: [
                                Container(
                                  color: Colors.pink[100],
                                  height: 300,
                                  child: Center(
                                    child: UpOrientationalColumnRow(
                                      widths: const [
                                        250,
                                      ],
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 200,
                                              child: MediaWidget(mediaId: 6),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const UpText(
                                              "Horizech Pizzeria",
                                              type: UpTextType.heading4,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: UpConfig.of(context)
                                                        .theme
                                                        .primaryColor,
                                                  ),
                                                ),
                                                const UpText(
                                                  "Greater Manchester",
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: UpConfig.of(context)
                                                        .theme
                                                        .primaryColor,
                                                  ),
                                                ),
                                                UpText(232.toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                UpOrientationalColumnRow(
                                  widths: [
                                    MediaQuery.of(context).size.width / 7.5,
                                    MediaQuery.of(context).size.width / 1.67,
                                    MediaQuery.of(context).size.width / 4
                                  ],
                                  children: [
                                    FoodCategoriesListWidget(
                                      collections: collections,
                                      onChange: (value) {
                                        int index = collections.indexWhere(
                                            (element) => element == value);
                                        collectionKeys[index].currentContext;
                                        Scrollable.ensureVisible(
                                            collectionKeys[index]
                                                .currentContext!,
                                            duration:
                                                const Duration(seconds: 2),
                                            curve: Curves.easeInOutCubic);
                                      },
                                    ),
                                    Column(
                                      children: [
                                        ...collections
                                            .asMap()
                                            .entries
                                            .map((e) => Container(
                                                  key: collectionKeys[e.key],
                                                  child: Column(
                                                    children: [
                                                      Theme(
                                                        data: ThemeData().copyWith(
                                                            dividerColor: Colors
                                                                .transparent),
                                                        child: UpExpansionTile(
                                                            initiallyExpanded:
                                                                true,
                                                            title: e.value.name,
                                                            textType: UpTextType
                                                                .heading5,
                                                            expandedAlignment:
                                                                Alignment
                                                                    .topLeft,
                                                            childrenPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20.0,
                                                                    top: 4.0,
                                                                    bottom: 4.0,
                                                                    right:
                                                                        20.0),
                                                            children:
                                                                e.value.id == -1
                                                                    ? [
                                                                        ...combos
                                                                            .map(
                                                                              (combo) => Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const Padding(
                                                                                    padding: EdgeInsets.only(right: 8),
                                                                                    child: UpIcon(
                                                                                      icon: Icons.circle,
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        UpText(
                                                                                          combo.name,
                                                                                          style: UpStyle(
                                                                                            textColor: UpConfig.of(context).theme.primaryColor[600],
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        UpText(
                                                                                          combo.description ?? "",
                                                                                          style: UpStyle(
                                                                                            textColor: UpConfig.of(context).theme.primaryColor[200],
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        combo.price > 0
                                                                                            ? UpText(
                                                                                                "£${combo.price}",
                                                                                                style: UpStyle(
                                                                                                  textColor: UpConfig.of(context).theme.primaryColor[900],
                                                                                                ),
                                                                                              )
                                                                                            : const Text(""),
                                                                                        const SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _showDialog(
                                                                                        combo: combo,
                                                                                      );
                                                                                    },
                                                                                    child: const Icon(Icons.add),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                            .toList()
                                                                      ]
                                                                    : [
                                                                        ...products!
                                                                            .where((element) =>
                                                                                element.collection ==
                                                                                e.value.id)
                                                                            .map(
                                                                              (e) => Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const Padding(
                                                                                    padding: EdgeInsets.only(right: 8),
                                                                                    child: UpIcon(
                                                                                      icon: Icons.circle,
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        UpText(
                                                                                          e.name,
                                                                                          style: UpStyle(
                                                                                            textColor: UpConfig.of(context).theme.primaryColor[600],
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        UpText(
                                                                                          e.description ?? "",
                                                                                          style: UpStyle(
                                                                                            textColor: UpConfig.of(context).theme.primaryColor[200],
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        e.price != null && e.price! > 0
                                                                                            ? UpText(
                                                                                                "£${e.price}",
                                                                                                style: UpStyle(
                                                                                                  textColor: UpConfig.of(context).theme.primaryColor[900],
                                                                                                ),
                                                                                              )
                                                                                            : const Text(""),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _showDialog(product: e);
                                                                                    },
                                                                                    child: const Icon(Icons.add),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                            .toList()
                                                                      ]),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8.0,
                                                                horizontal: 0),
                                                        child: Divider(
                                                          thickness: 2,
                                                          color: UpConfig.of(
                                                                  context)
                                                              .theme
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: CartWidget(
                                          isVisible: true,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                const Divider(),
                                // const Expanded(child: ProductCategoryScroll()),
                                const FooterWidget(),
                              ],
                            )
                          : const SizedBox();
                    }),
              )
            : const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: UpCircularProgress(),
                ),
              ),
      ),
    );
  }
}

class FoodCategoriesListWidget extends StatefulWidget {
  final Function? onChange;
  final List<Collection> collections;
  const FoodCategoriesListWidget({
    Key? key,
    this.onChange,
    required this.collections,
  }) : super(key: key);

  @override
  State<FoodCategoriesListWidget> createState() =>
      _FoodCategoriesListWidgetState();
}

class _FoodCategoriesListWidgetState extends State<FoodCategoriesListWidget> {
  List<bool> optionValuesHovered = [];
  int? currentSelected;

  @override
  void initState() {
    super.initState();

    for (var element in widget.collections) {
      optionValuesHovered.add(false);
    }
  }

  void _incrementEnter(int key) {
    setState(() {
      optionValuesHovered[key] = true;
    });
  }

  void _incrementExit(int key) {
    setState(() {
      optionValuesHovered[key] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.collections
                .asMap()
                .entries
                .map((e) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) => _incrementEnter(e.key),
                      // onHover: _updateLocation,
                      onExit: (event) => _incrementExit(e.key),

                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    width: 3,
                                    color: currentSelected == e.value.id
                                        ? Colors.orange
                                        : Colors.transparent)),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onChange != null) {
                                widget.onChange!(e.value);
                              }
                              setState(() {
                                currentSelected = e.value.id;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                                right: 8.0,
                              ),
                              child: UpText(
                                e.value.name,
                                style: UpStyle(
                                  textSize: 16,
                                  textColor: optionValuesHovered[e.key]
                                      ? Colors.orange
                                      : currentSelected == e.value.id
                                          ? Colors.orange
                                          : UpConfig.of(context)
                                              .theme
                                              .primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
