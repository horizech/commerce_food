import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/widgets/cart/cart_recipt.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ChefPage extends StatefulWidget {
  const ChefPage({Key? key}) : super(key: key);

  @override
  State<ChefPage> createState() => _ChefPageState();
}

class _ChefPageState extends State<ChefPage> {
  List<AttributeValue> attributeValues = [];
  int seconds = 2;
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
    List<Map<String, dynamic>> orderDetailsMap = [];
    for (var element in orderDetail) {
      orderDetailsMap.add(element as Map<String, dynamic>);
    }
    return Column(
      children: [
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...orderDetailsMap
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
                                      item["SelectedVariation"] != null &&
                                              item["SelectedVariation"]
                                                      ["Options"] !=
                                                  null
                                          ? Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                item["SelectedVariation"]
                                                        ["Options"]
                                                    .entries
                                                    .map((entry) => UpText(
                                                        style: UpStyle(
                                                          textColor: UpConfig
                                                                  .of(context)
                                                              .theme
                                                              .primaryColor[500],
                                                        ),
                                                        item["SelectedVariation"]
                                                                        [
                                                                        "Options"]
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
                                      item["SelectedProductAttributes"] != null
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
                                                          item["SelectedProductAttributes"]
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
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "£ ${getPrice(item)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
    return Scaffold(
      appBar: AppBar(
        title: const UpText("chef"),
      ),
      bottomNavigationBar: const FooterWidget(),
      body: BlocConsumer<StoreCubit, StoreState>(
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
          return StreamBuilder(
            stream: Stream.periodic(Duration(seconds: seconds))
                .asyncMap((i) => OrderService.getOrders()),
            builder: (BuildContext context, snapshot) {
              if (orderStausTypes.isNotEmpty &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                {
                  if (seconds == 2) {
                    seconds = 20;
                  }
                  return Column(
                    children: [
                      ...snapshot.data!
                          .map((e) => Column(
                                children: [
                                  UpExpansionTile(
                                    titleWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("#${e.id.toString()}"),
                                        Text(
                                          orderStausTypes
                                              .where((element) =>
                                                  element.id == e.status)
                                              .first
                                              .name,
                                        )
                                      ],
                                    ),
                                    children: [
                                      CartReceipt(
                                          orderDetails:
                                              e.orderDetail["CartItems"]
                                                  as List<dynamic>)
                                    ],
                                  ),
                                ],
                              ))
                          .toList()
                    ],
                  );
                }
              } else {
                return const UpCircularProgress();
              }
            },
          );
        },
      ),
    );
  }
}