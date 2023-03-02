import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:shop/constants.dart';
import 'package:shop/pages/authentication/login.dart';
import 'package:shop/pages/authentication/signup.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  String _mode = Constant.authLogin;

  _gotoLogin() {
    setState(() {
      _mode = Constant.authLogin;
    });
  }

  _gotoSignup() {
    setState(() {
      _mode = Constant.authSignup;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getView() {
    List<Widget> view = [
      _mode == Constant.authLogin ? const LoginPage() : const SignupPage(),
      const SizedBox(
        height: 15,
      ),
      SizedBox(
        width: 192,
        child: UpButton(
          text: "${_mode == Constant.authLogin ? 'Signup' : 'Login'} instead",
          onPressed: () =>
              _mode == Constant.authLogin ? _gotoSignup() : _gotoLogin(),
        ),
      )
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: view,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(
        title: 'Shop',
      ),
      body: getView(),
    );
  }
}
