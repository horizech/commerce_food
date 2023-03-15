import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:shop/constants.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/cart/empty_cart.dart';
import 'package:shop/widgets/counter.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state.cart.items.isNotEmpty)
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color:
                            UpConfig.of(context).theme.primaryColor.shade100),
                    borderRadius: BorderRadius.circular(4)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Cart",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...state.cart.items
                            .map((e) => Row(
                                  children: [
                                    Counter(onChange: (count) {}),
                                    Expanded(
                                      flex: 6,
                                      child: Text(e.product.name),
                                    ),
                                    const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "£ 10",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                        // Expanded(
                        //   flex: 2,
                        //   child: InputQty(
                        //     isIntrinsicWidth: false,
                        //     showMessageLimit: false,
                        //     maxVal: 99,
                        //     initVal: 0,
                        //     steps: 1,
                        //     minVal: 0,
                        //     borderShape: BorderShapeBtn.none,
                        //     boxDecoration: const BoxDecoration(),
                        //     minusBtn: const Icon(
                        //       Icons.remove,
                        //       size: 16,
                        //     ),
                        //     plusBtn: const Icon(
                        //       Icons.add,
                        //       size: 16,
                        //     ),
                        //     btnColor1: UpConfig.of(context).theme.primaryColor,
                        //     onQtyChanged: (val) {
                        //       if (kDebugMode) {
                        //         print(val);
                        //       }
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 2,
                      color: UpConfig.of(context).theme.primaryColor.shade50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Bill Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text("Sub Total"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("£ 10"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: const [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text("Service Charge"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("£ 0.5"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 2,
                          color:
                              UpConfig.of(context).theme.primaryColor.shade50,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "£10.5",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: UpButton(
                        onPressed: () {
                          ServiceManager<UpNavigationService>()
                              .navigateToNamed(Routes.foodCartPage);
                        },
                        text: "GO TO CHECKOUT",
                      ),
                    )
                  ],
                ),
              )
            : const EmptyCart();
      },
    );
  }
}
