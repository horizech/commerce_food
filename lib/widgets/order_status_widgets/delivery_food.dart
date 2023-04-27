import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/widgets/up_text.dart';

class DeliveryFood extends StatelessWidget {
  const DeliveryFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: UpText("DELIVERY", type: UpTextType.heading5),
        ),
        SizedBox(
          height: 200,
          width: 300,
          child: Image.asset(
            'food_delivery.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
