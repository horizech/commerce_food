import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:shop/models/gallery.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class GalleryDropdown extends StatefulWidget {
  final int? gallery;
  final Function? onChange;
  const GalleryDropdown({Key? key, this.gallery, this.onChange})
      : super(key: key);

  @override
  State<GalleryDropdown> createState() => _GalleryDropdownState();
}

class _GalleryDropdownState extends State<GalleryDropdown> {
  String? currentSelectedGallery;
  List<UpLabelValuePair> galleryDropdown = [];
  List<Gallery> gallery = [];
  @override
  void initState() {
    super.initState();
    if (widget.gallery != null) {
      currentSelectedGallery = "${widget.gallery}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (gallery.isEmpty) {
            if (state.gallery != null && state.gallery!.isNotEmpty) {
              gallery = state.gallery!.toList();
            }
            if (galleryDropdown.isEmpty) {
              if (gallery.isNotEmpty) {
                for (var g in gallery) {
                  galleryDropdown.add(
                    UpLabelValuePair(label: g.name ?? "", value: "${g.id}"),
                  );
                }
              }
            }
          }
          return UpDropDown(
            label: "Gallery",
            itemList: galleryDropdown,
            value: currentSelectedGallery,
            onChanged: ((value) {
              currentSelectedGallery = value;
              if (widget.onChange != null) {
                widget.onChange!(value);
              }
              setState(() {});
            }),
          );
        });
  }
}
