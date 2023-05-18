import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/validation/up_valdation.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';

class CardPaymentPage extends StatelessWidget {
  static const routeName = '/cardpayment';
  const CardPaymentPage({Key? key}) : super(key: key);

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
                            child: CardPaymentForm(),
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
                                // CartDisplay(cartItem: state.cart.items)
                              ],
                            ),
                          ),
                          CardPaymentForm(),
                        ],
                      );
              },
            )));
  }
}

class CardPaymentForm extends StatefulWidget {
  const CardPaymentForm({
    Key? key,
  }) : super(key: key);

  @override
  State<CardPaymentForm> createState() => _CardPaymentFormState();
}

class _CardPaymentFormState extends State<CardPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController cvnController = TextEditingController();
  String cardNo = "", cvn = "", selectedMonth = "", selectedYear = "";
  List<String> years = [];
  List<String> months = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12"
  ];
  int currentYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i <= 10; i++) {
      years.add("${currentYear + i}");
    }

    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Container(
            width: 400,
            // color: Colors.pink,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.lock),
                        Text(
                          "Payment detail",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Card Number       "),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: AutofillGroup(
                            child: UpTextField(
                              autofillHint: AutofillHints.creditCardNumber,
                              controller: cardNoController,
                              keyboardType: TextInputType.text,
                              label: "cardno",
                              validation: UpValidation(isRequired: true),
                              // onSaved: (input) => cardNo = input ?? "",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Expiration Month"),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: const Text("Month"),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                            // value: selectedCountry != "" ? selectedCountry : "UK",
                            items: months
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null && selectedMonth.isEmpty) {
                                return 'Please select Month.';
                              }
                              return null;
                            },

                            onChanged: (value) {
                              selectedMonth = value.toString();
                            },
                            onSaved: (value) {
                              selectedMonth = value.toString();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Expiration Year   "),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: DropdownButtonFormField(
                              // isExpanded: true,
                              hint: const Text("Year"),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              // value: selectedCountry != "" ? selectedCountry : "UK",
                              items: years
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null && selectedYear.isEmpty) {
                                  return 'Please select Year.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                selectedYear = value.toString();
                              },
                              onSaved: (value) {
                                selectedYear = value.toString();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("CVN                   "),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: UpTextField(
                          controller: cvnController,
                          keyboardType: TextInputType.text,
                          label: "CVN",
                          validation: UpValidation(isRequired: true),
                          // onSaved: (input) => cvn = input ?? "",
                          // decoration: const InputDecoration(
                          //   labelText: "CVN",
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ServiceManager<UpNavigationService>().goBack();
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: const Text(" Pay "))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
