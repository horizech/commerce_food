import 'dart:convert';

import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/validation/up_valdation.dart';

import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_textfield.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/customer_info.dart';
import 'package:shop/pages/payment_method/payment_method_page.dart';

import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/services/customer_profile/customer_profile_services.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return !Apiraiser.authentication.isSignedIn()
                ? width > 1000
                    ?const Row(
                        children:  [
                          Expanded(
                            child: PaymentForm(),
                          ),
                          // CartDisplay(cartItem: state.cart.items),
                        ],
                      )
                    :const Column(
                        children:  [
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
                          PaymentForm(),
                        ],
                      )
                : FutureBuilder<CustomerProfile?>(
                    future: CustomerProfileService.getcustomerProfile(),
                    builder: (BuildContext context,
                        AsyncSnapshot<CustomerProfile?> snapshot) {
                      return snapshot.hasData
                          ? width > 1000
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: PaymentForm(
                                        customerProfile: snapshot.data,
                                      ),
                                    ),
                                    // CartDisplay(cartItem: state.cart.items),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, left: 10, right: 10),
                                      child: ExpansionTile(
                                        leading: Icon(Icons.shopping_cart),
                                        title: Text("Order Summary"),
                                        children: [
                                          // CartDisplay(
                                          //     cartItem: state.cart.items)
                                        ],
                                      ),
                                    ),
                                    PaymentForm(
                                      customerProfile: snapshot.data,
                                    ),
                                  ],
                                )
                          : const CircularProgressIndicator();
                    },
                  );
          },
        ),
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  final CustomerProfile? customerProfile;

  const PaymentForm({
    Key? key,
    this.customerProfile,
  }) : super(key: key);

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  String _groupValue = "";
  String firstname = "",
      email = "",
      lastname = "",
      selectedCountry = "",
      address = "",
      city = "",
      postalCode = "",
      phoneNo = "",
      radioButtonValue = "";

  List<String> country = [
    "Afghanistan",
  ];

  bool isSaveInfo = false, isPrimaryInfo = false, isSecondaryInfo = false;

  void loadInformation() async {
    Map<String, String> customerInfo = {};

    if (widget.customerProfile != null) {
      if (widget.customerProfile!.primaryInfo != null &&
          widget.customerProfile!.primaryInfo!.isNotEmpty) {
        setState(() {
          _groupValue = "primary";
          isSecondaryInfo = false;
          isPrimaryInfo = true;
        });
        customerInfo = widget.customerProfile!.primaryInfo!;
      } else if (widget.customerProfile!.secondaryInfo != null &&
          widget.customerProfile!.secondaryInfo!.isNotEmpty) {
        setState(() {
          _groupValue = "secondary";
          isSecondaryInfo = true;
          isPrimaryInfo = false;
        });
        customerInfo = widget.customerProfile!.secondaryInfo!;
      }
    } else {
      String lastUsedInfo = await loadLastUsedInfo();

      if (lastUsedInfo.isNotEmpty) {
        customerInfo = (json.decode(lastUsedInfo) as Map<String, dynamic>)
            .cast<String, String>();
      } else {
        customerInfo = {
          "Email": "",
          "FirstName": "",
          "LastName": "",
          "Country": "",
          "Address": "",
          "City": "",
          "PhoneNo": "",
          "PostalCode": "",
        };
      }
    }

    initailizeForm(customerInfo);
  }

  @override
  void initState() {
    super.initState();
    loadInformation();
  }

  Future<String> loadLastUsedInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String lastUsedInformation = prefs.getString("CustomerProfile") ?? "";
    debugPrint(lastUsedInformation);
    return lastUsedInformation;
  }

  onPaymentClick(BuildContext context) {
    Map<String, String> customerProfile = {
      "Email": _emailController.text,
      "FirstName": _fnameController.text,
      "LastName": _lnameController.text,
      "Country": selectedCountry,
      "Address": _addressController.text,
      "City": _cityController.text,
      "PhoneNo": _phoneNoController.text,
      "PostalCode": _postalCodeController.text,
    };

    setSharedPrefrence(jsonEncode(customerProfile));
    if (Apiraiser.authentication.isSignedIn()) {
      updateCustomerInfo(customerProfile, isPrimaryInfo, isSecondaryInfo);
    }

    ServiceManager<UpNavigationService>().navigateToNamed(
      PaymentMethodsPage.routeName,
    );
  }

  updateCustomerInfo(
      Map<String, String> updatedInfo, bool? isPrimary, bool? isSecondary) {
    FutureBuilder<APIResult?>(
      future: CustomerProfileService.updatecustomerProfile(
          widget.customerProfile,
          updatedInfo,
          isPrimary ?? false,
          isSecondary ?? false),
      builder: (BuildContext context, AsyncSnapshot<APIResult?> snapshot) {
        return const Text("");
      },
    );
  }

  setSharedPrefrence(String info) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("CustomerProfile", info);
  }

  initailizeForm(Map<String, String>? profile) {
    _emailController.text = profile!["Email"] ?? "";
    _fnameController.text = profile["FirstName"] ?? "";
    _lnameController.text = profile["LastName"] ?? "";

    _addressController.text = profile["Address"] ?? "";

    _phoneNoController.text = profile["PhoneNo"] ?? "";
    _postalCodeController.text = profile["PostalCode"] ?? "";
    _cityController.text = profile["City"] ?? "";

    setState(() {
      selectedCountry = profile["Country"] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: SizedBox(
            width: 600,
            // color: Colors.pink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    runSpacing: 10.0,
                    spacing: 10.0,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Contact Information",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            ServiceManager<UpNavigationService>()
                                .navigateToNamed(Routes.loginSignup);
                          },
                          child: Text(
                            "Already have an account?Login",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Apiraiser.authentication.isSignedIn()
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            UpRadioButton(
                              initialValue: "primary",
                              items: [
                                UpRadioButtonItem(
                                    label: 'Primary Information',
                                    value: 'primary'),
                                UpRadioButtonItem(
                                    label: 'Secondary Information',
                                    value: 'secondary'),
                              ],
                              onChange: (radioValue) {
                                setState(() {
                                  _groupValue = radioValue.toString();
                                });

                                if (radioValue == "primary") {
                                  initailizeForm(
                                      widget.customerProfile!.primaryInfo);
                                  setState(() {
                                    isPrimaryInfo = true;
                                    isSecondaryInfo = false;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // UpRadio(
                            //     value: "secondary",
                            //     groupValue: _groupValue,
                            //     label: "Secondary Information",
                            //     onChange: (radioValue) {
                            //       setState(() {
                            //         _groupValue = radioValue.toString();
                            //       });

                            //       if (radioValue == "secondary") {
                            //         initailizeForm(
                            //             widget.customerProfile!.secondaryInfo);
                            //         setState(() {
                            //           isSecondaryInfo = true;
                            //           isPrimaryInfo = false;
                            //         });
                            //       }
                            //     }),
                            // const Text("Secondary Information"),
                          ],
                        ),
                      )
                    : const Text(""),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: AutofillGroup(
                    child: UpTextField(
                      controller: _emailController,
                      autofillHint: AutofillHints.email,
                      keyboardType: TextInputType.emailAddress,
                      validation: UpValidation(isEmail: true),
                      label: "Email",
                      // onSaved: (input) => email = input ?? "",
                      // decoration: const InputDecoration(
                      //   labelText: "Email",
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AutofillGroup(
                            child: UpTextField(
                              controller: _fnameController,
                              autofillHint: AutofillHints.name,
                              keyboardType: TextInputType.text,
                              validation: UpValidation(isRequired: true),
                              label: "First Name",
                              // decoration: const InputDecoration(
                              //   labelText: "First Name",
                              // ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AutofillGroup(
                            child: UpTextField(
                              controller: _lnameController,
                              keyboardType: TextInputType.text,
                              autofillHint: AutofillHints.middleName,
                              label: "Last Name",

                              // decoration: const InputDecoration(
                              //   labelText: "Last Name",
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: selectedCountry.isNotEmpty
                        ? Text(selectedCountry,
                            style: const TextStyle(fontSize: 14))
                        : const Text(
                            'Country',
                            style: TextStyle(fontSize: 14),
                          ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    // value: selectedCountry != "" ? selectedCountry : "UK",
                    items: country
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
                      if (value == null && selectedCountry.isEmpty) {
                        return 'Please select Country.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      selectedCountry = value.toString();
                    },
                    onSaved: (value) {
                      selectedCountry = value.toString();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: AutofillGroup(
                    child: UpTextField(
                      controller: _addressController,
                      keyboardType: TextInputType.text,
                      autofillHint: AutofillHints.streetAddressLine1,
                      validation: UpValidation(isRequired: true),
                      label: "Address",
                      // onSaved: (input) => address = input ?? "",
                      // decoration: const InputDecoration(
                      //   labelText: "Address",
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AutofillGroup(
                            child: UpTextField(
                              controller: _cityController,
                              autofillHint: AutofillHints.addressCity,
                              keyboardType: TextInputType.text,
                              label: "City",
                              validation: UpValidation(isRequired: true),

                              // onSaved: (input) => city = input ?? "",
                              // decoration: const InputDecoration(
                              //   labelText: "City",
                              // ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AutofillGroup(
                            child: UpTextField(
                              controller: _postalCodeController,
                              autofillHint: AutofillHints.postalCode,
                              keyboardType: TextInputType.text,
                              label: "Postal code",
                              validation: UpValidation(isRequired: true),

                              // decoration: const InputDecoration(
                              //   labelText: "Postal Code",
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                  child: AutofillGroup(
                    child: UpTextField(
                      controller: _phoneNoController,
                      keyboardType: TextInputType.number,
                      autofillHint: AutofillHints.telephoneNumber,
                      validation: UpValidation(isRequired: true),

                      label: "Phone no",
                      // onSaved: (input) => phoneNo = input ?? "",
                      // decoration: const InputDecoration(
                      //   labelText: "Phone No",
                      // ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 20.0, right: 20.0, top: 8.0, bottom: 2.0),
                //   child: CustomCheckbox(
                //       isRounded: false,
                //       label: "Save this info",
                //       value: isSaveInfo,
                //       labelDirection: CustomTextDirection.left,
                //       onChange: (newCheck) {
                //         setState(
                //           () {
                //             isSaveInfo = newCheck ?? false;
                //           },
                //         );
                //       }),
                // ),
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
                      GestureDetector(
                        onTap: () => ServiceManager<UpNavigationService>()
                            .navigateToNamed(
                          Routes.cart,
                        ),
                        child: Text("< Return to Cart",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.black, fontSize: 16)),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              onPaymentClick(context);
                            }
                          },
                          child: const Text("Continue to Payment"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
