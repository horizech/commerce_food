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

class RiderPage extends StatefulWidget {
  const RiderPage({Key? key}) : super(key: key);

  @override
  State<RiderPage> createState() => _RiderPageState();
}

class _RiderPageState extends State<RiderPage> {
  List<AttributeValue> attributeValues = [];
  int seconds = 2;
  List<OrderStatusType> orderStausTypes = [];
  int? deliveredStatusId;
  int? deliveringStatusId;
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
                icon: Icons.drive_eta,
                style: UpStyle(iconColor: Colors.white, iconSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpText(
                "Rider",
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
            if (orderStausTypes.any((element) => element.name == "Delivered")) {
              deliveredStatusId = orderStausTypes
                  .where((element) => element.name == "Delivered")
                  .first
                  .id;
            }
            if (orderStausTypes
                .any((element) => element.name == "Delivering")) {
              deliveringStatusId = orderStausTypes
                  .where((element) => element.name == "Delivering")
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
                OrderService.getOrders(preparedStatusId, deliveringStatusId)),
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
                                      left: 40.0,
                                      right: 40,
                                      top: 8.0,
                                      bottom: 8.0),
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
                                          order: e.value,
                                          orderDetails:
                                              e.value.orderDetail["CartItems"]
                                                  as List<dynamic>),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RiderOrderStatusUpdate(
                                          order: e.value,
                                          deliveringStatusId:
                                              deliveringStatusId,
                                          status: e.value.status,
                                          deliveredStatusId: deliveredStatusId,
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

class RiderOrderStatusUpdate extends StatefulWidget {
  final int status;
  final int? deliveredStatusId;
  final int? deliveringStatusId;
  final int? preparedStatusId;

  final Order order;

  const RiderOrderStatusUpdate({
    Key? key,
    required this.status,
    this.deliveringStatusId,
    this.deliveredStatusId,
    this.preparedStatusId,
    required this.order,
  }) : super(key: key);

  @override
  State<RiderOrderStatusUpdate> createState() => _RiderOrderStatusUpdateState();
}

class _RiderOrderStatusUpdateState extends State<RiderOrderStatusUpdate> {
  double minutes = 20;
  _updateStatus() async {
    if (widget.preparedStatusId != null &&
        widget.deliveringStatusId != null &&
        widget.status == widget.preparedStatusId) {
      Map<String, dynamic> map = {
        "Id": widget.order.id,
        "OrderDetail": widget.order.orderDetail,
        "User": widget.order.user,
        "Status": widget.deliveringStatusId!,
        "Message": widget.order.message,
        "Rider": Apiraiser.authentication.getCurrentUser() != null
            ? Apiraiser.authentication.getCurrentUser()!.id
            : null,
        "Chef": widget.order.chef,
        "EstimatedTime": DateTime.now()
            .add(
              Duration(
                minutes: (minutes.toInt()),
              ),
            )
            .toIso8601String()
      };
      APIResult? apiResult =
          await OrderService.updateOrder(map, widget.order.id!);
      if (apiResult != null && apiResult.success) {
        if (mounted) {
          UpToast().showToast(context: context, text: "Status updated");
        }
      }
    } else if (widget.deliveringStatusId != null &&
        widget.deliveredStatusId != null &&
        widget.status == widget.deliveringStatusId) {
      Map<String, dynamic> map = {
        "Id": widget.order.id,
        "OrderDetail": widget.order.orderDetail,
        "User": widget.order.user,
        "Status": widget.deliveredStatusId!,
        "Message": widget.order.message,
        "Rider": widget.order.rider,
        "Chef": widget.order.chef,
        "EstimatedTime": DateTime.now().toIso8601String()
      };
      APIResult? apiResult =
          await OrderService.updateOrder(map, widget.order.id!);
      if (apiResult != null && apiResult.success) {if(mounted){
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
          visible: widget.status == widget.preparedStatusId,
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
          visible: widget.preparedStatusId != null &&
              widget.status == widget.preparedStatusId,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: UpButton(
                onPressed: () {
                  _updateStatus();
                },
                text: "Start",
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.deliveringStatusId != null &&
              widget.status == widget.deliveringStatusId,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: UpButton(
                onPressed: () {
                  _updateStatus();
                },
                text: "Finish",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
