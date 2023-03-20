import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditAttributeDialog extends StatefulWidget {
  final List<Attribute>? attributes;
  final Attribute? attribute;
  const AddEditAttributeDialog({
    Key? key,
    required this.attributes,
    this.attribute,
  }) : super(key: key);

  @override
  State<AddEditAttributeDialog> createState() => _AddEditAttributeDialogState();
}

class _AddEditAttributeDialogState extends State<AddEditAttributeDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController attributeController = TextEditingController();
    TextEditingController attributeValuecontroller = TextEditingController();

    if (widget.attribute != null) {
      attributeController.text = widget.attribute!.name;
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          widget.attribute != null ? "Edit Attribute" : "Add Attribute",
        ),
      ),
      actionsPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 250,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  controller: attributeController,
                  label: 'Attribute',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: UpText(
                    "Enter first attribute value to create new attribute"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  controller: attributeValuecontroller,
                  label: 'Attributes Value',
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
                text: widget.attribute != null ? "Edit" : "Add",
                onPressed: () async {
                  if (attributeController.text.isNotEmpty &&
                      attributeValuecontroller.text.isNotEmpty) {
                    if (widget.attributes != null &&
                        !widget.attributes!.any(
                          (element) =>
                              element.name.toLowerCase() ==
                              attributeController.text.toLowerCase(),
                        )) {
                      Attribute newAttribute = Attribute(
                        name: attributeController.text,
                      );
                      APIResult? result =
                          await AddEditProductService.addEditAttribute(
                        data: newAttribute.toJson(newAttribute),
                        attributeId: widget.attribute != null
                            ? widget.attribute!.id!
                            : null,
                      );
                      if (result != null) {
                        AttributeValue newAttributeValue = AttributeValue(
                          name: attributeValuecontroller.text,
                          attribute: result.data!,
                        );
                        APIResult? result1 =
                            await AddEditProductService.addEditAttributeValues(
                          data: newAttributeValue.toJson(newAttributeValue),
                        );
                        if (result1 != null) {
                          showUpToast(
                            context: context,
                            text: result1.message ?? "",
                          );
                          if (mounted) {
                            Navigator.pop(context, "success");
                          }
                        }
                      } else {
                        showUpToast(
                          context: context,
                          text: "An error occurred",
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
                        text: "Attribute already exits",
                      );
                      Navigator.pop(context);
                    }
                  }
                }),
          ),
        ),
      ],
    );
  }
}
