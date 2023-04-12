// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_up/config/up_config.dart';
// import 'package:flutter_up/models/up_label_value.dart';
// import 'package:flutter_up/widgets/up_circualar_progress.dart';
// import 'package:flutter_up/widgets/up_text.dart';
// import 'package:shop/models/product.dart';
// import 'package:shop/models/attribute_value.dart';
// import 'package:shop/models/attribute.dart';
// import 'package:shop/models/restaurant.dart';
// import 'package:shop/services/products_service.dart';
// import 'package:shop/widgets/app_bars/food_appbar.dart';
// import 'package:shop/widgets/footer/food_footer.dart';
// import 'package:shop/widgets/media/media_widget.dart';
// import 'package:shop/widgets/restaurant/restaurant_grid.dart';
// import 'package:shop/widgets/store/store_cubit.dart';

// class HomeMobPage extends StatefulWidget {
//   const HomeMobPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<HomeMobPage> createState() => _HomeMobPageState();
// }

// class _HomeMobPageState extends State<HomeMobPage> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   List<Restaurant> restaurants = [];
//   List<Restaurant> filteredRestaurant = [];
//   List<AttributeValue> attributeValues = [];
//   List<Attribute> attributes = [];

//   List<UpLabelValuePair> filtersDropdown = [];
//   Map<String, List<int>> variations = {};
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: UpConfig.of(context).theme.secondaryColor,
//       ),
//       child: Scaffold(
//         appBar: FoodAppbar(),
//         persistentFooterAlignment: AlignmentDirectional.bottomCenter,
//         // bottomNavigationBar: const FooterWidget(),
//         backgroundColor: Colors.transparent,
//         key: scaffoldKey,
//         body: BlocConsumer<StoreCubit, StoreState>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             if (state.restaurants != null && state.restaurants!.isNotEmpty) {
//               restaurants = state.restaurants!.toList();
//             }
//             if (state.attributeValues != null &&
//                 state.attributeValues!.isNotEmpty) {
//               attributeValues = state.attributeValues!.toList();
//             }
//             if (state.attributes != null && state.attributes!.isNotEmpty) {
//               attributes = state.attributes!.toList();
//             }

//             return SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Center(
//                 child: Column(
//                   children: [
//                     // Visibility(
//                     //   visible: attributeValues.isNotEmpty,
//                     //   child: SizedBox(
//                     //     height: 200,
//                     //     child: ListView.builder(
//                     //         scrollDirection: Axis.horizontal,
//                     //         itemCount: attributeValues.length,
//                     //         shrinkWrap: true,
//                     //         itemBuilder: (BuildContext context, int index) {
//                     //           return Padding(
//                     //             padding: const EdgeInsets.all(8.0),
//                     //             child: FilterBox(
//                     //               onChange:
//                     //                   (ProductOptionValue productOptionValue) {
//                     //                 variations.addAll({
//                     //                   (attributes
//                     //                       .where((element) =>
//                     //                           element.id ==
//                     //                           productOptionValue.productOption)
//                     //                       .first
//                     //                       .name): [productOptionValue.id!],
//                     //                 });
//                     //                 setState(() {});
//                     //               },
//                     //               productOptionValue:
//                     //                   attributeValues[index],
//                     //             ),
//                     //           );
//                     //         }),
//                     //   ),
//                     // ),

//                     FutureBuilder<List<Product>>(
//                         future: ProductService.getProducts(
//                             [], variations, null, null, {}),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<List<Product>> snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.done) {
//                             if (snapshot.hasData && snapshot.data != null) {
//                               List<int> restaurantIds = [];
//                               filteredRestaurant = [];
//                               for (var data in snapshot.data!) {
//                                 if (data.meta != null &&
//                                     data.meta!["Restaurant"] != null) {
//                                   restaurantIds.add(data.meta!["Restaurant"]);
//                                 }
//                               }
//                               if (restaurantIds.isNotEmpty) {
//                                 for (var id in restaurantIds) {
//                                   filteredRestaurant.add(restaurants
//                                       .where((element) => element.id == id)
//                                       .first);
//                                 }
//                                 filteredRestaurant.toSet();
//                               }
//                             }
//                             return snapshot.hasData && restaurants.isNotEmpty
//                                 ? SizedBox(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: RestaurantGrid(
//                                         restaurants: restaurants,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: SizedBox(
//                                       child: UpText("No restaurant found"),
//                                     ),
//                                   );
//                           } else {
//                             return const UpCircularProgress();
//                           }
//                         }),
//                     const FooterWidget(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class FilterBox extends StatelessWidget {
//   final Function onChange;
//   final AttributeValue productOptionValue;
//   const FilterBox({
//     Key? key,
//     required this.onChange,
//     required this.productOptionValue,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 100,
//       child: Column(
//         children: [
//           SizedBox(
//             width: 150,
//             height: 90,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: MediaWidget(
//                 // mediaId: productOptionValue.media,
//                 onChange: () {
//                   onChange(productOptionValue);
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//                 onTap: () {
//                   onChange(productOptionValue);
//                 },
//                 child: UpText(productOptionValue.name)),
//           ),
//         ],
//       ),
//     );
//   }
// }
