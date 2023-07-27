import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/cart/empty_cart.dart';
import 'package:shop/widgets/counter.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class CartWidget extends StatefulWidget {
  final bool isVisible;
  const CartWidget({
    super.key,
    required this.isVisible,
  });

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
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
              return (state.cart.items.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: UpCard(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: UpText(
                                "Cart",
                                style: UpStyle(textSize: 24),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // products details
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ...state.cart.items
                                      .asMap()
                                      .entries
                                      .where((element) =>
                                          element.value.type == "Product")
                                      .map((item) => Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DeleteCounter(
                                                onChange: (quantity) {
                                                  if (quantity == -1) {
                                                    CartCubit cart = context
                                                        .read<CartCubit>();
                                                    cart.removeItem(
                                                      item.key,
                                                    );
                                                  } else {
                                                    try {
                                                      CartCubit cart = context
                                                          .read<CartCubit>();
                                                      cart.updateQuantity(
                                                          item.key, quantity);
                                                    } catch (e) {
                                                      debugPrint(e.toString());
                                                    }
                                                  }
                                                },
                                                defaultValue:
                                                    item.value.quantity,
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
                                                      ),
                                                    ),
                                                    // variation
                                                    item.value.selectedVariation !=
                                                                null &&
                                                            item
                                                                .value
                                                                .selectedVariation!
                                                                .options
                                                                .isNotEmpty
                                                        ? Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              ...item
                                                                  .value
                                                                  .selectedVariation!
                                                                  .options
                                                                  .entries
                                                                  .map((entry) => UpText(item
                                                                              .value
                                                                              .selectedVariation!
                                                                              .options
                                                                              .values
                                                                              .last ==
                                                                          entry
                                                                              .value
                                                                      ? getAttributeName(
                                                                          entry)
                                                                      : "${getAttributeName(entry)}, "))
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    // product attributes
                                                    item.value.selectedProductAttributes !=
                                                                null &&
                                                            item
                                                                .value
                                                                .selectedProductAttributes!
                                                                .isNotEmpty
                                                        ? Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              ...item
                                                                  .value
                                                                  .selectedProductAttributes!
                                                                  .entries
                                                                  .map(
                                                                (entry) => UpText(item
                                                                            .value
                                                                            .selectedProductAttributes!
                                                                            .values
                                                                            .last ==
                                                                        entry
                                                                            .value
                                                                    ? getAttributeName(
                                                                        entry)
                                                                    : "${getAttributeName(entry)}, "),
                                                              )
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: UpText(
                                                  "£ ${getPrice(item.value)}",
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),

                            // combo details
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...state.cart.items
                                    .asMap()
                                    .entries
                                    .where((element) =>
                                        element.value.combo != null)
                                    .map((combo) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DeleteCounter(
                                              onChange: (quantity) {
                                                if (quantity == -1) {
                                                  CartCubit cart =
                                                      context.read<CartCubit>();
                                                  cart.removeItem(
                                                    combo.key,
                                                  );
                                                } else {
                                                  try {
                                                    CartCubit cart = context
                                                        .read<CartCubit>();
                                                    cart.updateQuantity(
                                                        combo.key, quantity);
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                  }
                                                }
                                              },
                                              defaultValue:
                                                  combo.value.quantity,
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
                                                    combo.value.combo!.name,
                                                    style: UpStyle(
                                                      textSize: 18,
                                                    ),
                                                  ),
                                                  combo.value.comboItems !=
                                                              null &&
                                                          combo
                                                              .value
                                                              .comboItems!
                                                              .isNotEmpty
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ...combo.value
                                                                .comboItems!
                                                                .map(
                                                              (cItem) => Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  UpText(
                                                                      "1 x ${cItem.product!.name}"),

                                                                  cItem.selectedVariation !=
                                                                              null &&
                                                                          cItem
                                                                              .selectedVariation!
                                                                              .options
                                                                              .isNotEmpty
                                                                      ? Wrap(
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.center,
                                                                          children: [
                                                                            ...cItem.selectedVariation!.options.entries.map((entry) => UpText(cItem.selectedVariation!.options.values.last == entry.value
                                                                                ? getAttributeName(entry)
                                                                                : "${getAttributeName(entry)}, "))
                                                                          ],
                                                                        )
                                                                      : const SizedBox(),

                                                                  // product attributes
                                                                  cItem.selectedProductAttributes !=
                                                                              null &&
                                                                          cItem
                                                                              .selectedProductAttributes!
                                                                              .isNotEmpty
                                                                      ? Wrap(
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.center,
                                                                          children: [
                                                                            ...cItem.selectedProductAttributes!.entries.map(
                                                                              (entry) => UpText(cItem.selectedProductAttributes!.values.last == entry.value ? getAttributeName(entry) : "${getAttributeName(entry)}, "),
                                                                            )
                                                                          ],
                                                                        )
                                                                      : const SizedBox(),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: UpText(
                                                "£ ${getPrice(combo.value)}",
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),

                            const SizedBox(height: 10),
                            Divider(
                              height: 2,
                              color:
                                  UpConfig.of(context).theme.baseColor.shade200,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: UpText("Bill Details",
                                  style: UpStyle(textSize: 24)),
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
                                        child: UpText("Sub subtotal"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: UpText("£ $subtotal"),
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
                                        child: UpText("Service Charge"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: UpText("£ $serviceCharges"),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  height: 2,
                                  color: UpConfig.of(context)
                                      .theme
                                      .baseColor
                                      .shade200,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: UpText(
                                          "Total",
                                          style: UpStyle(textSize: 24),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: UpText(
                                        "${subtotal + serviceCharges}",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Visibility(
                              visible: widget.isVisible,
                              child: Center(
                                child: UpButton(
                                  onPressed: () {
                                    ServiceManager<UpNavigationService>()
                                        .navigateToNamed(Routes.foodCartPage);
                                  },
                                  text: "GO TO CHECKOUT",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : const EmptyCart();
            },
          );
        });
  }
}
