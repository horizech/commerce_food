import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/widgets/up_text.dart';

class WaitingForChef extends StatelessWidget {
  const WaitingForChef({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UpText("WAITING FOR RESTURANT RESPONSE",
                type: UpTextType.heading5),
          ),
          const SizedBox(
            height: 18,
          ),
          SizedBox(
            height: 200,
            width: 300,
            child: Image.asset(
              'waiting.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
