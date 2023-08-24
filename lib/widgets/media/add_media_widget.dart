import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/media_dialog.dart';
import 'package:shop/widgets/media/media_widget.dart';

class AddMediaWidget extends StatefulWidget {
  final int? selectedMedia;
  final String? title;
  final Function? onChnage;
  const AddMediaWidget(
      {Key? key, this.selectedMedia, this.title, this.onChnage})
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
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: UpText(widget.title ?? "Thumbnail :")),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 26.0,
              ),
              child: SizedBox(
                width: 120,
                child: UpButton(
                  text: "Select",
                  onPressed: () {
                    _openMediaDialog();
                  },
                ),
              ),
            ),
            const SizedBox(width: 20),
            Wrap(
              direction: Axis.horizontal,
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
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
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
        ),
      ],
    );
  }
}
