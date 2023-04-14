import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/preparing_food.dart';
import 'package:shop/widgets/cart/waiting.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
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
                      ? const WaitingForChef()
                      : const PreparingFood();
                }
              } else {
                return const UpCircularProgress();

                // return const SizedBox(child: UpText("There is no order"));
              }
            },
          );
        },
      ),
    );
  }
}
