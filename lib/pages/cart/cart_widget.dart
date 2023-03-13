import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/models/up_radio_button_items.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_radio_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/media/media_widget.dart';

List<UpLabelValuePair> _items = [
  UpLabelValuePair(label: "Remove it from my order", value: '1'),
  UpLabelValuePair(label: "Cancel the entire order", value: '2'),
  UpLabelValuePair(label: "Call me and confirm", value: '3'),
];

class CartWidget extends StatefulWidget {
  const CartWidget({super.key, required this.product});
  final Product product;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  String _currentSelection = _items.first.value;
  _onChange(value) {
    (_currentSelection = value);
  }

  Widget build(BuildContext context) {
    Widget _getProductVariations() {
      return FutureBuilder<List<ProductVariation>?>(
        future:
            ProductDetailService.getProductVariationsById(widget.product.id!),
        initialData: null,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductVariation>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 600,
                        child: MediaWidget(
                          mediaId: widget.product.thumbnail,
                          height: 350,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: UpText("Select variation",
                            type: UpTextType.heading5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.product.name),
                            Text("£${widget.product.price}")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UpRadioButton(
                            items: snapshot.data!
                                .map(
                                  (el) => UpRadioButtonItem(
                                    label: "${el.name ?? ''} £ ${el.price}",
                                    value: el.id,
                                  ),
                                )
                                .toList()),
                      ),
                      // ...snapshot.data!.map(
                      //   (e) {
                      //     return Column(
                      //       children: [
                      //         UpButton(
                      //           text:
                      //               "${e.name}      -     Price  £ ${e.price}",
                      //           onPressed: () => {
                      //             // onClick(e.id ?? -1),
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const UpText("Special instructions",
                                type: UpTextType.heading5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4, left: 2),
                              child: UpText(
                                "Any specific preferences? Let the restaurant know.",
                                style: UpStyle(
                                    textColor:
                                        const Color.fromARGB(255, 80, 79, 79),
                                    textSize: 12),
                              ),
                            ),
                            const UpTextField(
                              hint: "e.g. No mayo",
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const UpText("If this product is not available",
                                type: UpTextType.heading5),
                            const SizedBox(height: 4),
                            UpDropDown(
                              label: '',
                              value: _currentSelection,
                              itemList: _items,
                              onChanged: (value) => _onChange(value),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 14, 8),
                                  child: SizedBox(
                                    width: 100,
                                    child: UpButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Cancel",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 8, 8),
                                  child: SizedBox(
                                    width: 100,
                                    child: UpButton(
                                      text: "Add to cart",
                                      onPressed: () async {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox();
          } else {
            return const SizedBox(
              child: Text(
                'Loading...',
              ),
            );
          }
        },
      );
    }

    return Container(
      child: Column(
        children: [_getProductVariations()],
      ),
    );
  }
}
