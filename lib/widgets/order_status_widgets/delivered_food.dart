import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';

class DeliveredFood extends StatelessWidget {
  const DeliveredFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: UpText("Your order is delivered.", type: UpTextType.heading5),
        ),
        SizedBox(
          height: 200,
          width: 300,
          child: Image.asset(
            'order_Delivered.png',
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        UpButton(
            onPressed: () {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.products);
            },
            text: "Place new order")
      ],
    );
  }
}
