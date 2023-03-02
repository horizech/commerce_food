import 'dart:async';

import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/validation/up_valdation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_dialog.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/dialogs/up_loading.dart';
import 'package:flutter_up/dialogs/up_info.dart';
import 'package:shop/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _username = "", _fullname = "", _email = "", _password = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _gotoHome() {
    Timer(
        const Duration(seconds: 1),
        () =>
            ServiceManager<UpNavigationService>().navigateToNamed(Routes.home));
  }

  _signup() async {
    var formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      String loadingDialogCompleterId = ServiceManager<UpDialogService>()
          .showDialog(context, UpLoadingDialog(),
              data: {'text': 'Signing up...'});

      APIResult result = await Apiraiser.authentication.signup(
        SignupRequest(
          username: _username,
          fullName: _fullname,
          email: _email,
          password: _password,
        ),
      );

      ServiceManager<UpDialogService>().completeDialog(
          context: context,
          completerId: loadingDialogCompleterId,
          result: null);

      _handleSignupResult(result);
    } else {
      ServiceManager<UpDialogService>().showDialog(context, UpInfoDialog(),
          data: {'title': 'Error', 'text': 'Please fill all fields.'});
    }
  }

  void _handleSignupResult(APIResult result) {
    if (result.success) {
      _saveSession(result);
      ServiceManager<UpNavigationService>().navigateToNamed(Routes.home);
      // _gotoHome();
    } else {
      ServiceManager<UpDialogService>().showDialog(context, UpInfoDialog(),
          data: {'title': 'Error', 'text': result.message});
    }
  }

  void _saveSession(APIResult result) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', _email);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (ServiceManager<AuthService>().user != null) {
      //   _gotoHome();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  validation: UpValidation(minLength: 6),
                  label: "Username",
                  onSaved: (input) => _username = input!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  label: 'Full name',
                  validation: UpValidation(isRequired: true),
                  onSaved: (input) => _fullname = input!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  label: 'Email',
                  validation: UpValidation(isRequired: true, isEmail: true),
                  onSaved: (input) => _email = input!,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UpTextField(
                    label: 'Password',
                    validation: UpValidation(isRequired: true, minLength: 6),
                    maxLines: 1,
                    onSaved: (input) => _password = input!,
                    obscureText: true,
                  )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                    width: 192,
                    child: UpButton(
                      text: "Signup",
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Signup"),
                      ),
                      onPressed: () => _signup(),
                    )),
              ),
            ],
          ),
        ));
  }
}
