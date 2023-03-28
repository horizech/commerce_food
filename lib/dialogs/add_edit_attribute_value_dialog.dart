import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditAttributeValueDialog extends StatefulWidget {
  final Attribute attribute;
  final AttributeValue? attributeValue;
  const AddEditAttributeValueDialog({
    Key? key,
    required this.attribute,
    this.attributeValue,
  }) : super(key: key);

  @override
  State<AddEditAttributeValueDialog> createState() =>
      _AddEditAttributeValueDialogState();
}

class _AddEditAttributeValueDialogState
    extends State<AddEditAttributeValueDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController attributeValuecontroller = TextEditingController();

    if (widget.attributeValue != null) {
      attributeValuecontroller.text = widget.attributeValue!.name;
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          widget.attributeValue != null
              ? "Edit Attribute Value"
              : "Add Attribute Value",
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
                  widget.attribute.name,
                  type: UpTextType.heading4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  controller: attributeValuecontroller,
                  label: 'Attribute Value',
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
              colorType: UpColorType.success,
              text: widget.attributeValue != null ? "Edit" : "Add",
              onPressed: () async {
                AttributeValue newAttributeValue = AttributeValue(
                  name: attributeValuecontroller.text,
                  attribute: widget.attribute.id!,
                );
                APIResult? result =
                    await AddEditProductService.addEditAttributeValues(
                        data: newAttributeValue.toJson(newAttributeValue),
                        attributeValueId: widget.attributeValue != null
                            ? widget.attributeValue!.id
                            : null);
                if (result != null) {
                  if (result.success) {
                    showUpToast(
                      context: context,
                      text: result.message ?? "",
                    );
                    if (mounted) {
                      Navigator.pop(
                        context,
                        "success",
                      );
                    }
                  } else {
                    showUpToast(
                      context: context,
                      text: result.message ?? "",
                    );
                    if (mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
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
