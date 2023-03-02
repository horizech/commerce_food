import 'package:flutter_up/locator.dart';
import 'package:shop/services/variation.dart';

void setupLocator() {
  setupFlutterUpLocators([
    FlutterUpLocators.upDialogService,
    FlutterUpLocators.upNavigationService,
    FlutterUpLocators.upScaffoldHelperService,
    FlutterUpLocators.upSearchService,
    FlutterUpLocators.upUrlService
  ]);
  ServiceManager.registerLazySingleton(() => VariationService());
}
