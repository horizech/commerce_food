import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/constants.dart';

class AddEditProductMetaWidget extends StatefulWidget {
  final Map<String, dynamic>? meta;
  final Function onChange;
  const AddEditProductMetaWidget({
    Key? key,
    required this.onChange,
    this.meta,
  }) : super(key: key);

  @override
  State<AddEditProductMetaWidget> createState() =>
      _AddEditProductMetaWidgetState();
}

class _AddEditProductMetaWidgetState extends State<AddEditProductMetaWidget> {
  Map<String, dynamic> newMeta = {};
  Map<String, dynamic> performanceMeta = {};
  Map<String, dynamic> featuresMeta = {};

  addFlavours(String key, String value) {
    performanceMeta[key] = value;
    newMeta["Flavours"] = performanceMeta;
    widget.onChange(newMeta);
  }

  // features(String key, bool value) {
  //   featuresMeta[key] = value;
  //   newMeta["Features"] = featuresMeta;
  //   widget.onChange(newMeta);
  // }

  @override
  void initState() {
    super.initState();
    if (widget.meta != null && widget.meta!.isNotEmpty) {
      if ((widget.meta!["Flavours"] as Map<String, dynamic>).isNotEmpty) {
        (widget.meta!["Flavours"] as Map<String, dynamic>)
            .forEach((key, value) {
          performanceMeta[key] = value;
        });
      }
      // if ((widget.meta!["Features"] as Map<String, dynamic>).isNotEmpty) {
      //   (widget.meta!["Features"] as Map<String, dynamic>)
      //       .forEach((key, value) {
      //     featuresMeta[key] = value;
      //   });
      // }
    }
    newMeta["Flavours"] = performanceMeta;
    // newMeta["Features"] = featuresMeta;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...flavours.keys.map(
          (key) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: UpTextField(
                initialValue: widget.meta != null &&
                        widget.meta!.isNotEmpty &&
                        (widget.meta!["Flavours"] as Map<String, dynamic>)
                            .isNotEmpty
                    ? (widget.meta!["Flavours"] as Map<String, dynamic>)[key]
                    : "",
                label: flavours[key],
                onChanged: ((value) => {
                      addFlavours(key, value ?? ""),
                    }),
              ),
            ),
          ),
        ),
        // ...automobileFeatures.keys.map(
        //   (key) => Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: UpCheckbox(
        //       initialValue: widget.meta != null &&
        //               widget.meta!.isNotEmpty &&
        //               (widget.meta!["Features"] as Map<String, dynamic>)
        //                   .isNotEmpty &&
        //               (widget.meta!["Features"] as Map<String, dynamic>)[key] !=
        //                   null
        //           ? (widget.meta!["Features"] as Map<String, dynamic>)[key]
        //           : false,
        //       label: automobileFeatures[key],
        //       onChange: ((value) => {
        //             features(key, value ?? ""),
        //           }),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
