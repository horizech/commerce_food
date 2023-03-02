import 'package:flutter/material.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:shop/constants.dart';

class NotFoundErrorWidget extends StatelessWidget {
  const NotFoundErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // heightFactor: AutomobileAppbar().preferredSize.height,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Oops!!!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 60,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Are you sure this is the right way',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            UpButton(
              style: UpStyle(
                isRounded: true,
                borderRadius: 4,
              ),
              onPressed: () {
                ServiceManager<UpNavigationService>().navigateToNamed(
                  Routes.home,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Go back to Home"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
