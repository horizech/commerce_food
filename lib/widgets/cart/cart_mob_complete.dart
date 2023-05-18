import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';

class CartMobComplete extends StatelessWidget {
  final Function onChange;
  const CartMobComplete({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UpText("PREPARING FOOD", type: UpTextType.heading5),
          ),
          SizedBox(
            height: 200,
            width: 300,
            child: Image.asset(
              'perparingfood.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: UpConfig.of(context).theme.primaryColor,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const UpText(
                        "Name:           ",
                      ),
                      UpText(
                        "text",
                        style: UpStyle(textColor: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const UpText("Telephone:    "),
                      UpText(
                        "text",
                        style: UpStyle(textColor: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const UpText("Email:            "),
                      UpText(
                        "text",
                        style: UpStyle(textColor: Colors.grey),
                      ),
                    ],
                  ),
                  const UpText("Order Details", type: UpTextType.heading6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [UpText("Product Name"), UpText("Price")],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [UpText("Product Name"), UpText("Price")],
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    height: 1,
                    color: UpConfig.of(context).theme.primaryColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UpText(
                        "Total",
                        style: UpStyle(textWeight: FontWeight.bold),
                      ),
                      UpText(
                        "Total Price",
                        style: UpStyle(textWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      UpText(
                        "Payment Method:  ",
                        style: UpStyle(textWeight: FontWeight.bold),
                      ),
                      const UpText("CASH/CARD"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          UpButton(
            onPressed: () {
              onChange(true);
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.home);
            },
            text: "New Order",
          )
        ],
      ),
    );
  }
}
