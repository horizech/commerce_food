import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_table.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: UpConfig.of(context).theme.primaryColor),
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: UpText(
                    "Orders",
                    type: UpTextType.heading4,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    UpText("ORDER", type: UpTextType.heading6),
                    UpText("TIME/DATE", type: UpTextType.heading6),
                    UpText("STATUS", type: UpTextType.heading6),
                    UpText("TOTAL", type: UpTextType.heading6),
                    UpText("DETAILS", type: UpTextType.heading6),
                  ],
                ),
                const SizedBox(height: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
