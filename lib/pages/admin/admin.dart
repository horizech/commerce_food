import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/isUserAdmin.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: isUserAdmin() ? const UpText("Admin") : const UnAuthorizedWidget(),
    );
  }
}
