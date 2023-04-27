import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';

class AdminAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpAppBar(
      titleWidget: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UpIcon(
              icon: Icons.admin_panel_settings,
              style: UpStyle(iconColor: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UpText(
              "Admin",
              style: UpStyle(textColor: Colors.white),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
