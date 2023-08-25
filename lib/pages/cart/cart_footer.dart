import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class CartFooter extends StatefulWidget {
  const CartFooter({
    super.key,
  });

  @override
  State<CartFooter> createState() => _CartFooterState();
}

class _CartFooterState extends State<CartFooter> {
  List<AttributeValue> attributeValues = [];
  double subtotal = 0;
  double serviceCharges = 0.5;
  calculatesubtotal(List<CartItem> cartItems) {
    subtotal = cartItems
        .map((e) => (getPrice(e)))
        .reduce((value, subtotalPrice) => value + subtotalPrice);
    subtotal;
  }

  double getPrice(CartItem item) {
    return item.combo != null
        ? (item.combo!.price * item.quantity)
        : item.selectedVariation != null &&
                item.selectedVariation!.price != null
            ? (item.selectedVariation!.price! * item.quantity)
            : ((item.product!.price != null ? item.product!.price! : 0.0) *
                item.quantity);
  }

  String getAttributeName(MapEntry<String, dynamic> entry) {
    String name = "";
    name = attributeValues
        .where((element) => element.id == entry.value)
        .first
        .name;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (attributeValues.isEmpty) {
            if (state.attributeValues != null &&
                state.attributeValues!.isNotEmpty) {
              attributeValues = state.attributeValues!.toList();
            }
          }
          return BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.cart.items.isNotEmpty) {
                calculatesubtotal(state.cart.items);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    ServiceManager<UpNavigationService>()
                        .navigateToNamed(Routes.foodCartPage);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: <Color>[
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              Color.fromARGB(255, 222, 82, 82),
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                              UpConfig.of(context).theme.primaryColor,
                            ]),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    height: 50,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              UpText(state.cart.items.length <= 1
                                  ? "${state.cart.items.length}  Item  "
                                  : "${state.cart.items.length}  Items  "),
                              UpText(
                                "|  £ $subtotal",
                                style: UpStyle(textWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              UpText(
                                "View Cart",
                                style: UpStyle(textWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: UpIcon(
                                    icon: Icons.chevron_right_rounded,
                                    style: UpStyle(
                                        iconSize: 22, iconColor: Colors.black),
                                  ))
                            ],
                          )

                          // combo details
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
