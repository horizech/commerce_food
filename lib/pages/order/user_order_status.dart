import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_recipt.dart';
import 'package:shop/widgets/order_status_widgets/cancelled_food.dart';
import 'package:shop/widgets/order_status_widgets/delivered_food.dart';
import 'package:shop/widgets/order_status_widgets/delivery_food.dart';
import 'package:shop/widgets/order_status_widgets/preparing_food.dart';
import 'package:shop/widgets/order_status_widgets/waiting.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class UserOrderStatus extends StatefulWidget {
  const UserOrderStatus({Key? key}) : super(key: key);

  @override
  State<UserOrderStatus> createState() => _UserOrderStatusState();
}

class _UserOrderStatusState extends State<UserOrderStatus> {
  int seconds = 1;
  int? orderId;

  List<OrderStatusType> orderStatusTypes = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FoodAppbar(),
      bottomNavigationBar: const FooterWidget(),
      body: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.orderStatusType != null &&
              state.orderStatusType!.isNotEmpty) {
            {
              orderStatusTypes = state.orderStatusType!.toList();
            }
          }
          return StreamBuilder(
            stream: Stream.periodic(Duration(seconds: seconds))
                .asyncMap((i) => OrderService.getOrder()),
            builder: (BuildContext context, snapshot) {
              if (orderStatusTypes.isNotEmpty &&
                  snapshot.data != null &&
                  snapshot.data!.id != null) {
                if (seconds == 1) {
                  seconds = 20;
                }

                {
                  return snapshot.data!.status ==
                          orderStatusTypes
                              .where((element) =>
                                  element.name.toLowerCase() == "waiting")
                              .first
                              .id
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const WaitingForChef(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CartReceipt(
                                    order: snapshot.data!,
                                    orderDetails:
                                        snapshot.data!.orderDetail["CartItems"]
                                            as List<dynamic>,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : snapshot.data!.status ==
                              orderStatusTypes
                                  .where((element) =>
                                      element.name.toLowerCase() ==
                                          "preparing" ||
                                      element.name.toLowerCase() == "prepared")
                                  .first
                                  .id
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const PreparingFood(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CartReceipt(
                                        order: snapshot.data!,
                                        orderDetails: snapshot
                                                .data!.orderDetail["CartItems"]
                                            as List<dynamic>,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : snapshot.data!.status ==
                                  orderStatusTypes
                                      .where((element) =>
                                          element.name.toLowerCase() ==
                                          "delivering")
                                      .first
                                      .id
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const DeliveryFood(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CartReceipt(
                                            order: snapshot.data!,
                                            orderDetails: snapshot.data!
                                                    .orderDetail["CartItems"]
                                                as List<dynamic>,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : snapshot.data!.status ==
                                      orderStatusTypes
                                          .where((element) =>
                                              element.name.toLowerCase() ==
                                              "delivered")
                                          .first
                                          .id
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            DeliveredFood(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : snapshot.data!.status ==
                                          orderStatusTypes
                                              .where((element) =>
                                                  element.name.toLowerCase() ==
                                                  "cancelled")
                                              .first
                                              .id
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                OrderCancelled(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
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
