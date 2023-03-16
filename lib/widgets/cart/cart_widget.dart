import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/cart/empty_cart.dart';
import 'package:shop/widgets/counter.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  double subtotal = 0;
  double serviceCharges = 0.5;
  calculatesubtotal(List<CartItem> cartItems) {
    subtotal = cartItems
        .map((e) => (getPrice(e)))
        .reduce((value, subtotalPrice) => value + subtotalPrice);
  }

  double getPrice(CartItem item) {
    return item.selectedVariation != null &&
            item.selectedVariation!.price != null
        ? (item.selectedVariation!.price! * item.quantity)
        : (item.product!.price! * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.cart.items.isNotEmpty && subtotal == 0) {
          calculatesubtotal(state.cart.items);
        }
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
                            .asMap()
                            .entries
                            .map((item) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DeleteCounter(
                                      onChange: (quantity) {
                                        if (quantity == -1) {
                                          CartCubit cart =
                                              context.read<CartCubit>();
                                          cart.removeItem(
                                            item.key,
                                          );
                                        } else {
                                          try {
                                            CartCubit cart =
                                                context.read<CartCubit>();
                                            cart.updateQuantity(
                                                item.key, quantity);
                                          } catch (e) {
                                            debugPrint(e.toString());
                                          }
                                        }
                                      },
                                      defaultValue: item.value.quantity,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          UpText(
                                            item.value.product!.name,
                                            style: UpStyle(
                                              textSize: 18,
                                              textWeight: FontWeight.bold,
                                            ),
                                          ),
                                          UpText(
                                              style: UpStyle(
                                                textColor: UpConfig.of(context)
                                                    .theme
                                                    .primaryColor[500],
                                              ),
                                              "${item.value.selectedVariation != null ? item.value.selectedVariation!.name : ''}")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "£ ${getPrice(item.value)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
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
                          children: [
                            const Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text("Sub subtotal"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("£ $subtotal"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text("Service Charge"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("£ $serviceCharges"),
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
                          children: [
                            const Expanded(
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
                                "${subtotal + serviceCharges}",
                                style: const TextStyle(
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
