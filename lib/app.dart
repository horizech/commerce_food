import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_theme_data.dart';
import 'package:flutter_up/themes/up_themes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/up_app.dart';
import 'package:shop/constants.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/media/media_cubit.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:shop/pages/authentication/loginsignup.dart';
import 'package:shop/pages/cart/cart.dart';
import 'package:shop/pages/home/home_page.dart';

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
      primaryColor: const Color.fromRGBO(
        64,
        64,
        64,
        1.0,
      ),
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
              primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
              secondaryColor: Colors.white,
            ),
            title: 'Shop',
            initialRoute: Routes.home,
            upRoutes: [
              UpRoute(
                path: Routes.home,
                name: Routes.home,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: HomePage(),
                ),
              ),
              UpRoute(
                path: Routes.products,
                name: Routes.products,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: Products(
                    queryParams: state.queryParams,
                  ),
                ),
              ),
              UpRoute(
                path: Routes.loginSignup,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const LoginSignupPage(),
                name: Routes.loginSignup,
                shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.adminProduct,
              ),
              UpRoute(
                name: Routes.cart,
                path: Routes.cart,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: CartPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
