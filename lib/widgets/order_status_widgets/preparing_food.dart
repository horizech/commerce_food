import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/widgets/up_text.dart';

class PreparingFood extends StatelessWidget {
  const PreparingFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
