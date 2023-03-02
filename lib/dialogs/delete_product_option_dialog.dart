import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';

class DeleteProductOptionDialog extends StatelessWidget {
  final int productOptionId;

  const DeleteProductOptionDialog({Key? key, required this.productOptionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.all(8.0),
        child: UpText(
          "Delete Product Option",
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
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: UpText(
                  "Are you sure you want to delete product option",
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
              text: "No",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: SizedBox(
            width: 100,
            child: UpButton(
              text: "Yes",
              onPressed: () async {
                APIResult? result =
                    await AddEditProductService.deleteProductOption(
                        productOptionId);
                if (result != null && result.success) {
                  showUpToast(context: context, text: result.message ?? "");
                  Navigator.pop(context, "success");
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
