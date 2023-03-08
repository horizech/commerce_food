import 'package:flutter/material.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/widgets/app_bars/food_appbar.dart';
import 'package:shop/widgets/cart/cart_widget.dart';

class FoodCartPage extends StatefulWidget {
  const FoodCartPage({super.key});

  @override
  State<FoodCartPage> createState() => _FoodCartPageState();
}

class _FoodCartPageState extends State<FoodCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FoodAppbar(),
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: Column(
                children: [
                  const Text("Need to know your details"),
                  const UpTextField(label: 'YOUR NAME'),
                  const UpTextField(label: 'TELEPHONE'),
                  const UpTextField(label: 'EMAIL'),
                  const Text("Pay by cash or card"),
                  Row(
                    children: [
                      UpButton(
                        onPressed: () {},
                        text: "CASH",
                        icon: Icons.money,
                      ),
                      UpButton(
                        onPressed: () {},
                        text: "CARD",
                        icon: Icons.credit_card,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
                flex: 4,
                child: SizedBox(
                    width: 400, height: 400, child: const CartWidget1())),
          )
        ],
      ),
    );
  }
}
