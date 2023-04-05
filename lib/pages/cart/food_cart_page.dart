import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UpText(
                    "Need to know your details",
                    type: UpTextType.heading4,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: 300,
                        child:
                            UpTextField(label: 'YOUR NAME', style: UpStyle()),
                      ),
                      SizedBox(
                        width: 300,
                        child:
                            UpTextField(label: 'TELEPHONE', style: UpStyle()),
                      ),
                      SizedBox(
                        width: 300,
                        child: UpTextField(label: 'EMAIL', style: UpStyle()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const UpText(
                    "Pay by cash or card",
                    type: UpTextType.heading4,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      UpButton(
                        onPressed: () {},
                        text: "CASH",
                        icon: Icons.money,
                        style: UpStyle(buttonWidth: 300),
                      ),
                      UpButton(
                        onPressed: () {},
                        text: "CARD",
                        icon: Icons.credit_card,
                        style: UpStyle(buttonWidth: 300),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Expanded(
                flex: 4,
                child: SizedBox(
                    width: 400,
                    height: 400,
                    child: CartWidget(
                      isVisible: true,
                    ))),
          )
        ],
      ),
    );
  }
}
