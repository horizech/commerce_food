import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditProductOptionDialog extends StatefulWidget {
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
  State<AddEditProductOptionDialog> createState() =>
      _AddEditProductOptionDialogState();
}

class _AddEditProductOptionDialogState
    extends State<AddEditProductOptionDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController productOptioncontroller = TextEditingController();
    TextEditingController productOptionValuecontroller =
        TextEditingController();

    if (widget.productOption != null) {
      productOptioncontroller.text = widget.productOption!.name;
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          widget.productOption != null
              ? "Edit Product Option"
              : "Add Product Option",
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
                visible: widget.currentCollection != null &&
                    widget.productOption == null,
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
                text: widget.productOption != null ? "Edit" : "Add",
                onPressed: () async {
                  if (widget.productOptions != null &&
                      !widget.productOptions!.any(
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
                      productOptionId: widget.productOption != null
                          ? widget.productOption!.id!
                          : null,
                    );
                    if (productOption1 != null) {
                      if (widget.currentCollection == null) {
                        showUpToast(
                          context: context,
                          text: "Product Option Updated Successfully",
                        );
                        if (mounted) {}
                        Navigator.pop(context, "success");
                      } else {
                        ProductOptionValue newProductOptionValue =
                            ProductOptionValue(
                          name: productOptionValuecontroller.text,
                          productOption: productOption1.id!,
                          collection: widget.currentCollection!,
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
                          if (mounted) {}
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
