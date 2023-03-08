import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/media.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/media/media_widget.dart';

class MediaDialog extends StatefulWidget {
  const MediaDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaDialog> createState() => _MediaDialogState();
}

class _MediaDialogState extends State<MediaDialog> {
  @override
  void initState() {
    super.initState();
    getMedia();
  }

  Media? selectedMedia;
  List<Media> mediaList = [];
  getMedia() async {
    mediaList = await AddEditProductService.getMedia();

    if (mediaList.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.all(8.0),
        child: UpText(
          "Select Media",
        ),
      ),
      actionsPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      content: mediaList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                  height: 500,
                  width: 500,
                  child: Wrap(
                    children: mediaList
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: selectedMedia == e
                                            ? UpConfig.of(context)
                                                .theme
                                                .primaryColor
                                            : Colors.transparent)),
                                child: SizedBox(
                                  width: 98,
                                  height: 98,
                                  child: MediaWidget(
                                    media: e,
                                    onChange: () {
                                      selectedMedia = e;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  )))
          : const SizedBox(
              width: 500,
              height: 500,
              child: Center(child: UpCircularProgress())),
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
              text: "Select",
              onPressed: () {
                if (selectedMedia != null) {
                  Navigator.pop(context, selectedMedia!.id);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
