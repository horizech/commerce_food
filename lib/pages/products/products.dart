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
// import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/models/restaurant.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/appbar/food_appbar.dart';
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
  int? restaurantId;
  Restaurant? restaurant;
  List<ProductOptionValue> productOptionValues = [];
  List<ProductOption> productOptions = [];

  List<GlobalKey> categoryKeys = [];
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
      Map<String, dynamic> meta = {"Restaurant": restaurantId};
      products = await ProductService.getProducts([], {}, null, null, meta);
      if (products != null && products!.isNotEmpty) {
        setState(() {});
      }
    }
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
                      if (state.productOptions != null &&
                          state.productOptions!.isNotEmpty) {
                        productOptions = state.productOptions!.toList();
                      }
                      if (state.restaurants != null &&
                          state.restaurants!.isNotEmpty) {
                        restaurant = state.restaurants!
                            .where(((element) => element.id == restaurantId))
                            .first;
                      }
                      if (products != null && products!.isNotEmpty) {
                        List<int> filteredOptionValues = [];
                        for (var element in products!) {
                          if (element.options != null &&
                              element.options!.isNotEmpty) {
                            element.options!.forEach((key, value) {
                              filteredOptionValues.add(value);
                            });
                          }
                        }
                        filteredOptionValues.toSet();
                        if (filteredOptionValues.isNotEmpty) {
                          if (state.productOptionValues != null &&
                              state.productOptionValues!.isNotEmpty) {
                            for (var optionValue in filteredOptionValues) {
                              productOptionValues.add(state.productOptionValues!
                                  .where((element) => element.id == optionValue)
                                  .first);
                            }
                          }
                        }
                        if (productOptionValues.isNotEmpty) {
                          for (var element in productOptionValues) {
                            categoryKeys.add(GlobalKey());
                          }
                        }
                      }

                      return restaurant != null &&
                              productOptionValues.isNotEmpty
                          ? Column(
                              children: [
                                Container(
                                  color: Colors.pink[100],
                                  height: 300,
                                  child: Center(
                                    child: UpOrientationalColumnRow(
                                      widths: const [300, 0],
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
                                            UpText(
                                              restaurant!.address,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            UpText(
                                                restaurant!.phoneNo.toString()),
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
                                  widths: const [300, 600],
                                  children: [
                                    FoodCategoriesListWidget(
                                      productOptionValues: productOptionValues,
                                      onChange: (value) {
                                        int index =
                                            productOptionValues.indexWhere(
                                                (element) => element == value);
                                        categoryKeys[index].currentContext;
                                        Scrollable.ensureVisible(
                                            categoryKeys[index].currentContext!,
                                            duration:
                                                const Duration(seconds: 2),
                                            curve: Curves.easeInOutCubic);
                                      },
                                    ),
                                    Column(
                                      children: [
                                        ...productOptionValues
                                            .asMap()
                                            .entries
                                            .map((e) => Container(
                                                  key: categoryKeys[e.key],
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
                                                            children: [
                                                              ...products!
                                                                  .where((element) =>
                                                                      element.options![
                                                                          "Type"] ==
                                                                      e.value
                                                                          .id)
                                                                  .map(
                                                                    (e) => Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const UpIcon(
                                                                          icon:
                                                                              Icons.circle,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                              UpText(
                                                                                "£${e.price}",
                                                                                style: UpStyle(
                                                                                  textColor: UpConfig.of(context).theme.primaryColor[900],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              20,
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
                                                                vertical: 8.0,
                                                                horizontal: 0),
                                                        child: Divider(
                                                          thickness: 2,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ],
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
  final List<ProductOptionValue> productOptionValues;
  const FoodCategoriesListWidget({
    Key? key,
    this.onChange,
    required this.productOptionValues,
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

    for (var element in widget.productOptionValues) {
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
            ...widget.productOptionValues
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
