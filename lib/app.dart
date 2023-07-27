import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_theme_data.dart';
import 'package:flutter_up/themes/up_themes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/up_app.dart';
import 'package:flutter_up/widgets/up_responsive_page.dart';
import 'package:shop/constants.dart';
import 'package:shop/pages/admin/admin.dart';
import 'package:shop/pages/admin/admin_attributes_mob.dart';
import 'package:shop/pages/admin/admin_combos.dart';
import 'package:shop/pages/admin/admin_combos_mob.dart';
import 'package:shop/pages/admin/admin_gallery.dart';
import 'package:shop/pages/admin/admin_gallery_mob.dart';
import 'package:shop/pages/admin/admin_keywords.dart';
import 'package:shop/pages/admin/admin_attributes.dart';
import 'package:shop/pages/admin/admin_keywords_mob.dart';
import 'package:shop/pages/admin/admin_media.dart';
import 'package:shop/pages/admin/admin_media_mob.dart';
import 'package:shop/pages/admin/admin_products.dart';
import 'package:shop/pages/admin/admin_products_mob.dart';
import 'package:shop/pages/admin/admin_user_roles.dart';
import 'package:shop/pages/cart/food_cart_mob_page.dart';
import 'package:shop/pages/cart/food_cart_page.dart';
import 'package:shop/pages/chef/chef.dart';
import 'package:shop/pages/order/user_order_status.dart';
import 'package:shop/pages/products/products_mob.dart';
import 'package:shop/pages/rider/rider.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/media/media_cubit.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:shop/pages/authentication/loginsignup.dart';

import 'package:shop/pages/products/products.dart';
import 'package:shop/pages/store_dependant_page.dart';

class ShopApp extends StatelessWidget {
  // final String mode;
  const ShopApp({
    Key? key,
    // required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpThemeData theme = UpThemes.generateThemeByColor(
      baseColor: const Color.fromARGB(255, 54, 54, 54),
      primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
    );
    theme.primaryStyle = theme.primaryStyle.copyWith(
      UpStyle(textColor: Colors.white, iconColor: Colors.white),
    );

    return BlocProvider(
      create: (_) => Mediacubit(),
      child: BlocProvider(
        create: (_) => CartCubit(),
        child: BlocProvider(
          create: (_) => StoreCubit(),
          child: UpApp(
            theme: UpThemes.generateThemeByColor(
              // primaryColor: Colors.greenAccent,
              isDark: true,
              baseColor: const Color.fromARGB(255, 54, 54, 54),
              primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
              secondaryColor: Colors.white,
              tertiaryColor: const Color.fromARGB(255, 222, 84, 107),
              warnColor: Colors.red,
              successColor: Colors.green,
            ),
            title: 'Shop',
            initialRoute: Routes.home,
            upRoutes: [
              UpRoute(
                path: Routes.home,
                name: Routes.home,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: StoreDependantPage(
                    page: Products(),
                  ),
                  mobilePage: StoreDependantPage(
                    page: ProductsMob(),
                  ),
                ),
              ),
              UpRoute(
                name: Routes.foodCartPage,
                path: Routes.foodCartPage,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: FoodCartPage(),
                  mobilePage: FoodCartMobPage(),
                ),
              ),
              UpRoute(
                path: Routes.loginSignup,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const LoginSignupPage(),
                name: Routes.loginSignup,
                // shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
                // redirectRoute: Routes.products,
              ),
              UpRoute(
                path: Routes.adminCombos,
                name: Routes.adminCombos,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminCombos(),
                  mobilePage: AdminCombosMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminProducts,
                name: Routes.adminProducts,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminProducts(),
                  mobilePage: AdminProductsMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminAttributes,
                name: Routes.adminAttributes,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminProductOptions(),
                  mobilePage: AdminAttributesMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminGallery,
                name: Routes.adminGallery,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminGallery(),
                  mobilePage: AdminGalleryMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminUserRoles,
                name: Routes.adminUserRoles,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: AdminUserRoles(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.admin,
                name: Routes.admin,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: Admin(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminMedia,
                name: Routes.adminMedia,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminMedia(),
                  mobilePage: AdminMediaMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminKeywords,
                name: Routes.adminKeywords,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminKeywords(),
                  mobilePage: AdminKeywordsMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.chef,
                name: Routes.chef,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: ChefPage(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.rider,
                name: Routes.rider,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: RiderPage(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.orderStatus,
                name: Routes.orderStatus,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: UserOrderStatus(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
