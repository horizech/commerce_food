import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:shop/app.dart';
import 'package:shop/environment.dart';
import 'package:shop/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Apiraiser.init(Environment.apiUrl);
  // setPathUrlStrategy();
  runApp(const ShopApp());
}
