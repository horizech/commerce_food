import 'package:flutter/material.dart';

import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_drawer_item.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:shop/constants.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  List<UpDrawerItem> _getDrawerActions() {
    List<UpDrawerItem> actions = <UpDrawerItem>[];

    void product(context) {
      ServiceManager<UpNavigationService>()
          .navigateToNamed(Routes.adminProducts);
    }

    void attributes(context) {
      ServiceManager<UpNavigationService>()
          .navigateToNamed(Routes.adminAttributes);
    }

    void combos(context) {
      ServiceManager<UpNavigationService>().navigateToNamed(Routes.adminCombos);
    }

    void gallery(context) {
      ServiceManager<UpNavigationService>()
          .navigateToNamed(Routes.adminGallery);
    }

    void keywords(context) {
      ServiceManager<UpNavigationService>()
          .navigateToNamed(Routes.adminKeywords);
    }

    actions = [
      ...actions,
      UpDrawerItem(
        title: Constant.products,
        icon: Icons.production_quantity_limits,
        onTap: product,
      ),
      UpDrawerItem(
        title: Constant.combos,
        icon: Icons.food_bank_sharp,
        onTap: combos,
      ),
      UpDrawerItem(
        title: Constant.attributes,
        icon: Icons.merge_rounded,
        onTap: attributes,
      ),
      UpDrawerItem(
        title: Constant.gallery,
        icon: Icons.browse_gallery,
        onTap: gallery,
      ),
      UpDrawerItem(
        title: Constant.keywords,
        icon: Icons.folder_special,
        onTap: keywords,
      ),
    ];

    return actions;
  }

  Widget getDrawerHeader(context) {
    return DrawerHeader(
      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
      decoration: BoxDecoration(
        color: UpConfig.of(context).theme.primaryColor.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Shop',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      ),
    );
  }

  List<Widget> getView(context) {
    List<Widget> view = [getDrawerHeader(context)];

    view = [
      ...view,
      ..._getDrawerActions()
          .map<Widget>((action) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      action.icon,
                      color: UpConfig.of(context).theme.primaryStyle.iconColor,
                    ),
                    title: Text(action.title),
                    onTap: () => {action.onTap(context)},
                  ),
                ],
              ))
          .toList()
    ];

    return view;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: getView(context)),
    );
  }
}
