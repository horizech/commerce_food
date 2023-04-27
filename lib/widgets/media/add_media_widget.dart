import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/media_dialog.dart';
import 'package:shop/widgets/media/media_widget.dart';

class AddMediaWidget extends StatefulWidget {
  final int? selectedMedia;
  final Function? onChnage;
  const AddMediaWidget({Key? key, this.selectedMedia, this.onChnage})
      : super(key: key);

  @override
  State<AddMediaWidget> createState() => _AddMediaWidgetState();
}

class _AddMediaWidgetState extends State<AddMediaWidget> {
  _openMediaDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const MediaDialog();
        }).then((media) {
      if (media != null) {
        if (widget.onChnage != null) {
          widget.onChnage!(media);
        }
        // selectedMedia = media;
        // setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const UpText("Thumbnail"),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SizedBox(
                width: 70,
                child: UpButton(
                  text: "Select",
                  style: UpStyle(
                    buttonHoverBackgroundColor:
                        UpConfig.of(context).theme.primaryColor[200],
                    buttonBorderColor: Colors.transparent,
                    buttonHoverBorderColor: Colors.transparent,
                    buttonBackgroundColor:
                        UpConfig.of(context).theme.primaryColor[100],
                  ),
                  onPressed: () {
                    _openMediaDialog();
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Visibility(
                visible: widget.selectedMedia == null,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "ef3-placeholder-image.jpg",
                  ),
                  // color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Visibility(
                visible: widget.selectedMedia != null,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: MediaWidget(
                    mediaId: widget.selectedMedia,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
