import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/customer_info.dart';
import 'package:shop/models/media.dart';
import 'package:shop/services/customer_profile/customer_profile_services.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_mob_complete.dart';
import 'package:shop/widgets/cart/cart_widget.dart';
import 'package:shop/widgets/footer/food_footer.dart';

bool isComplete = false;

class FoodCartPage extends StatefulWidget {
  const FoodCartPage({super.key});

  @override
  State<FoodCartPage> createState() => _FoodCartPageState();
}

Future<String> loadLastUsedInfo() async {
  final prefs = await SharedPreferences.getInstance();
  String lastUsedInformation = prefs.getString("FromCart") ?? "";
  debugPrint(lastUsedInformation);
  return lastUsedInformation;
}

class _FoodCartPageState extends State<FoodCartPage> {
  @override
  void dispose() {
    super.dispose();
    isComplete = false;
  }

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
  TextEditingController nameController = TextEditingController();
  TextEditingController phnNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
    }
    if (widget.customerProfile?.primaryInfo != null) {
      phnNoController.text =
          widget.customerProfile?.primaryInfo!["PhoneNo"] ?? "";
    }
    if (widget.customerProfile?.primaryInfo != null) {
      addressController.text =
          widget.customerProfile?.primaryInfo!["Address"] ?? "";
    }
    if (widget.customerProfile?.primaryInfo != null) {
      emailController.text =
          widget.customerProfile?.primaryInfo!["Email"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
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
                            style: UpStyle(),
                            controller: nameController,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: UpTextField(
                            label: 'TELEPHONE',
                            style: UpStyle(),
                            controller: phnNoController,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: UpTextField(
                            label: 'EMAIL',
                            style: UpStyle(),
                            controller: emailController,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: UpTextField(
                            label: 'Address',
                            style: UpStyle(),
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
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        UpButton(
                          onPressed: () {
                            setState(() {
                              Apiraiser.authentication.isSignedIn()
                                  ? ServiceManager<UpNavigationService>()
                                      .navigateToNamed(Routes.loginSignup)
                                  : isComplete = true;
                            });
                          },
                          text: "Confirm Order",
                          style: UpStyle(buttonWidth: 200),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Expanded(
                flex: 4,
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: CartWidget(
                    isVisible: true,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
