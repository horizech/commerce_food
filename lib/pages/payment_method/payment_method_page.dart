import 'dart:convert';

import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/customer_info.dart';
import 'package:shop/pages/payment_method/card_payment_page.dart';

import 'package:shop/widgets/cart/cart_cubit.dart';

class PaymentMethodsPage extends StatelessWidget {
  static const routeName = '/payment_method';
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return width > 1000
                ? const Row(
                    children: [
                      Expanded(
                        child: PaymentMethodsForm(),
                      ),
                      // CartDisplay(cartItem: state.cart.items),
                    ],
                  )
                : const Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, left: 10, right: 10),
                        child: ExpansionTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text("Order Summary"),
                          children: [
                            // CartDisplay(cartItem: state.cart.items),
                          ],
                        ),
                      ),
                      PaymentMethodsForm(),
                    ],
                  );
          }),
    ));
  }
}

class PaymentMethodsForm extends StatefulWidget {
  final CustomerProfile? customerProfile;

  const PaymentMethodsForm({
    Key? key,
    this.customerProfile,
  }) : super(key: key);

  @override
  State<PaymentMethodsForm> createState() => _PaymentMethodsFormState();
}

class _PaymentMethodsFormState extends State<PaymentMethodsForm> {
  final _formKey = GlobalKey<FormState>();

  String contact = "", address = "";
  Map<String, String> customerInfo = {};
  bool isCard = false, isPaypal = false;
  String? _groupValue;
  @override
  void initState() {
    loadInformation();
    super.initState();
  }

  void loadInformation() async {
    String lastUsedInfo = await loadLastUsedInfo();

    if (lastUsedInfo.isNotEmpty) {
      customerInfo = (json.decode(lastUsedInfo) as Map<String, dynamic>)
          .cast<String, String>();
      setState(() {
        contact = customerInfo["Email"] ?? "";
        address = customerInfo["Address"] ?? "";
      });
    }
  }

  Future<String> loadLastUsedInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String lastUsedInformation = prefs.getString("CustomerProfile") ?? "";

    return lastUsedInformation;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: SizedBox(
            // color: Colors.pink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 550,
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            )),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Contact",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Text(contact),
                                  ),
                                ),
                                const Text("Change",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 550,
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            )),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Ship to",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(address),
                                )),
                                const Text("Change",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 550,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Method",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text("Courier Service"),
                                )),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Payment", style: TextStyle(fontSize: 16)),
                const SizedBox(
                  height: 5,
                ),
                const Text("All transactions are secure and encrypted.",
                    style: TextStyle(fontSize: 14)),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 550,
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            )),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                activeColor:
                                    isCard ? Colors.black : Colors.white,
                                value: "Card",
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return (isCard) ? Colors.black : Colors.grey;
                                }),
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue = value.toString();
                                  });

                                  if (value == "Card") {
                                    setState(() {
                                      isCard = true;
                                      isPaypal = false;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("Debit- Credit Card"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 550,
                          child: Row(
                            children: [
                              Radio(
                                activeColor:
                                    isPaypal ? Colors.black : Colors.white,
                                value: "paypal",
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return (isPaypal)
                                      ? Colors.black
                                      : Colors.grey;
                                }),
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue = value.toString();
                                  });

                                  if (value == "paypal") {
                                    setState(() {
                                      isPaypal = true;
                                      isCard = false;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("PayPal"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.spaceEvenly,
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      Text("< Return to Payment",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.black, fontSize: 16)),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (isCard) {
                                ServiceManager<UpNavigationService>()
                                    .navigateToNamed(
                                  CardPaymentPage.routeName,
                                );
                              }
                              if (isPaypal) {}
                            }
                          },
                          child: const Text("Complete Order"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
