import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/order.dart';
import 'package:shop/models/order_status_type.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/widgets/cart/cart_recipt.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ChefPage extends StatefulWidget {
  const ChefPage({Key? key}) : super(key: key);

  @override
  State<ChefPage> createState() => _ChefPageState();
}

class _ChefPageState extends State<ChefPage> {
  List<AttributeValue> attributeValues = [];
  int seconds = 2;
  List<OrderStatusType> orderStausTypes = [];
  int? waitingStatusId;
  int? preparingStatusId;
  int? preparedStatusId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpAppBar(
        titleWidget: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpIcon(
                icon: Icons.restaurant_menu,
                style: UpStyle(iconColor: Colors.white, iconSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpText(
                "Chef",
                style: UpStyle(textColor: Colors.white, textSize: 20),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Apiraiser.authentication.signOut();
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.loginSignup);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterWidget(),
      body: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.orderStatusType != null &&
              state.orderStatusType!.isNotEmpty) {
            orderStausTypes = state.orderStatusType!.toList();
            if (orderStausTypes.any((element) => element.name == "Waiting")) {
              waitingStatusId = orderStausTypes
                  .where((element) => element.name == "Waiting")
                  .first
                  .id;
            }
            if (orderStausTypes.any((element) => element.name == "Preparing")) {
              preparingStatusId = orderStausTypes
                  .where((element) => element.name == "Preparing")
                  .first
                  .id;
            }
            if (orderStausTypes.any((element) => element.name == "Prepared")) {
              preparedStatusId = orderStausTypes
                  .where((element) => element.name == "Prepared")
                  .first
                  .id;
            }
          }
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            attributeValues = state.attributeValues!.toList();
          }
          return StreamBuilder(
            stream: Stream.periodic(Duration(seconds: seconds)).asyncMap((i) =>
                OrderService.getOrders(waitingStatusId, preparingStatusId)),
            builder: (BuildContext context, snapshot) {
              if (orderStausTypes.isNotEmpty &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                {
                  if (seconds == 2) {
                    seconds = 20;
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ...snapshot.data!
                            .asMap()
                            .entries
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      left: 40,
                                      right: 40),
                                  child: UpExpansionTile(
                                    initiallyExpanded: false,
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    expandedAlignment: Alignment.center,
                                    titleWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("#${e.value.id.toString()}"),
                                        Text(
                                          orderStausTypes
                                              .where((element) =>
                                                  element.id == e.value.status)
                                              .first
                                              .name,
                                        )
                                      ],
                                    ),
                                    children: [
                                      CartReceipt(
                                          orderDetails:
                                              e.value.orderDetail["CartItems"]
                                                  as List<dynamic>),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ChefOrderStatusUpdate(
                                          order: e.value,
                                          preparingStatusId: preparingStatusId,
                                          status: e.value.status,
                                          waitingStatusId: waitingStatusId,
                                          preparedStatusId: preparedStatusId,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()
                      ],
                    ),
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

class ChefOrderStatusUpdate extends StatefulWidget {
  final int status;
  final int? waitingStatusId;
  final int? preparingStatusId;
  final int? preparedStatusId;

  final Order order;

  const ChefOrderStatusUpdate({
    Key? key,
    required this.status,
    this.preparingStatusId,
    this.waitingStatusId,
    this.preparedStatusId,
    required this.order,
  }) : super(key: key);

  @override
  State<ChefOrderStatusUpdate> createState() => _ChefOrderStatusUpdateState();
}

class _ChefOrderStatusUpdateState extends State<ChefOrderStatusUpdate> {
  double minutes = 20;
  _updateStatus() async {
    if (widget.preparingStatusId != null &&
        widget.waitingStatusId != null &&
        widget.status == widget.waitingStatusId) {
      Map<String, dynamic> map = {
        "Id": widget.order.id,
        "OrderDetail": widget.order.orderDetail,
        "User": widget.order.user,
        "Status": widget.preparingStatusId!,
        "Message": widget.order.message,
        "Rider": widget.order.rider,
        "Chef": Apiraiser.authentication.getCurrentUser() != null
            ? Apiraiser.authentication.getCurrentUser()!.id
            : null,
        "EstimatedTime": DateTime.now()
            .add(
              Duration(
                minutes: (minutes.toInt() + 20),
              ),
            )
            .toIso8601String()
      };
      APIResult? apiResult =
          await OrderService.updateOrder(map, widget.order.id!);
      if (apiResult != null && apiResult.success) {
        if(mounted){
        UpToast().showToast(context: context, text: "Status updated");}
      }
    } else if (widget.preparingStatusId != null &&
        widget.waitingStatusId != null &&
        widget.preparedStatusId != null &&
        widget.status == widget.preparingStatusId) {
      Map<String, dynamic> map = {
        "Id": widget.order.id,
        "OrderDetail": widget.order.orderDetail,
        "User": widget.order.user,
        "Status": widget.preparedStatusId!,
        "Message": widget.order.message,
        "Rider": widget.order.rider,
        "Chef": widget.order.chef,
        "EstimatedTime": DateTime.now()
            .add(
              const Duration(
                minutes: 20,
              ),
            )
            .toIso8601String()
      };
      APIResult? apiResult =
          await OrderService.updateOrder(map, widget.order.id!);
      if (apiResult != null && apiResult.success) {
        if(mounted){
        UpToast().showToast(context: context, text: "Status updated");}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: widget.status == widget.waitingStatusId,
          child: SleekCircularSlider(
            min: 0,
            max: 60,
            appearance: CircularSliderAppearance(
                startAngle: 270,
                angleRange: 360,
                size: 100,
                customColors: CustomSliderColors(
                  trackColor: UpConfig.of(context).theme.primaryColor.shade100,
                  progressBarColor: UpConfig.of(context).theme.primaryColor,
                )),
            initialValue: minutes,
            onChange: (double value) {
              minutes = value.floorToDouble();
              setState(() {});
            },
            innerWidget: (percentage) {
              return Center(child: UpText("$minutes Minutes"));
            },
          ),
        ),
        Visibility(
          visible: widget.waitingStatusId != null &&
              widget.status == widget.waitingStatusId,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: UpButton(
                onPressed: () {
                  _updateStatus();
                },
                text: "Preparing",
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.preparingStatusId != null &&
              widget.status == widget.preparingStatusId,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: UpButton(
                onPressed: () {
                  _updateStatus();
                },
                text: "Completed",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
