import 'dart:convert';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/customer_info.dart';
import 'package:shop/services/customer_profile/customer_profile_services.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/cart/cart_mob_complete.dart';
import 'package:shop/widgets/cart/cart_widget.dart';
import 'package:shop/widgets/footer/food_footer.dart';
import 'package:shop/widgets/store/store_cubit.dart';

int currentStep = 0;
bool isComplete = false;

class FoodCartMobPage extends StatefulWidget {
  const FoodCartMobPage({
    super.key,
  });

  @override
  State<FoodCartMobPage> createState() => _FoodCartMobPageState();
}

class _FoodCartMobPageState extends State<FoodCartMobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FoodAppbar(),
      bottomNavigationBar: const FooterWidget(),
      body: Apiraiser.authentication.isSignedIn()
          ? FutureBuilder<CustomerProfile?>(
              future: CustomerProfileService.getcustomerProfile(),
              builder: (BuildContext context,
                  AsyncSnapshot<CustomerProfile?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return UserDetails(
                    customerProfile: snapshot.data,
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: UpCircularProgress(
                      width: 20,
                      height: 20,
                    ),
                  );
                }
              },
            )
          : ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.loginSignup),
    );
  }
}

class UserDetails extends StatefulWidget {
  final CustomerProfile? customerProfile;
  const UserDetails({super.key, required this.customerProfile});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  int? status;
  List<CartItem> cartItems = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController phnNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Cart'),
          content: const CartWidget(isVisible: false),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Payment'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UpText(
                "Need to know your details",
                type: UpTextType.heading4,
              ),
              const SizedBox(height: 8),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: [
                  SizedBox(
                    width: 300,
                    child: UpTextField(
                      label: 'YOUR NAME',
                      controller: nameController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: UpTextField(
                      label: 'TELEPHONE',
                      controller: phnNoController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: UpTextField(
                      label: 'EMAIL',
                      controller: emailController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: UpTextField(
                      label: 'ADDRESS',
                      controller: addressController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const UpText(
                "Pay by cash or card",
                type: UpTextType.heading4,
              ),
              const SizedBox(height: 8),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: [
                  UpButton(
                    onPressed: () {},
                    text: "CASH",
                    icon: Icons.money,
                    style: UpStyle(buttonWidth: 300),
                  ),
                  UpButton(
                    onPressed: () {},
                    text: "CARD",
                    icon: Icons.credit_card,
                    style: UpStyle(buttonWidth: 300),
                  ),
                ],
              )
            ],
          ),
        ),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: const Text('Confirm Details'),
            content: Container()),
      ];

  _createOrder() async {
    if (cartItems.isNotEmpty &&
        Apiraiser.authentication.getCurrentUser() != null &&
        status != null) {
      List<Map<String, dynamic>> items =
          cartItems.map((e) => e.toJson()).toList();
      Map<String, dynamic> map = {
        "OrderDetails": jsonEncode(items),
        "User": Apiraiser.authentication.getCurrentUser()!.id!,
        "Status": status!
      };
      APIResult? result = await OrderService.createOrder(map);
      if (result != null) {
        if (result.success) {
          ServiceManager<UpNavigationService>()
              .navigateToNamed(Routes.orderStatus);
        } else {
          const SizedBox();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.customerProfile != null) {
      _initialize();
    }
    widget.customerProfile;
  }

  _initialize() {
    if (widget.customerProfile?.primaryInfo != null) {
      nameController.text =
          widget.customerProfile?.primaryInfo!["FirstName"] ?? "";
      phnNoController.text =
          widget.customerProfile?.primaryInfo!["PhoneNo"] ?? "";
      addressController.text =
          widget.customerProfile?.primaryInfo!["Address"] ?? "";
      emailController.text =
          widget.customerProfile?.primaryInfo!["Email"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.orderStatusType != null &&
            state.orderStatusType!.isNotEmpty) {
          if (state.orderStatusType!
              .any((element) => element.name.toLowerCase() == "waiting")) {
            status = state.orderStatusType!
                .where((element) => element.name.toLowerCase() == "waiting")
                .first
                .id;
          }
        }
        return BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.cart.items.isNotEmpty) {
              cartItems = state.cart.items;
            }
            return isComplete
                ? CartMobComplete(
                    onChange: (isC) {
                      isComplete = false;
                      currentStep = 0;
                      setState(() {});
                    },
                  )
                : Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color.fromRGBO(200, 16, 46, 1.0),
                      ),
                    ),
                    child: Stepper(
                      type: StepperType.horizontal,
                      currentStep: currentStep,
                      steps: getSteps(),
                      // onStepTapped: (step) => setState(() {
                      //   currentStep = step;
                      // }),
                      onStepContinue: () {
                        final isLastStep = currentStep == getSteps().length - 1;
                        if (isLastStep) {
                          setState(() {
                            isComplete = true;
                          });
                        } else {
                          setState(() => currentStep += 1);
                        }
                      },
                      onStepCancel: () {
                        if (currentStep == 0) {
                          // print('Goto Food List');
                        } else {
                          setState(() => currentStep -= 1);
                        }
                        // currentStep == 0 ? null : () => setState(() => currentStep -= 1);
                      },
                      controlsBuilder: (context, details) {
                        final isLastStep = currentStep == getSteps().length - 1;
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text(isLastStep ? "CONFIRM" : "NEXT"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (currentStep != 0)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: details.onStepCancel,
                                    child: const Text("BACK"),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ));
          },
        );
      },
    );
  }
}
