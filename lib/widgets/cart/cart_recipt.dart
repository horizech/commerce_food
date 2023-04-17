import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class CartReceipt extends StatefulWidget {
  final List<dynamic> orderDetails;
  const CartReceipt({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  State<CartReceipt> createState() => _CartReceiptState();
}

class _CartReceiptState extends State<CartReceipt> {
  @override
  void initState() {
    super.initState();
    widget.orderDetails;
  }

  List<AttributeValue> attributeValues = [];
  List<OrderStatusType> orderStausTypes = [];
  double getPrice(Map<String, dynamic> item) {
    return item["Combo"] != null && item["Combo"]["Price"] != null
        ? (item["Combo"]["Price"] * int.parse(item["Quantity"]))
        : item["SelectedVariation"] != null &&
                item["SelectedVariation"]["Price"] != null
            ? (item["SelectedVariation"]["Price"] * int.parse(item["Quantity"]))
            : ((item["Product"]["Price"] ?? 0.0) * int.parse(item["Quantity"]));
  }

  String getAttributeName(MapEntry<String, dynamic> entry) {
    String name = "";
    name = attributeValues
        .where((element) => element.id == entry.value)
        .first
        .name;
    return name;
  }

  _orderDetail(List<dynamic> orderDetail) {
    // List<Map<String, dynamic>> orderDetailsMap = [];
    // for (var element in orderDetail) {
    //   orderDetailsMap.add(element as Map<String, dynamic>);
    // }
    return Column(
      children: [
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...orderDetail
                  .map((item) => Column(
                        children: [
                          Visibility(
                            visible: item["Type"] == "Product",
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      UpText(
                                        ("${item["Quantity"]}x ${(item["Product"]["Name"])}"),
                                        style: UpStyle(
                                          textSize: 18,
                                          textWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // variation
                                      // item["SelectedVariation"] != null &&
                                      //     item["SelectedVariation"]
                                      //             ["Options"] !=
                                      //         null
                                      // ? Wrap(
                                      //     crossAxisAlignment:
                                      //         WrapCrossAlignment.center,
                                      //     children: [
                                      //       item["SelectedVariation"]
                                      //               ["Options"]
                                      //           .entries
                                      //           .map((entry) => UpText(
                                      //               style: UpStyle(
                                      //                 textColor: UpConfig
                                      //                         .of(context)
                                      //                     .theme
                                      //                     .primaryColor[500],
                                      //               ),
                                      //               item["SelectedVariation"]
                                      //                               [
                                      //                               "Options"]
                                      //                           .values
                                      //                           .last ==
                                      //                       entry.value
                                      //                   ? getAttributeName(
                                      //                       entry)
                                      //                   : "${getAttributeName(entry)}, "))
                                      //     ],
                                      //   )
                                      // : const SizedBox(),

                                      // product attributes
                                      // item["SelectedProductAttributes"] != null
                                      //     ? Wrap(
                                      //         crossAxisAlignment:
                                      //             WrapCrossAlignment.center,
                                      //         children: [
                                      //           ...item["SelectedProductAttributes"]
                                      //               .entries
                                      //               .map(
                                      //                 (entry) => UpText(
                                      //                     style: UpStyle(
                                      //                       textColor: UpConfig
                                      //                               .of(context)
                                      //                           .theme
                                      //                           .primaryColor[500],
                                      //                     ),
                                      //                     item["SelectedProductAttributes"]
                                      //                                 .last ==
                                      //                             entry.value
                                      //                         ? getAttributeName(
                                      //                             entry)
                                      //                         : "${getAttributeName(entry)}, "),
                                      //               )
                                      //         ],
                                      //       )
                                      //     : const SizedBox(),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   flex: 2,
                                //   child: Text(
                                //     "£ ${getPrice(item)}",
                                //     style: const TextStyle(
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ],
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

        return _orderDetail(widget.orderDetails);
      },
    );
  }
}
