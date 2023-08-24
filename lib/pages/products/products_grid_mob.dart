import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_combo.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/pages/cart/cart_dialog_widget.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/price/price.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ProductsGridMob extends StatefulWidget {
  const ProductsGridMob({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsGridMob> createState() => _AllProductsState();
}

class _AllProductsState extends State<ProductsGridMob> {
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
          backgroundColor: UpConfig.of(context).theme.baseColor.shade200,
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

    return UpScaffold(
      key: scaffoldKey,
      appBar: FoodAppbar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: products != null && products!.isNotEmpty
          ? BlocConsumer<StoreCubit, StoreState>(
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
                            .where(
                                (element) => element.id == product.collection)
                            .first
                            .parent ==
                        parentId) {
                      collections.add(state.collections!
                          .where((element) => element.id == product.collection)
                          .first);
                    }
                    if (combos.isNotEmpty) {
                      collections.add(const Collection(name: "Combos", id: -1));
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UpCard(
                              style: UpStyle(
                                  cardWidth:
                                      MediaQuery.of(context).size.width - 16),
                              body: UpOrientationalColumnRow(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // const SizedBox(
                                      //   height: 40,
                                      // ),
                                      const UpText(
                                        "Horizech Pizzeria",
                                        type: UpTextType.heading4,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: UpIcon(
                                              icon: Icons.location_on,
                                            ),
                                          ),
                                          UpText(
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
                                          const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: UpIcon(
                                              icon: Icons.phone,
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
                          FoodCategoriesListWidget(
                            collections: collections,
                            onChange: (value) {
                              int index = collections
                                  .indexWhere((element) => element == value);
                              collectionKeys[index].currentContext;
                              Scrollable.ensureVisible(
                                  collectionKeys[index].currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeInOutCubic);
                            },
                          ),
                          const SizedBox(height: 4),
                          MediaQuery.of(context).size.width <= 768
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        ...collections
                                            .asMap()
                                            .entries
                                            .map((e) => Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              25),
                                                  child: Container(
                                                    key: collectionKeys[e.key],
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: UpText(
                                                              e.value.name
                                                                  .toUpperCase(),
                                                              style: UpStyle(
                                                                  textSize: 24),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Wrap(
                                                              spacing: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  50,
                                                              direction: Axis
                                                                  .horizontal,
                                                              children:
                                                                  e.value.id ==
                                                                          -1
                                                                      ? [
                                                                          ...combos
                                                                              .map(
                                                                                (combo) => Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                  child: UpCard(
                                                                                    style: UpStyle(cardWidth: MediaQuery.of(context).size.width / 2.23),
                                                                                    body: Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: MediaQuery.of(context).size.width / 2.3,
                                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                                            child: MediaWidget(
                                                                                              mediaId: combo.thumbnail,
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                            child: Text(
                                                                                              combo.name,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: UpConfig.of(context).theme.baseColor.shade900),
                                                                                              textScaleFactor: (MediaQuery.of(context).size.width / 1400) * 2.5,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: MediaQuery.of(context).size.width <= 500 ? 28 : 44,
                                                                                            child: Text(
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 2,
                                                                                              combo.description ?? "",
                                                                                              style: TextStyle(color: UpConfig.of(context).theme.baseColor[900], fontSize: 16),
                                                                                              textScaleFactor: (MediaQuery.of(context).size.width / 1400) * 2.5,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          combo.price > 0
                                                                                              ? Text(
                                                                                                  "£ ${combo.price}",
                                                                                                  style: TextStyle(
                                                                                                    color: UpConfig.of(context).theme.baseColor[900],
                                                                                                    fontSize: 22,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                  textScaleFactor: (MediaQuery.of(context).size.width / 1400) * 2.5,
                                                                                                )
                                                                                              : const Text(""),
                                                                                          const SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                          Center(
                                                                                            child: UpButton(
                                                                                                style: UpStyle(
                                                                                                  buttonTextSize: MediaQuery.of(context).size.width <= 460 ? 8 : 12,
                                                                                                  iconSize: MediaQuery.of(context).size.width <= 460 ? 6 : 12,
                                                                                                  buttonHeight: MediaQuery.of(context).size.width <= 460 ? 30 : 50,
                                                                                                  buttonWidth: MediaQuery.of(context).size.width / 2,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  _showDialog(
                                                                                                    combo: combo,
                                                                                                  );
                                                                                                },
                                                                                                // icon: (Icons.add),
                                                                                                text: ("ADD TO CART")),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toList()
                                                                        ]
                                                                      : [
                                                                          ...products!
                                                                              .where((element) => element.collection == e.value.id)
                                                                              .map(
                                                                                (e) => Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                  child: UpCard(
                                                                                    style: UpStyle(cardWidth: MediaQuery.of(context).size.width / 2.23),
                                                                                    body: Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                                            height: MediaQuery.of(context).size.width / 2.3,
                                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                                            child: MediaWidget(
                                                                                              mediaId: e.thumbnail,
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                            child: Text(
                                                                                              e.name,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: UpConfig.of(context).theme.baseColor.shade900),
                                                                                              textScaleFactor: (MediaQuery.of(context).size.width / 1400) * 2.5,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: MediaQuery.of(context).size.width <= 500 ? 28 : 44,
                                                                                            child: Text(
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 2,
                                                                                              e.description ?? "",
                                                                                              style: TextStyle(color: UpConfig.of(context).theme.baseColor[900], fontSize: 16),
                                                                                              textScaleFactor: (MediaQuery.of(context).size.width / 1400) * 2.5,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          e.price != null && e.price! > 0
                                                                                              ? Text(
                                                                                                  "£ ${e.price}",
                                                                                                  style: TextStyle(
                                                                                                    color: UpConfig.of(context).theme.baseColor[900],
                                                                                                    fontSize: 22,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                  textScaleFactor: (MediaQuery.of(context).size.width / 1400) * 2.5,
                                                                                                )
                                                                                              : const Text(""),
                                                                                          const SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                          // MediaQuery.of(context).size.width <= 500 ?
                                                                                          Center(
                                                                                            child: UpButton(
                                                                                                style: UpStyle(
                                                                                                  buttonTextSize: MediaQuery.of(context).size.width <= 460 ? 8 : 12,
                                                                                                  iconSize: MediaQuery.of(context).size.width <= 460 ? 6 : 12,
                                                                                                  buttonHeight: MediaQuery.of(context).size.width <= 460 ? 30 : 50,
                                                                                                  buttonWidth: MediaQuery.of(context).size.width / 2,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  _showDialog(
                                                                                                    product: e,
                                                                                                  );
                                                                                                },
                                                                                                // icon: (Icons.add),
                                                                                                text: ("ADD TO CART")),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toList()
                                                                        ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        ...collections
                                            .asMap()
                                            .entries
                                            .map((e) => Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              100),
                                                  child: Container(
                                                    key: collectionKeys[e.key],
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: UpText(
                                                              e.value.name
                                                                  .toUpperCase(),
                                                              style: UpStyle(
                                                                  textSize: 24),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Wrap(
                                                              spacing: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  150,
                                                              direction: Axis
                                                                  .horizontal,
                                                              children:
                                                                  e.value.id ==
                                                                          -1
                                                                      ? [
                                                                          ...combos
                                                                              .map(
                                                                                (combo) => Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                  child: UpCard(
                                                                                    style: UpStyle(cardWidth: MediaQuery.of(context).size.width / 3.1),
                                                                                    body: Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: MediaQuery.of(context).size.width / 3.3,
                                                                                            width: MediaQuery.of(context).size.width / 3.3,
                                                                                            child: MediaWidget(
                                                                                              mediaId: combo.thumbnail,
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                            child: Text(
                                                                                              combo.name,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: UpConfig.of(context).theme.baseColor.shade900),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: MediaQuery.of(context).size.width <= 500 ? 28 : 44,
                                                                                            child: Text(
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 2,
                                                                                              combo.description ?? "",
                                                                                              style: TextStyle(color: UpConfig.of(context).theme.baseColor[900], fontSize: 16),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          combo.price > 0
                                                                                              ? Text(
                                                                                                  "£ ${combo.price}",
                                                                                                  style: TextStyle(
                                                                                                    color: UpConfig.of(context).theme.baseColor[900],
                                                                                                    fontSize: 20,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                )
                                                                                              : const Text(""),
                                                                                          const SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                          Center(
                                                                                            child: UpButton(
                                                                                                style: UpStyle(
                                                                                                  buttonHeight: 50,
                                                                                                  buttonWidth: MediaQuery.of(context).size.width / 2,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  _showDialog(
                                                                                                    combo: combo,
                                                                                                  );
                                                                                                },
                                                                                                // icon: (Icons.add),
                                                                                                text: ("ADD TO CART")),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toList()
                                                                        ]
                                                                      : [
                                                                          ...products!
                                                                              .where((element) => element.collection == e.value.id)
                                                                              .map(
                                                                                (e) => Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                  child: UpCard(
                                                                                    style: UpStyle(cardWidth: MediaQuery.of(context).size.width / 3.1),
                                                                                    body: Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                                            height: MediaQuery.of(context).size.width / 3.3,
                                                                                            width: MediaQuery.of(context).size.width / 3.3,
                                                                                            child: MediaWidget(
                                                                                              mediaId: e.thumbnail,
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                            child: Text(
                                                                                              e.name,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                fontSize: 20,
                                                                                                color: UpConfig.of(context).theme.baseColor.shade900,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: MediaQuery.of(context).size.width <= 500 ? 28 : 44,
                                                                                            child: Text(
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              maxLines: 2,
                                                                                              e.description ?? "",
                                                                                              style: TextStyle(color: UpConfig.of(context).theme.baseColor[900], fontSize: 16),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          e.price != null && e.price! > 0
                                                                                              ? Text(
                                                                                                  "£ ${e.price}",
                                                                                                  style: TextStyle(
                                                                                                    color: UpConfig.of(context).theme.baseColor[900],
                                                                                                    fontSize: 20,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                )
                                                                                              : const Text(""),
                                                                                          const SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                          // MediaQuery.of(context).size.width <= 500 ?
                                                                                          Center(
                                                                                            child: UpButton(
                                                                                                style: UpStyle(
                                                                                                  buttonHeight: 50,
                                                                                                  buttonWidth: MediaQuery.of(context).size.width / 2,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  _showDialog(
                                                                                                    product: e,
                                                                                                  );
                                                                                                },
                                                                                                // icon: (Icons.add),
                                                                                                text: ("ADD TO CART")),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toList()
                                                                        ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                ),
                          const CartFooter(),
                        ],
                      )
                    : const SizedBox();
              })
          : const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: UpCircularProgress(),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
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
                                top: 4.0, bottom: 4.0, right: 8.0, left: 4),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: currentSelected != e.value.id
                                      ? UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade100
                                      : UpConfig.of(context).theme.primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6, left: 12, right: 12),
                                child: UpText(
                                  e.value.name,
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

class CartFooter extends StatefulWidget {
  const CartFooter({super.key});

  @override
  State<CartFooter> createState() => _CartFooterState();
}

class _CartFooterState extends State<CartFooter> {
  double subtotal = 0;
  int itemcount = 0;
  calculatesubtotal(List<CartItem> cartItems) {
    subtotal = cartItems
        .map((e) => (getPrice(e as Product)))
        .reduce((value, subtotalPrice) => value + subtotalPrice);
    subtotal;
  }

  calculateitemcount(List<CartItem> cartItems) {
    itemcount = cartItems.length;
    itemcount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  UpConfig.of(context).theme.primaryColor,
                  UpConfig.of(context).theme.baseColor.shade600
                ]),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        height: 60,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  UpText(itemcount.toString()),
                  const UpText("  Item | £ "),
                  UpText(subtotal.toString()),
                ],
              ),
              GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Admin Login",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
