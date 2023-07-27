import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpCard(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, bottom: 100),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UpIcon(
                  icon: Icons.shopping_cart,
                  style: UpStyle(iconSize: 50),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: UpText("No item in cart"),
                ),
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: UpText("Please go and shop"),
                ),
              ]),
        ),
      ),
    );
  }
}
