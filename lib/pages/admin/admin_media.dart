import 'dart:typed_data';

import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/is_user_admin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/models/media.dart';
import 'package:shop/widgets/app_bars/admin_appbar.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/media/media_service.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminMedia extends StatefulWidget {
  const AdminMedia({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminMedia> createState() => _AdminMediaState();
}

class _AdminMediaState extends State<AdminMedia> {
  List<Media> media = [];
  TextEditingController nameController = TextEditingController();
  Media selectedMedia = const Media(id: -1, name: "");
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    getMedia();
  }

  getMedia({String? message}) async {
    media = await MediaService.getAllMedia() ?? [];
    if (media.isNotEmpty) {
      if (message != null && message.isNotEmpty) {
        isUploading = false;
        if (mounted) {
          UpToast().showToast(context: context, text: message);
        }
      }
      setState(() {});
    }
  }

  uploadMedia() async {
    final ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      isUploading = true;
      setState(() {});
      await pickedImage.readAsBytes().then((Uint8List list) async {
        APIResult? result =
            await MediaService.uploadMedia(list, pickedImage.name);
        if (result != null && result.success) {
          getMedia(message: result.message);
        }
        return null;
      });
    }
  }

  Widget leftSide() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: UpCard(
          style: UpStyle(cardWidth: 300),
          body: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 80),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  GestureDetector(
                      onTap: (() {
                        selectedMedia = const Media(name: "", id: -1);
                        nameController.text = selectedMedia.name;

                        setState(() {});
                      }),
                      child: Container(
                        color: selectedMedia.id == -1
                            ? UpConfig.of(context).theme.primaryColor
                            : Colors.transparent,
                        child: UpListTile(
                          title: ("Create a new media"),
                          style: UpStyle(
                            listTileTextColor: selectedMedia.id == -1
                                ? UpThemes.getContrastColor(
                                    UpConfig.of(context).theme.primaryColor)
                                : UpConfig.of(context)
                                    .theme
                                    .baseColor
                                    .shade900,
                          ),
                        ),
                      )),
                  ...media
                      .map(
                        (e) => GestureDetector(
                          onTap: (() {
                            selectedMedia = e;
                            nameController.text = selectedMedia.name;
                            setState(() {});
                          }),
                          child: Container(
                            color: selectedMedia.id == e.id
                                ? UpConfig.of(context).theme.primaryColor
                                : Colors.transparent,
                            child: ListTile(
                              title: UpText(e.name),
                            ),
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: const AdminAppbar(),
      drawer: const NavDrawer(),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    leftSide(),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: SizedBox(
                    //     width: 150,
                    //     height: 20,
                    //     child: UpButton(
                    //         text: "Media",
                    //         onPressed: () {
                    //           uploadMedia();
                    //         }),
                    //   ),
                    // )

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: 400,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: UpText(
                                      "Media",
                                      type: UpTextType.heading6,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: selectedMedia.id == -1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 150,
                                          height: 50,
                                          child: UpButton(
                                            text: "Upload Media",
                                            onPressed: () {
                                              uploadMedia();
                                            },
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isUploading == true,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: UpCircularProgress(
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: selectedMedia.id != -1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: MediaWidget(
                                            media: selectedMedia,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                    )
                  ],
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
