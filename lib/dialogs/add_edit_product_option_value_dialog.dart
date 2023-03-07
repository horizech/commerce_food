import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditProductOptionValueDialog extends StatelessWidget {
  final ProductOption productOption;
  final int currentCollection;
  final ProductOptionValue? productOptionValue;
  const AddEditProductOptionValueDialog({
    Key? key,
    required this.productOption,
    required this.currentCollection,
    this.productOptionValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController productOptionValuecontroller =
        TextEditingController();

    if (productOptionValue != null) {
      productOptionValuecontroller.text = productOptionValue!.name;
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          productOptionValue != null
              ? "Edit Product Option Value"
              : "Add Product Option Value",
        ),
      ),
      actionsPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpText(
                  productOption.name,
                  type: UpTextType.heading4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  controller: productOptionValuecontroller,
                  label: 'Product Option Value',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: SizedBox(
            width: 100,
            child: UpButton(
              text: productOptionValue != null ? "Edit" : "Add",
              onPressed: () async {
                ProductOptionValue newProductOptionValue = ProductOptionValue(
                  name: productOptionValuecontroller.text,
                  productOption: productOption.id!,
                  collection: currentCollection,
                );
                APIResult? result =
                    await AddEditProductService.addEditProductOptionValues(
                        data:
                            newProductOptionValue.toJson(newProductOptionValue),
                        productOptionValueId: productOptionValue != null
                            ? productOptionValue!.id
                            : null);
                if (result != null) {
                  if (result.success) {
                    showUpToast(
                      context: context,
                      text: result.message ?? "",
                    );
                    Navigator.pop(
                      context,
                      "success",
                    );
                  } else {
                    showUpToast(
                      context: context,
                      text: result.message ?? "",
                    );
                    Navigator.pop(
                      context,
                    );
                  }
                } else {
                  showUpToast(
                    context: context,
                    text: "An Error Occurred",
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
