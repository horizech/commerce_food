import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
// import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/models/restaurant.dart';
import 'package:shop/pages/cart/cart_widget.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_widget.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class Products extends StatefulWidget {
  final Map<String, String>? queryParams;
  const Products({
    this.queryParams,
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
  int? restaurantId;
  List<ProductVariation> productVariations = [];
  Restaurant? restaurant;
  List<GlobalKey> collectionKeys = [];
  @override
  void initState() {
    super.initState();
    if (widget.queryParams != null && widget.queryParams!.isNotEmpty) {
      if (widget.queryParams!["RestaurantId"] != null &&
          widget.queryParams!["RestaurantId"]!.isNotEmpty) {
        restaurantId = int.parse(widget.queryParams!["RestaurantId"] ?? "");
      }
    }
    getProducts();
  }

  getProducts() async {
    if (restaurantId != null) {
      // Map<String, dynamic> meta = {"Restaurant": restaurantId};
      products = await ProductService.getProducts([], {}, null, null, {});
      if (products != null && products!.isNotEmpty) {
        setState(() {});
      }
    }
  }

  // Widget _variationItems(int productId, Function onClick) {
  //   return FutureBuilder<Product?>(
  //     future: ProductDetailService.getProductById(productId),
  //     initialData: null,
  //     builder: (BuildContext context, AsyncSnapshot<Product?> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return Container(
  //           child: UpButton(
  //             text:
  //                 "${snapshot.data?.name}      -     Price  £ ${snapshot.data?.price}",
  //             onPressed: () => {
  //               onClick(snapshot.data?.id ?? -1),
  //             },
  //           ),
  //         );
  //       } else {
  //         return Container(
  //           child: const Text(
  //             'Loading...',
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _getProductVariations(int productId, Function onClick) {
    return FutureBuilder<List<ProductVariation>?>(
      future: ProductDetailService.getProductVariationsById(productId),
      initialData: null,
      builder: (BuildContext context,
          AsyncSnapshot<List<ProductVariation>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty
              ? Column(
                  children: [
                    ...snapshot.data!.map(
                      (e) {
                        return UpButton(
                          text: "${e.name}      -     Price  £ ${e.price}",
                          onPressed: () => {
                            onClick(e.id ?? -1),
                          },
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox();
        } else {
          return const SizedBox(
            child: Text(
              'Loading...',
            ),
          );
        }
      },
    );
  }

  _showDialog(Product product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Padding(
              padding: const EdgeInsets.all(0),
              child: SingleChildScrollView(
                  child: SizedBox(
                      width: 600, child: CartWidget(product: product)))),

          actionsPadding: const EdgeInsets.all(0),
          // titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          // contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          // actions: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          //     child: SizedBox(
          //       width: 100,
          //       child: UpButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         text: "Cancel",
          //       ),
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          //     child: SizedBox(
          //       width: 100,
          //       child: UpButton(
          //         text: "Add to cart",
          //         onPressed: () async {},
          //       ),
          //     ),
          //   ),
          // ],
        );
      },
    );
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
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: products != null && products!.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: BlocConsumer<StoreCubit, StoreState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.restaurants != null &&
                          state.restaurants!.isNotEmpty) {
                        restaurant = state.restaurants!
                            .where(((element) => element.id == restaurantId))
                            .first;
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
                          collections = collections.toSet().toList();
                        }

                        if (collections.isNotEmpty) {
                          for (var element in collections.toSet()) {
                            collectionKeys.add(GlobalKey());
                          }
                        }
                      }

                      return restaurant != null && collections.isNotEmpty
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
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: MediaWidget(
                                                  mediaId:
                                                      restaurant!.thumbnail),
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
                                              CrossAxisAlignment.start,
                                          children: [
                                            UpText(
                                              restaurant!.name,
                                              type: UpTextType.heading4,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                  child:
                                                      Icon(Icons.location_on),
                                                ),
                                                UpText(
                                                  restaurant!.address,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 8),
                                                  child: Icon(
                                                    Icons.phone,
                                                  ),
                                                ),
                                                UpText(restaurant!.phoneNo
                                                    .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                            onTap: () {
                                              ServiceManager<
                                                      UpNavigationService>()
                                                  .navigateToNamed(
                                                Routes.home,
                                              );
                                            },
                                            child: const UpText("Home / ")),
                                      ),
                                      const UpText("Menu"),
                                    ],
                                  ),
                                ),
                                UpOrientationalColumnRow(
                                  widths: const [200, 1000],
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            children: [
                                              ...collections
                                                  .asMap()
                                                  .entries
                                                  .map((e) => Container(
                                                        key: collectionKeys[
                                                            e.key],
                                                        child: Column(
                                                          children: [
                                                            Theme(
                                                              data: ThemeData()
                                                                  .copyWith(
                                                                      dividerColor:
                                                                          Colors
                                                                              .transparent),
                                                              child: UpExpansionTile(
                                                                  initiallyExpanded:
                                                                      true,
                                                                  title: e.value
                                                                      .name,
                                                                  textType:
                                                                      UpTextType
                                                                          .heading5,
                                                                  expandedAlignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  childrenPadding: const EdgeInsets.only(
                                                                      left:
                                                                          20.0,
                                                                      top: 4.0,
                                                                      bottom:
                                                                          4.0,
                                                                      right:
                                                                          20.0),
                                                                  children: [
                                                                    ...products!
                                                                        .where((element) =>
                                                                            element.collection ==
                                                                            e.value.id)
                                                                        .map(
                                                                          (e) =>
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                                      height: 10,
                                                                                    ),
                                                                                    UpText(
                                                                                      e.description ?? "",
                                                                                      style: UpStyle(
                                                                                        textColor: UpConfig.of(context).theme.primaryColor[200],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    e.price! > 0
                                                                                        ? UpText(
                                                                                            "£${e.price}",
                                                                                            style: UpStyle(
                                                                                              textColor: UpConfig.of(context).theme.primaryColor[900],
                                                                                            ),
                                                                                          )
                                                                                        : const Text("")
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 20,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  _showDialog(e);
                                                                                },
                                                                                child: const Icon(Icons.add),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                        .toList()
                                                                  ]),
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          0),
                                                              child: Divider(
                                                                thickness: 2,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ],
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 6,
                                          child: CartWidget1(),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      child: Column(children: const []),
                                    ),
                                  ],
                                ),

                                const Divider(),
                                // const Expanded(child: ProductCategoryScroll()),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...widget.collections
                .asMap()
                .entries
                .map((e) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) => _incrementEnter(e.key),
                      // onHover: _updateLocation,
                      onExit: (event) => _incrementExit(e.key),

                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
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
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
