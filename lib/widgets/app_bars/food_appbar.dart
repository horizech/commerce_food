import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:shop/constants.dart';

class FoodAppbar extends StatelessWidget implements PreferredSizeWidget {
  GlobalKey<ScaffoldState>? scaffoldKey;

  FoodAppbar({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpAppBar(
      titleWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            ServiceManager<UpNavigationService>().navigateToNamed(Routes.home);
          },
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image(
                image: AssetImage("assets/logo.png"),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ServiceManager<UpNavigationService>()
                .navigateToNamed(Routes.loginSignup);
          },
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            ServiceManager<UpNavigationService>().navigateToNamed(Routes.cart);
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
