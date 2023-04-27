import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/order.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class CartReceipt extends StatefulWidget {
  final List<dynamic> orderDetails;
  final Order? order;
  const CartReceipt({
    Key? key,
    this.order,
    required this.orderDetails,
  }) : super(key: key);

  @override
  State<CartReceipt> createState() => _CartReceiptState();
}

class _CartReceiptState extends State<CartReceipt> {
  List<AttributeValue> attributeValues = [];
  double subtotal = 0;
  double serviceCharges = 0.5;
  calculatesubtotal() {
    subtotal = widget.orderDetails
        .map((e) => (getPrice(e)))
        .reduce((value, subtotalPrice) => value + subtotalPrice);
    subtotal;
  }

  @override
  void initState() {
    super.initState();
  }

  List<OrderStatusType> orderStausTypes = [];
  double getPrice(Map<String, dynamic> item) {
    return item["Combo"] != null && item["Combo"]["Price"] != null
        ? (item["Combo"]["Price"] * item["Quantity"])
        : item["Variations"] != null && item["Variations"]["Price"] != null
            ? (item["Variations"]["Price"] * item["Quantity"])
            : ((item["Product"]["Price"] ?? 0.0) * item["Quantity"]);
  }

  String getAttributeName(MapEntry<String, dynamic> entry) {
    String name = "";
    if (attributeValues.any((element) => element.id == entry.value)) {
      name = attributeValues
          .where((element) => element.id == entry.value)
          .first
          .name;
    }
    return name;
  }

  _orderDetail(List<dynamic> orderDetail) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.order != null && widget.order!.userInfo != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Row(
                        children: [
                          UpText(
                            "Name: ",
                            style: UpStyle(
                              textSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                          UpText(
                            widget.order!.userInfo!["Name"],
                            style: UpStyle(
                              textSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Row(
                        children: [
                          UpText(
                            "Address: ",
                            style: UpStyle(
                              textSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                          UpText(
                            widget.order!.userInfo!["Address"],
                            style: UpStyle(
                              textSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Row(
                        children: [
                          UpText(
                            "PhoneNo: ",
                            style: UpStyle(
                              textSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                          UpText(
                            widget.order!.userInfo!["PhoneNo"],
                            style: UpStyle(
                              textSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UpText(
              "Order Detail",
              type: UpTextType.heading6,
            ),
          ),
          ...orderDetail
              .map((item) => Column(
                    children: [
                      const SizedBox(height: 10),
                      item["Type"] != null && item["Type"] == "Product"
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                  visible: item["Product"] != null,
                                  child: Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        UpText(
                                          ("${item["Quantity"]} x ${item["Product"]["Name"]}"),
                                          style: UpStyle(
                                            textSize: 18,
                                            textWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // variation
                                        item["Variations"] != null &&
                                                item["Variations"]["Option"] !=
                                                    null
                                            ? Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  ...item["Variations"]
                                                          ["Option"]
                                                      .entries
                                                      .map((entry) => UpText(
                                                          style: UpStyle(
                                                            textColor: UpConfig
                                                                    .of(context)
                                                                .theme
                                                                .primaryColor[500],
                                                          ),
                                                          (item["Variations"]["Option"] as Map<
                                                                          String,
                                                                          dynamic>)
                                                                      .values
                                                                      .last ==
                                                                  entry.value
                                                              ? getAttributeName(
                                                                  entry)
                                                              : "${getAttributeName(entry)}, "))
                                                ],
                                              )
                                            : const SizedBox(),

                                        // product attributes
                                        item["SelectedProductAttributes"] !=
                                                null
                                            ? Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  ...item["SelectedProductAttributes"]
                                                      .entries
                                                      .map(
                                                        (entry) => UpText(
                                                            style: UpStyle(
                                                              textColor: UpConfig
                                                                      .of(context)
                                                                  .theme
                                                                  .primaryColor[500],
                                                            ),
                                                            (item["SelectedProductAttributes"] as Map<
                                                                            String,
                                                                            dynamic>)
                                                                        .values
                                                                        .last ==
                                                                    entry.value
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
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "£ ${getPrice(item)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      // combo details

                      item["Type"] != null && item["Type"] == "Combo" ||
                              item["Type"] == "combo"
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      UpText(
                                        ("${item["Quantity"]} x ${item["Combo"]["Name"]}"),
                                        style: UpStyle(
                                          textSize: 18,
                                          textWeight: FontWeight.bold,
                                        ),
                                      ),
                                      item["ComboItems"] != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...item["ComboItems"].map(
                                                  (cItem) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      UpText(
                                                          "1 x ${cItem["Product"]["Name"]}"),

                                                      cItem["Variations"] !=
                                                                  null &&
                                                              cItem["Variations"]
                                                                      [
                                                                      "Option"] !=
                                                                  null
                                                          ? Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              children: [
                                                                ...cItem["Variations"]
                                                                        [
                                                                        "Option"]
                                                                    .entries
                                                                    .map((entry) =>
                                                                        UpText(
                                                                            style:
                                                                                UpStyle(
                                                                              textColor: UpConfig.of(context).theme.primaryColor[500],
                                                                            ),
                                                                            (cItem["Variations"]["Option"] as Map<String, dynamic>).values.last == entry.value
                                                                                ? getAttributeName(entry)
                                                                                : "${getAttributeName(entry)}, "))
                                                              ],
                                                            )
                                                          : const SizedBox(),

                                                      // product attributes
                                                      cItem["SelectedProductAttributes"] !=
                                                                  null &&
                                                              (cItem["SelectedProductAttributes"]
                                                                      as Map<
                                                                          String,
                                                                          dynamic>)
                                                                  .isNotEmpty
                                                          ? Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              children: [
                                                                ...cItem[
                                                                        "SelectedProductAttributes"]
                                                                    .entries
                                                                    .map(
                                                                      (entry) => UpText(
                                                                          style: UpStyle(
                                                                            textColor:
                                                                                UpConfig.of(context).theme.primaryColor[500],
                                                                          ),
                                                                          (cItem["SelectedProductAttributes"] as Map<String, dynamic>).values.last == entry.value ? getAttributeName(entry) : "${getAttributeName(entry)}, "),
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
                                  child: Text(
                                    "£ ${getPrice(item)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ))
              .toList(),
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
            color: UpConfig.of(context).theme.primaryColor.shade50,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "£ ${subtotal + serviceCharges}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 2,
            color: UpConfig.of(context).theme.primaryColor.shade50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.orderStatusType != null &&
            state.orderStatusType!.isNotEmpty) {
          orderStausTypes = state.orderStatusType!.toList();
        }
        if (state.attributeValues != null &&
            state.attributeValues!.isNotEmpty) {
          attributeValues = state.attributeValues!.toList();
        }
        if (widget.orderDetails.isNotEmpty) {
          calculatesubtotal();
        }

        return _orderDetail(widget.orderDetails);
      },
    );
  }
}
