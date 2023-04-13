import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ChefPage extends StatefulWidget {
  const ChefPage({Key? key}) : super(key: key);

  @override
  State<ChefPage> createState() => _ChefPageState();
}

class _ChefPageState extends State<ChefPage> {
  List<OrderStatusType> orderStausTypes = [];
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
          return StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 10))
                .asyncMap((i) => OrderService.getOrders()),
            builder: (BuildContext context, snapshot) {
              if (orderStausTypes.isNotEmpty &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                {
                  return Column(children: [
                    ...snapshot.data!.map((e) => Text(e.id.toString())).toList()
                  ]);
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
