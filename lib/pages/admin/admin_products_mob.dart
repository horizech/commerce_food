import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/pages/admin/admin_product.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/media/add_media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProductsMob extends StatefulWidget {
  const AdminProductsMob({Key? key}) : super(key: key);

  @override
  State<AdminProductsMob> createState() => _AdminProductsMobState();
}

class _AdminProductsMobState extends State<AdminProductsMob> {
  User? user;
  int? selectedMedia;
  List<UpLabelValuePair> collectionDropdown = [];
  String currentParent = "";
  List<Collection> collections = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController mediaController = TextEditingController();
  bool isAuthorized = false;
  Collection selectedCollection = const Collection(name: "", id: -1);
  int view = 1;
  Product? currentProduct;
  bool isExpanded = false;
  bool isReset = false;
  @override
  void initState() {
    super.initState();
    user ??= Apiraiser.authentication.getCurrentUser();
    if (user != null && user!.roleIds != null) {
      if (user!.roleIds!.contains(2) || user!.roleIds!.contains(1)) {
        isAuthorized = true;
      }
    }
  }

  getCollections() async {
    collections = await AddEditProductService.getCollections() ?? collections;
    if (collections.isNotEmpty) {
      _getCollectionDropdown();
      setState(() {});
    }
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
                    selectedCollection = const Collection(name: "", id: -1);
                    nameController.text = selectedCollection.name;
                    // currentParent = "";
                    selectedMedia = null;
                    view = 1;
                    isReset = false;
                    setState(() {});
                    Navigator.pop(context);
                  }),
                  child: Container(
                    color: selectedCollection.id == -1
                        ? UpConfig.of(context).theme.primaryColor
                        : Colors.transparent,
                    child: UpListTile(
                      leading: UpIcon(
                        icon: Icons.add,
                        style: UpStyle(
                          textColor: selectedCollection.id == -1
                              ? UpThemes.getContrastColor(
                                  UpConfig.of(context).theme.primaryColor)
                              : UpConfig.of(context).theme.baseColor.shade900,
                        ),
                      ),
                      title: "Create a new collection",
                      style: UpStyle(
                        textColor: selectedCollection.id == -1
                            ? UpThemes.getContrastColor(
                                UpConfig.of(context).theme.primaryColor)
                            : UpConfig.of(context).theme.baseColor.shade900,
                      ),
                    ),
                  )),
              ...collections
                  .map(
                    (e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: selectedCollection.id != e.id,
                          child: GestureDetector(
                            onTap: (() {
                              selectedCollection = e;
                              nameController.text = selectedCollection.name;
                              mediaController.text =
                                  selectedCollection.media.toString();
                              currentParent = selectedCollection.parent != null
                                  ? selectedCollection.parent.toString()
                                  : "";
                              selectedMedia = selectedCollection.media;
                              view = 1;
                              setState(() {
                                isExpanded = true;
                              });

                              // Navigator.pop(context);
                            }),
                            child: Container(
                              color: selectedCollection.id == e.id
                                  ? UpConfig.of(context).theme.baseColor[200]
                                  : Colors.transparent,
                              child: UpListTile(
                                leading: const UpIcon(
                                  icon: Icons.edit,
                                ),
                                title: (e.name),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: selectedCollection.id == e.id &&
                                selectedCollection.id != -1,
                            child: Container(
                              color: isExpanded
                                  ? UpConfig.of(context).theme.baseColor[200]
                                  : Colors.transparent,
                              child: UpExpansionTile(
                                onExpansionChanged: (p0) {
                                  isExpanded = p0;

                                  if (p0) {
                                    view = 1;
                                  } else {}
                                  setState(() {});
                                },
                                leading: const UpIcon(
                                  icon: Icons.edit,
                                ),
                                title: e.name,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                expandedAlignment: Alignment.topLeft,
                                childrenPadding: const EdgeInsets.all(0),
                                initiallyExpanded: true,
                                children: <Widget>[
                                  UpCard(
                                    body: Column(children: [
                                      GestureDetector(
                                        onTap: () {
                                          currentProduct = null;
                                          view = 2;
                                          isReset = true;
                                          isExpanded = false;
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          color: view == 2
                                              ? UpConfig.of(context)
                                                  .theme
                                                  .primaryColor
                                              : Colors.transparent,
                                          child: UpListTile(
                                            leading: UpIcon(
                                              icon: Icons.playlist_add_outlined,
                                              style: UpStyle(
                                                iconColor: view == 2
                                                    ? UpThemes.getContrastColor(
                                                        UpConfig.of(context)
                                                            .theme
                                                            .primaryColor)
                                                    : UpConfig.of(context)
                                                        .theme
                                                        .baseColor
                                                        .shade900,
                                              ),
                                            ),
                                            title: ("Create a new product"),
                                            style: UpStyle(
                                              textColor: view == 2
                                                  ? UpThemes.getContrastColor(
                                                      UpConfig.of(context)
                                                          .theme
                                                          .primaryColor)
                                                  : UpConfig.of(context)
                                                      .theme
                                                      .baseColor
                                                      .shade900,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (() {
                                          isExpanded = false;

                                          view = 3;
                                          isReset = false;
                                          setState(() {});
                                          Navigator.pop(context);
                                        }),
                                        child: Container(
                                          color: view == 3 || view == 4
                                              ? UpConfig.of(context)
                                                  .theme
                                                  .primaryColor
                                              : Colors.transparent,
                                          child: UpListTile(
                                            style: UpStyle(
                                              listTileTextColor: view == 3 ||
                                                      view == 4
                                                  ? UpThemes.getContrastColor(
                                                      UpConfig.of(context)
                                                          .theme
                                                          .primaryColor)
                                                  : UpConfig.of(context)
                                                      .theme
                                                      .baseColor
                                                      .shade900,
                                            ),
                                            leading: UpIcon(
                                              icon: Icons.list,
                                              style: UpStyle(
                                                iconColor: view == 3 ||
                                                        view == 4
                                                    ? UpThemes.getContrastColor(
                                                        UpConfig.of(context)
                                                            .theme
                                                            .primaryColor)
                                                    : UpConfig.of(context)
                                                        .theme
                                                        .baseColor
                                                        .shade900,
                                              ),
                                            ),
                                            title: ("All Products"),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget rightView() {
    if (view == 2) {
      return AdminProduct(
        isReset: isReset,
        collection: selectedCollection,
      );
    } else if (view == 3) {
      return allProductsView();
    } else if (view == 4) {
      return AdminProduct(
        collection: selectedCollection,
        currentProduct: currentProduct,
      );
    } else {
      return editCollectionView();
    }
  }

  Widget allProductsView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: Visibility(
        visible: selectedCollection.id != -1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: UpText(
                      "Products",
                      type: UpTextType.heading5,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Product>>(
              future: ProductService.getProducts(
                  [selectedCollection.id!], {}, null, "", {}),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...snapshot.data!.map((e) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  UpText(
                                                    e.name,
                                                    style: UpStyle(
                                                      textSize: 16,
                                                      textWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  UpText(
                                                    e.description ?? "",
                                                    style:
                                                        UpStyle(textSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      view = 4;
                                                      currentProduct = e;
                                                      setState(() {});
                                                    },
                                                    child: UpIcon(
                                                      icon: Icons.edit,
                                                      style:
                                                          UpStyle(iconSize: 20),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _deleteProduct(e.id!);
                                                    },
                                                    child: UpIcon(
                                                      icon: Icons.delete,
                                                      style:
                                                          UpStyle(iconSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))
                                ]),
                          ),
                        )
                      : const Center(
                          child: SizedBox(),
                        );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: UpCircularProgress(
                      width: 20,
                      height: 20,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget editCollectionView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        UpCard(
          header: Center(
            child: UpText(
              selectedCollection.id == -1
                  ? "Create collection"
                  : "Update collection",
              style: UpStyle(textSize: 24, textFontStyle: FontStyle.italic),
            ),
          ),
          style: UpStyle(
              cardRadius: 8, cardWidth: MediaQuery.of(context).size.width - 32),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: UpTextField(
                          controller: nameController,
                          label: 'Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: AddMediaWidget(
                          selectedMedia: selectedMedia,
                          onChnage: (media) {
                            selectedMedia = media;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: UpDropDown(
                            label: "Parent",
                            value: currentParent,
                            itemList: collectionDropdown,
                            onChanged: (value) {
                              currentParent = value.toString();

                              setState(() {});
                            },
                          )),
                    ),
                    Visibility(
                      visible: selectedCollection.id != -1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: const UpText(
                            "*To delete a collection you must need to delete all its products",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        children: [
                          Visibility(
                            visible: selectedCollection.id != -1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 120,
                                height: 40,
                                child: UpButton(
                                  onPressed: () {
                                    _deleteCollection(selectedCollection.id!);
                                  },
                                  text: "Delete",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              height: 40,
                              child: UpButton(
                                onPressed: () {
                                  _updateCollection(selectedCollection.id != -1
                                      ? selectedCollection
                                      : null);
                                },
                                text: "Save",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  _updateCollection(Collection? c) async {
    Collection collection = Collection(
      name: nameController.text,
      media: selectedMedia ?? 1,
      parent: currentParent.isNotEmpty ? int.parse(currentParent) : null,
    );
    APIResult? result = await AddEditProductService.addEditCollection(
        data: Collection.toJson(collection),
        collectionId: c != null ? c.id! : null);
    if (result != null && result.success) {
      if (context.mounted) {
        UpToast().showToast(
          context: context,
          text: result.message ?? "",
        );
      }
      getCollections();
    } else {
      if (context.mounted) {
        UpToast().showToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    }
  }

  _getCollectionDropdown() {
    collectionDropdown.clear();
    if (collectionDropdown.isEmpty) {
      collectionDropdown.add(
        UpLabelValuePair(label: "", value: "-1"),
      );
      if (collections.isNotEmpty) {
        for (var c in collections) {
          collectionDropdown
              .add(UpLabelValuePair(label: c.name, value: "${c.id}"));
        }
      }
    }
  }

  _deleteCollection(int collectionId) async {
    APIResult? result =
        await AddEditProductService.deleteCollection(collectionId);
    if (result != null && result.success) {
      if (context.mounted) {
        UpToast().showToast(context: context, text: result.message ?? "");
      }
      selectedCollection = const Collection(name: "", id: -1);
      nameController.text = "";
      mediaController = TextEditingController();
      // currentParent = "";
      getCollections();
    } else {
      if (context.mounted) {
        UpToast().showToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    }
  }

  _deleteProduct(int productId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteProduct(productId);
        if (result != null && result.success) {
          if (context.mounted) {
            UpToast().showToast(
              context: context,
              text: result.message ?? "",
            );
          }
          setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      endDrawer: SafeArea(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Drawer(
            backgroundColor: UpConfig.of(context).theme.basicColor,
            child: leftSide(),
          );
        }),
      ),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (collections.isEmpty) {
                  if (state.collections != null) {
                    collections = state.collections!.toList();
                  }
                  _getCollectionDropdown();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rightView(),
                    ],
                  ),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
