import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:shop/is_user_admin.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/dialogs/media_dialog.dart';
import 'package:shop/models/gallery.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminGalleryMob extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AdminGalleryMob({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AdminGalleryMob> createState() => _AdminGalleryMobState();
}

class _AdminGalleryMobState extends State<AdminGalleryMob> {
  List<Gallery> gallery = [];
  TextEditingController nameController = TextEditingController();
  List<int> selectedMediaList = [];
  Gallery selectedGallery = const Gallery(mediaList: [], name: "", id: -1);
  @override
  void initState() {
    super.initState();
  }

  getAllGallery() async {
    gallery = await AddEditProductService.getGallery();
    setState(() {});
  }

  _openMediaDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const MediaDialog();
        }).then((newMedia) {
      if (newMedia != null) {
        if (selectedMediaList.every((element) => element != newMedia)) {
          selectedMediaList.add(newMedia);
          setState(() {});
        }
      }
    });
  }

  _updateGallery() async {
    if (nameController.text.isNotEmpty && selectedMediaList.isNotEmpty) {
      Gallery gallery = Gallery(
        name: nameController.text,
        mediaList: selectedMediaList,
      );
      APIResult? result = await AddEditProductService.addEditGallery(
          data: Gallery.toJson(gallery),
          galleryId: selectedGallery.id != -1 ? selectedGallery.id! : null);
      if (result != null) {
        if (context.mounted) {
          UpToast().showToast(
            context: context,
            text: result.message ?? "",
          );
        }
        if (selectedGallery.id == -1) {
          selectedMediaList.clear();
          nameController.text = "";
        }

        getAllGallery();
      } else {
        if (context.mounted) {
          UpToast().showToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    } else {
      UpToast().showToast(context: context, text: "Please enter all fields");
    }
  }

  _deleteGallery(int galleryId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteGallery(galleryId);
        if (result != null && result.success) {
          if (context.mounted) {
            UpToast().showToast(context: context, text: result.message ?? "");
          }
          selectedGallery = const Gallery(name: "", mediaList: [], id: -1);
          nameController.text = "";
          selectedMediaList.clear();
          getAllGallery();
        } else {
          if (context.mounted) {
            UpToast().showToast(
              context: context,
              text: "An Error Occurred",
            );
          }
        }
      }
    });
  }

  _deleteDialog(int id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        if (selectedMediaList.any((element) => element == id)) {
          selectedMediaList.remove(id);
          setState(() {});
        }
      }
    });
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: UpCard(
        style: UpStyle(cardWidth: 310, cardBodyPadding: false),
        body: Container(
          color: UpConfig.of(context).theme.baseColor,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              GestureDetector(
                  onTap: (() {
                    selectedGallery =
                        const Gallery(name: "", mediaList: [], id: -1);
                    nameController.text = selectedGallery.name ?? "";
                    selectedMediaList = [];
                    Navigator.pop(context);
                    setState(() {});
                  }),
                  child: Container(
                    color: selectedGallery.id == -1
                        ? UpConfig.of(context).theme.primaryColor
                        : Colors.transparent,
                    child: UpListTile(
                      title: ("Create a new gallery"),
                      style: UpStyle(
                        textColor: selectedGallery.id == -1
                            ? UpThemes.getContrastColor(
                                UpConfig.of(context).theme.primaryColor)
                            : UpConfig.of(context).theme.baseColor.shade900,
                      ),
                    ),
                  )),
              ...gallery
                  .map(
                    (e) => GestureDetector(
                      onTap: (() {
                        selectedGallery = e;
                        nameController.text = selectedGallery.name ?? "";
                        selectedMediaList = selectedGallery.mediaList;
                        Navigator.pop(context);
                        setState(() {});
                      }),
                      child: Container(
                        color: selectedGallery.id == e.id
                            ? UpConfig.of(context).theme.primaryColor
                            : Colors.transparent,
                        child: UpListTile(
                          title: (e.name ?? ""),
                          style: UpStyle(
                            textColor: selectedGallery.id == e.id
                                ? UpThemes.getContrastColor(
                                    UpConfig.of(context).theme.primaryColor)
                                : UpConfig.of(context).theme.baseColor.shade900,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      endDrawer: SafeArea(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Drawer(
            child: leftSide(),
          );
        }),
      ),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (gallery.isEmpty) {
                  if (state.gallery != null && state.gallery!.isNotEmpty) {
                    gallery = state.gallery!.toList();
                  }
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        UpCard(
                          style: UpStyle(
                              cardRadius: 8,
                              cardWidth:
                                  MediaQuery.of(context).size.width - 32),
                          header: Center(
                            child: UpText(
                              selectedGallery.id == -1
                                  ? "Create Gallery"
                                  : "Update Gallery",
                              style: UpStyle(
                                  textSize: 24,
                                  textFontStyle: FontStyle.italic),
                            ),
                          ),
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        child: UpTextField(
                                          controller: nameController,
                                          label: 'Name',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: UpText(
                                              "Images",
                                              type: UpTextType.heading6,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          children: [
                                            selectedMediaList.isNotEmpty
                                                ? Wrap(
                                                    children: selectedMediaList
                                                        .map((e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: SizedBox(
                                                                width: 100,
                                                                height: 100,
                                                                child: Stack(
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            100,
                                                                        child:
                                                                            MediaWidget(
                                                                          mediaId:
                                                                              e,
                                                                        )),
                                                                    InkWell(
                                                                      onTap:
                                                                          (() {
                                                                        _deleteDialog(
                                                                            e);
                                                                      }),
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child:
                                                                            const UpIcon(
                                                                          icon:
                                                                              Icons.cancel,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                        .toList())
                                                : const SizedBox(),
                                            GestureDetector(
                                              onTap: (() {
                                                _openMediaDialog();
                                              }),
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 100,
                                                      child: Image.asset(
                                                        "ef3-placeholder-image.jpg",
                                                      ),
                                                      // color: Colors.grey,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: UpIcon(
                                                        icon: Icons.add_a_photo,
                                                        style: UpStyle(
                                                            iconSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: selectedGallery.id != -1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 70,
                                                height: 30,
                                                child: UpButton(
                                                  onPressed: () {
                                                    _deleteGallery(
                                                        selectedGallery.id!);
                                                  },
                                                  text: "Delete",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 70,
                                              height: 30,
                                              child: UpButton(
                                                onPressed: () {
                                                  _updateGallery();
                                                },
                                                text: "Save",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
