import 'package:flutter/cupertino.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/widgets/up_text.dart';

class UnAuthorizedWidget extends StatelessWidget {
  const UnAuthorizedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: UpText("You are not authorized to access this page",
          type: UpTextType.heading3),
    );
  }
}
