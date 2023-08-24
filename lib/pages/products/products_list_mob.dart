import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
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
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ProductsListMob extends StatefulWidget {
  const ProductsListMob({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsListMob> createState() => _AllProductsState();
}

class _AllProductsState extends State<ProductsListMob> {
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

    getProducts();
  }

  getProducts() async {
    // Map<String, dynamic> meta = {"Restaurant": restaurantId};
    products = await ProductService.getProducts([], {}, null, null, {});
    if (products != null && products!.isNotEmpty) {
      setState(() {});
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
            backgroundColor: UpConfig.of(context).theme.baseColor.shade50,
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return UpScaffold(
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
            icon: const UpIcon(
              icon: Icons.person,
            ),
          ),
          IconButton(
            onPressed: () {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.foodCartPage);
            },
            icon: Stack(children: [
              const UpIcon(
                icon: Icons.shopping_cart,
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
                    child: Center(
                      child: UpText(
                        '$counter',
                        style: UpStyle(
                          textSize: 8,
                        ),
                      ),
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
              child: Column(
                children: [
                  BlocConsumer<StoreCubit, StoreState>(
                      listener: (context, state) {},
                      builder: (context, state) {
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

                        return collections.isNotEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: UpCard(
                                      style: UpStyle(
                                          cardHeight: 350,
                                          cardWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              16),
                                      body: Center(
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  height: 200,
                                                  child:
                                                      MediaWidget(mediaId: 6),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
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
                                                      padding: EdgeInsets.only(
                                                          right: 8),
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
                                                      padding: EdgeInsets.only(
                                                          right: 8),
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
                                  ),
                                  UpOrientationalColumnRow(
                                    widths: [
                                      MediaQuery.of(context).size.width / 5,
                                      MediaQuery.of(context).size.width / 1.25
                                    ],
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
                                                                            Colors.transparent),
                                                                child: UpExpansionTile(
                                                                    initiallyExpanded:
                                                                        true,
                                                                    title: e
                                                                        .value
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
                                                                        top:
                                                                            4.0,
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
                                                                                        style: UpStyle(textSize: 16),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 10,
                                                                                      ),
                                                                                      UpText(
                                                                                        e.description ?? "",
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 20,
                                                                                      ),
                                                                                      e.price != null && e.price! > 0
                                                                                          ? UpText(
                                                                                              "£${e.price}",
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
                                                                                  child: const UpIcon(icon: Icons.add),
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
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        0),
                                                                child: Divider(
                                                                  thickness: 1,
                                                                  color: UpConfig.of(
                                                                          context)
                                                                      .theme
                                                                      .baseColor
                                                                      .shade800,
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
                                      const SizedBox(
                                        child: Column(children: []),
                                      ),
                                    ],
                                  ),

                                  const Divider(),
                                  // const Expanded(child: ProductCategoryScroll()),
                                ],
                              )
                            : const SizedBox();
                      }),
                  const FooterWidget(),
                ],
              ),
            )
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
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Wrap(
          direction: MediaQuery.of(context).size.width >= 696
              ? Axis.vertical
              : Axis.horizontal,
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
                            border: MediaQuery.of(context).size.width >= 696
                                ? Border(
                                    left: BorderSide(
                                        width: 3,
                                        color: currentSelected == e.value.id
                                            ? UpConfig.of(context)
                                                .theme
                                                .primaryColor
                                            : Colors.transparent))
                                : Border(
                                    bottom: BorderSide(
                                        width: 3,
                                        color: currentSelected == e.value.id
                                            ? UpConfig.of(context)
                                                .theme
                                                .primaryColor
                                            : Colors.transparent))),
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: UpText(
                                e.value.name,
                                style: UpStyle(
                                    textSize: 16,
                                    textColor: optionValuesHovered[e.key]
                                        ? UpConfig.of(context)
                                            .theme
                                            .primaryColor
                                        : currentSelected == e.value.id
                                            ? UpConfig.of(context)
                                                .theme
                                                .primaryColor
                                            : UpConfig.of(context)
                                                .theme
                                                .baseColor
                                                .shade900,
                                    textWeight: currentSelected == e.value.id
                                        ? FontWeight.bold
                                        : FontWeight.normal),
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
