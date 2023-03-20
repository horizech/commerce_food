import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
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
import 'package:shop/pages/cart/cart_dialog_widget.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ProductsMob extends StatefulWidget {
  final Map<String, String>? queryParams;
  const ProductsMob({
    this.queryParams,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsMob> createState() => _AllProductsState();
}

class _AllProductsState extends State<ProductsMob> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  List<Product>? products;
  List<Collection> collections = [];
  int? restaurantId;
  List<ProductVariation> productVariations = [];
  Restaurant? restaurant;
  List<GlobalKey> collectionKeys = [];
  int counter = 0;
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

  _showDialog(Product product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Padding(
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                    width: 600,
                    child: CartDialogWidget(
                      onChange: () {},
                      product: product,
                    ))),
            actionsPadding: const EdgeInsets.all(0),
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(0, 12, 14, 8),
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
            //     padding: const EdgeInsets.fromLTRB(0, 12, 8, 8),
            //     child: SizedBox(
            //       width: 100,
            //       child: UpButton(
            //         text: "Add to cart",
            //         onPressed: () async {
            //           Navigator.pop(context);
            //           setState(() {
            //             counter++;
            //           });
            //         },
            //       ),
            //     ),
            //   ),
            // ],
          ),
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
        appBar: UpAppBar(
          titleWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                ServiceManager<UpNavigationService>()
                    .navigateToNamed(Routes.home);
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image(
                    image: AssetImage("assets/logo.png"),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ServiceManager<UpNavigationService>()
                    .navigateToNamed(Routes.loginSignup);
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                ServiceManager<UpNavigationService>()
                    .navigateToNamed(Routes.foodCartPage);
              },
              icon: Stack(children: [
                const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$counter',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
              ]),
            )
          ],
        ),
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
                                  height: 350,
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
                                              CrossAxisAlignment.center,
                                          children: [
                                            UpText(
                                              restaurant!.name,
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
                                                UpText(
                                                  restaurant!.address,
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
                                    FoodCategoriesListWidgetMobile(
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
                                                                                    e.price != null && e.price! > 0
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
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      0),
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
                                        ),
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

class FoodCategoriesListWidgetMobile extends StatefulWidget {
  final Function? onChange;
  final List<Collection> collections;
  const FoodCategoriesListWidgetMobile({
    Key? key,
    this.onChange,
    required this.collections,
  }) : super(key: key);

  @override
  State<FoodCategoriesListWidgetMobile> createState() =>
      _FoodCategoriesListWidgetMobileState();
}

class _FoodCategoriesListWidgetMobileState
    extends State<FoodCategoriesListWidgetMobile> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        child: Wrap(
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

                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
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
