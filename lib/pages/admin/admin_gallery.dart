import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
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

class AdminGallery extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AdminGallery({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AdminGallery> createState() => _AdminGalleryState();
}

class _AdminGalleryState extends State<AdminGallery> {
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

  _updateGallery(Gallery? g) async {
    Gallery gallery = Gallery(
      name: nameController.text,
      mediaList: selectedMediaList,
    );
    APIResult? result = await AddEditProductService.addEditGallery(
        data: Gallery.toJson(gallery),
        galleryId: selectedGallery.id != -1 ? selectedGallery.id! : null);
    if (result != null) {
      showUpToast(
        context: context,
        text: result.message ?? "",
      );
      getAllGallery();
    } else {
      showUpToast(
        context: context,
        text: "An Error Occurred",
      );
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
          showUpToast(context: context, text: result.message ?? "");
          selectedGallery = const Gallery(name: "", mediaList: [], id: -1);
          nameController.text = "";

          getAllGallery();
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
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
      child: Container(
        color: Colors.grey[200],
        width: 300,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            GestureDetector(
                onTap: (() {
                  selectedGallery =
                      const Gallery(name: "", mediaList: [], id: -1);
                  nameController.text = selectedGallery.name ?? "";
                  selectedMediaList = [];
                  setState(() {});
                }),
                child: Container(
                  color: selectedGallery.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new gallery"),
                  ),
                )),
            ...gallery
                .map(
                  (e) => GestureDetector(
                    onTap: (() {
                      selectedGallery = e;
                      nameController.text = selectedGallery.name ?? "";
                      selectedMediaList = selectedGallery.mediaList;

                      setState(() {});
                    }),
                    child: Container(
                      color: selectedGallery.id == e.id
                          ? UpConfig.of(context).theme.primaryColor[100]
                          : Colors.transparent,
                      child: ListTile(
                        title: UpText(e.name ?? ""),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (gallery.isEmpty) {
            if (state.gallery != null && state.gallery!.isNotEmpty) {
              gallery = state.gallery!.toList();
            }
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    leftSide(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        top: 10,
                      ),
                      child: SizedBox(
                        width: 350,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: UpText(
                                "Gallery",
                                type: UpTextType.heading5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Stack(
                                                          children: [
                                                            SizedBox(
                                                                width: 100,
                                                                height: 100,
                                                                child:
                                                                    MediaWidget(
                                                                  mediaId: e,
                                                                )),
                                                            InkWell(
                                                              onTap: (() {
                                                                _deleteDialog(
                                                                    e);
                                                              }),
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    const UpIcon(
                                                                  icon: Icons
                                                                      .cancel,
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
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 100,
                                              child: Image.asset(
                                                "ef3-placeholder-image.jpg",
                                              ),
                                              // color: Colors.grey,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: UpIcon(
                                                icon: Icons.add_a_photo,
                                                style: UpStyle(iconSize: 20),
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: selectedGallery.id != -1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 70,
                                        height: 30,
                                        child: UpButton(
                                          onPressed: () {
                                            _deleteGallery(selectedGallery.id!);
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
                                          _updateGallery(
                                              selectedGallery.id != -1
                                                  ? selectedGallery
                                                  : null);
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
