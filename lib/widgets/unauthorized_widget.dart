import 'package:flutter/cupertino.dart';

class UnAuthorizedWidget extends StatelessWidget {
  const UnAuthorizedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Image(
        image: AssetImage("assets/not-allowed.png"),
      ),
    );
  }
}
