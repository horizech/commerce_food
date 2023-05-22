import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class AddEditKeywordDialog extends StatefulWidget {
  final Keyword? currentKeyword;
  const AddEditKeywordDialog({
    Key? key,
    this.currentKeyword,
  }) : super(key: key);

  @override
  State<AddEditKeywordDialog> createState() => _AddEditKeywordDialogState();
}

class _AddEditKeywordDialogState extends State<AddEditKeywordDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    if (widget.currentKeyword != null) {
      nameController.text = widget.currentKeyword!.name;
    }

    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          widget.currentKeyword != null ? "Edit Keyword" : "Add Keyword",
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
              text: widget.currentKeyword != null ? "Edit" : "Add",
              onPressed: () async {
                Keyword newKeyword = Keyword(
                  name: nameController.text,
                );
                APIResult? result = await AddEditProductService.addEditkeyword(
                    data: Keyword.toJson(newKeyword),
                    keywordId: widget.currentKeyword != null &&
                            widget.currentKeyword!.id != null
                        ? widget.currentKeyword!.id
                        : null);
                if (result != null) {
                  if(mounted){
                  UpToast().showToast(
                    context: context,
                    text: result.message ?? "",
                  );}
                  if (mounted) {
                    Navigator.pop(
                      context,
                      "success",
                    );
                  }
                } else {if(mounted){
                  UpToast().showToast(
                    context: context,
                    text: "An Error Occurred",
                  );}
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
