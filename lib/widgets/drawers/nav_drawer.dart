import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_drawer_item.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_nav_drawer.dart';
import 'package:flutter_up/widgets/up_text.dart';
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

    void userRole(context) {
      ServiceManager<UpNavigationService>()
          .navigateToNamed(Routes.adminUserRoles);
    }

    void media(context) {
      ServiceManager<UpNavigationService>().navigateToNamed(Routes.adminMedia);
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
      UpDrawerItem(
        title: Constant.userrole,
        icon: Icons.person,
        onTap: userRole,
      ),
      UpDrawerItem(
        title: Constant.media,
        icon: Icons.image,
        onTap: media,
      ),
    ];

    return actions;
  }

  Widget getDrawerHeader(context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UpText(
            'Shop',
            style: UpStyle(textSize: 25),
          ),
        ],
      ),
    );
  }

  List<Widget> getView(context) {
    List<Widget> view = [];

    view = [
      ...view,
      ..._getDrawerActions()
          .map<Widget>((action) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpListTile(
                    style: UpStyle(
                        listTileColor: Uri.base.fragment.toLowerCase() ==
                                "/admin/${action.title.toLowerCase()}"
                            ? UpConfig.of(context).theme.primaryColor
                            : Colors.transparent,
                        listTileTextColor: Uri.base.fragment.toLowerCase() ==
                                "/admin/${action.title.toLowerCase()}"
                            ? UpThemes.getContrastColor(
                                UpConfig.of(context).theme.primaryColor)
                            : UpConfig.of(context).theme.baseColor.shade900,
                        listTileHoveredColor: Uri.base.fragment.toLowerCase() ==
                                "/admin/${action.title.toLowerCase()}"
                            ? Colors.transparent
                            : UpConfig.of(context).theme.baseColor.shade100),
                    leading: UpIcon(
                      icon: action.icon,
                      style: UpStyle(
                          iconColor: Uri.base.fragment.toLowerCase() ==
                                  "/admin/${action.title.toLowerCase()}"
                              ? UpThemes.getContrastColor(
                                  UpConfig.of(context).theme.primaryColor)
                              : UpConfig.of(context).theme.baseColor.shade900),
                    ),
                    title: (action.title),
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
    return UpNavDrawer(
      body: getView(context),
      header: getDrawerHeader(context),
    );
  }
}
