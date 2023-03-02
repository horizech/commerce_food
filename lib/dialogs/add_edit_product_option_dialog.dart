import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditProductOptionDialog extends StatelessWidget {
  final List<ProductOption>? productOptions;
  final int? currentCollection;
  final ProductOption? productOption;
  const AddEditProductOptionDialog({
    Key? key,
    required this.productOptions,
    this.currentCollection,
    this.productOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController productOptioncontroller = TextEditingController();
    TextEditingController productOptionValuecontroller =
        TextEditingController();

    if (productOption != null) {
      productOptioncontroller.text = productOption!.name;
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          productOption != null ? "Edit Product Option" : "Add Product Option",
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
                child: UpTextField(
                  controller: productOptioncontroller,
                  label: 'Product Option',
                ),
              ),
              Visibility(
                visible: currentCollection != null && productOption == null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UpTextField(
                    controller: productOptionValuecontroller,
                    label: 'Product Option Value',
                  ),
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
                text: productOption != null ? "Edit" : "Add",
                onPressed: () async {
                  if (productOptions != null &&
                      !productOptions!.any(
                        (element) =>
                            element.name.toLowerCase() ==
                            productOptioncontroller.text.toLowerCase(),
                      )) {
                    ProductOption newProductOption = ProductOption(
                      name: productOptioncontroller.text,
                    );
                    ProductOption? productOption1 =
                        await AddEditProductService.addEditProductOption(
                      data: newProductOption.toJson(newProductOption),
                      productOptionId:
                          productOption != null ? productOption!.id! : null,
                    );
                    if (productOption1 != null) {
                      if (currentCollection == null) {
                        showUpToast(
                          context: context,
                          text: "Product Option Updated Successfully",
                        );
                        // context.read<StoreCubit>().getStore();
                        Navigator.pop(context, "success");
                      } else {
                        ProductOptionValue newProductOptionValue =
                            ProductOptionValue(
                          name: productOptionValuecontroller.text,
                          productOption: productOption1.id!,
                          collection: currentCollection!,
                        );
                        APIResult? result = await AddEditProductService
                            .addEditProductOptionValues(
                          data: newProductOptionValue
                              .toJson(newProductOptionValue),
                        );
                        if (result != null && result.success) {
                          showUpToast(
                            context: context,
                            text: "Product Option Added Successfully",
                          );
                          Navigator.pop(context, "success");
                        } else {
                          showUpToast(
                            context: context,
                            text: "An Error Occurred",
                          );
                        }
                      }
                    } else {
                      showUpToast(
                        context: context,
                        text: "An error occurred",
                      );
                    }
                  } else {
                    showUpToast(
                      context: context,
                      text: "Product Option Already Exits",
                    );
                    Navigator.pop(context);
                  }
                }),
          ),
        ),
      ],
    );
  }
}
