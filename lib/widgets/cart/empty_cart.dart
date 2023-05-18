import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 200.0, bottom: 200),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                size: 50,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No item in cart"),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text("Please go and shop"),
              ),
            ]),
      ),
    );
  }
}
