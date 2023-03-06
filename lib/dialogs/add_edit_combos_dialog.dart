import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditComboDialog extends StatefulWidget {
  final Combo? combo;
  const AddEditComboDialog({
    Key? key,
    this.combo,
  }) : super(key: key);

  @override
  State<AddEditComboDialog> createState() => _AddEditComboDialogState();
}

class _AddEditComboDialogState extends State<AddEditComboDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.combo != null) {
      nameController.text = widget.combo!.name;
      priceController.text = widget.combo!.price.toString();
      descriptionController.text = widget.combo!.description ?? "";
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          widget.combo != null ? "Edit Combo" : "Add Combo",
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
                  controller: nameController,
                  label: 'Name',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  controller: descriptionController,
                  label: 'Description',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpTextField(
                  controller: priceController,
                  label: 'Price',
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
                text: widget.combo != null ? "Edit" : "Add",
                onPressed: () async {
                  Combo combo = Combo(
                      name: nameController.text,
                      price: priceController.text.isNotEmpty
                          ? double.parse(priceController.text)
                          : 0,
                      description: descriptionController.text);
                  APIResult? result = await AddEditProductService.addEditCombos(
                      data: Combo.toJson(combo),
                      comboId: widget.combo != null ? widget.combo!.id! : null);
                  if (result != null && result.success) {
                    showUpToast(
                      context: context,
                      text: result.message ?? "",
                    );
                    if (mounted) {}
                    Navigator.pop(context, "success");
                  } else {
                    showUpToast(
                      context: context,
                      text: "An Error Occurred",
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
