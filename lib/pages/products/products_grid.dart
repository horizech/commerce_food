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
// import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsGrid> createState() => _AllProductsState();
}

class _AllProductsState extends State<ProductsGrid> {
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
                                // widths: const [
                                //   250,
                                // ],
                                children: [
                                  // Column(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.center,
                                  //   children: [
                                  //     SizedBox(
                                  //       height: 200,
                                  //       child: MediaWidget(mediaId: 6),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   width: 40,
                                  // ),
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
                          Expanded(
                            child: UpOrientationalColumnRow(
                              widths: [
                                MediaQuery.of(context).size.width / 1.34,
                                MediaQuery.of(context).size.width / 4
                              ],
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      ...collections
                                          .asMap()
                                          .entries
                                          .map((e) => Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
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
                                                                vertical: 8.0),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
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
                                                            direction:
                                                                Axis.horizontal,
                                                            children:
                                                                e.value.id == -1
                                                                    ? [
                                                                        ...combos
                                                                            .map(
                                                                              (combo) => Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                child: UpCard(
                                                                                  style: UpStyle(cardWidth: MediaQuery.of(context).size.width / 4.55),
                                                                                  body: Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: MediaQuery.of(context).size.width / 4.2,
                                                                                          width: MediaQuery.of(context).size.width / 4.2,
                                                                                          child: MediaWidget(
                                                                                            mediaId: combo.thumbnail,
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                          child: UpText(
                                                                                            combo.name,
                                                                                            style: UpStyle(textWeight: FontWeight.bold, textSize: 18),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 28,
                                                                                          child: Text(
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 2,
                                                                                            combo.description ?? "",
                                                                                            style: TextStyle(color: UpConfig.of(context).theme.baseColor[900]),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        combo.price > 0
                                                                                            ? UpText(
                                                                                                "£ ${combo.price}",
                                                                                                style: UpStyle(textWeight: FontWeight.bold, textSize: 16),
                                                                                              )
                                                                                            : const Text(""),
                                                                                        const SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        Center(
                                                                                          child: UpButton(
                                                                                              onPressed: () {
                                                                                                _showDialog(
                                                                                                  combo: combo,
                                                                                                );
                                                                                              },
                                                                                              icon: (Icons.add),
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
                                                                            .where((element) =>
                                                                                element.collection ==
                                                                                e.value.id)
                                                                            .map(
                                                                              (e) => Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                child: UpCard(
                                                                                  style: UpStyle(cardWidth: MediaQuery.of(context).size.width / 4.5),
                                                                                  body: Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                                          height: MediaQuery.of(context).size.width / 4.2,
                                                                                          width: MediaQuery.of(context).size.width / 4.2,
                                                                                          child: MediaWidget(
                                                                                            mediaId: e.thumbnail,
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                          child: Text(
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            e.name,
                                                                                            style: TextStyle(color: UpConfig.of(context).theme.baseColor[900], fontSize: 16, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 32,
                                                                                          child: Text(
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 2,
                                                                                            e.description ?? "",
                                                                                            style: TextStyle(color: UpConfig.of(context).theme.baseColor[900]),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        e.price != null && e.price! > 0
                                                                                            ? UpText(
                                                                                                "£ ${e.price}",
                                                                                                style: UpStyle(textWeight: FontWeight.bold, textSize: 16),
                                                                                              )
                                                                                            : const Text(""),
                                                                                        const SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        Center(
                                                                                          child: UpButton(
                                                                                              onPressed: () {
                                                                                                _showDialog(
                                                                                                  product: e,
                                                                                                );
                                                                                              },
                                                                                              icon: (Icons.add),
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
                               const Center(
                                  child:  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CartWidget(
                                      isVisible: true,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const FooterWidget(),
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
    return SizedBox(
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
    );
  }
}
