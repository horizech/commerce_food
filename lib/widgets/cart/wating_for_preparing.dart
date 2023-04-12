import 'package:flutter/material.dart';

class WaitingForPreparing extends StatefulWidget {
  const WaitingForPreparing({super.key});

  @override
  State<WaitingForPreparing> createState() => _WaitingForPreparingState();
}

class _WaitingForPreparingState extends State<WaitingForPreparing> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          Text("Wating for order response"),
        ],
      ),
    );
  }
}
