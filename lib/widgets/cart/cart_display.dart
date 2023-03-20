// import 'package:flutter_up/locator.dart';
// import 'package:flutter_up/services/up_navigation.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shop/constants.dart';
// import 'package:shop/models/cart_item.dart';
// import 'package:shop/widgets/cart/empty_cart.dart';
// import 'package:shop/widgets/media/media_widget.dart';
// import 'package:shop/widgets/price/price.dart';
// import 'package:shop/widgets/store/store_cubit.dart';
// // import 'package:shop/widgets/variations/color_variation.dart';
// // import 'package:shop/widgets/variations/size_variation.dart';
// // import 'package:shop/widgets/variations/variation_selection_mode.dart';
// // import 'package:shop/widgets/variations/variation_types.dart';

// class CartDisplay extends StatelessWidget {
//   final List<CartItem> cartItem;
//   const CartDisplay({Key? key, required this.cartItem}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (cartItem.isEmpty) {
//       return const EmptyCart();
//     }

//     double total;
//     total = cartItem
//         .map((e) => ((getPrice(e.product)) * e.quantity))
//         .reduce((value, totalPrice) => value + totalPrice);
//     return Container(
//         width: 600,
//         // height: height,
//         decoration: const BoxDecoration(
//           border: Border(
//             left: BorderSide(width: 1.0, color: Colors.grey),
//           ),
//         ),
//         child: Column(
//           children: [
//             Column(
//                 children: cartItem.map((e) {
//               return _cartItemsList(context, e);
//             }).toList()),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: 400,
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(width: 1.0, color: Colors.grey),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [const Text("SubTotal : "), Text("$total")],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text("Shipment : "),
//                           Text("Calculated at next step ")
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: 400,
//                 // decoration: const BoxDecoration(
//                 //   border: Border(
//                 //     bottom: BorderSide(width: 1.0, color: Colors.grey),
//                 //   ),
//                 // ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [const Text("Total : "), Text("$total")],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ));
//   }
// }

// Widget _cartItemsList(BuildContext context, CartItem item) {
//   // ProductOptionValue? sizeVariation;
//   // ProductOptionValue? colorVariation;

//   return BlocConsumer<StoreCubit, StoreState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         // sizeVariation = state.attributeValues!
//         //     .map((e) => e)
//         //     .where((element) =>
//         //         element.id ==
//         //         item.selectedVariationsValues[VariationTypes.size.index])
//         //     .first;
//         // colorVariation = state.attributeValues!
//         //     .map((e) => e)
//         //     .where((element) =>
//         //         element.id ==
//         //         item.selectedVariationsValues[VariationTypes.color.index])
//         //     .first;

//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             width: 400,
//             height: 200,
//             // color: const Color.fromARGB(255, 204, 202, 202),
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(width: 1.0, color: Colors.grey),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: MediaWidget(
//                         width: 70,
//                         height: 70,
//                         mediaId: item.product.thumbnail,
//                         onChange: () => ServiceManager<UpNavigationService>()
//                             .navigateToNamed(
//                           Routes.product,
//                           queryParams: {
//                             'productId': '${item.product.id}',
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 30, 10, 0),
//                             child: Text(item.product.name,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headline6!
//                                     .copyWith(color: Colors.black)),
//                           ),
//                           // Visibility(
//                           //   visible: item.selectedVariationsValues.isNotEmpty,
//                           //   child: Row(
//                           //     mainAxisAlignment: MainAxisAlignment.start,
//                           //     crossAxisAlignment: CrossAxisAlignment.start,
//                           //     children: [
//                           //       SizeVariationWidget(
//                           //         sizeVariations: sizeVariation != null
//                           //             ? [sizeVariation!]
//                           //             : [],
//                           //         mode: VariationSelectionMode.cart,
//                           //         selectedValues: [sizeVariation?.id ?? -1],
//                           //       ),
//                           //       ColorVariationWidget(
//                           //         colorVariations: colorVariation != null
//                           //             ? [colorVariation!]
//                           //             : [],
//                           //         mode: VariationSelectionMode.cart,
//                           //         selectedValues: [colorVariation?.id ?? -1],
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//                           Text("Quantity : ${item.quantity}",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline6!
//                                   .copyWith(color: Colors.black)),
//                         ]),
//                   ),
//                   Center(
//                     child: Text("${(getPrice(item.product)) * item.quantity}",
//                         style: Theme.of(context)
//                             .textTheme
//                             .headline6!
//                             .copyWith(color: Colors.black)),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       });
// }
