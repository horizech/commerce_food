import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/pages/admin/admin_product.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/media/add_media_widget.dart';
import 'package:shop/widgets/app_bars/admin_appbar.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({Key? key}) : super(key: key);

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  int? selectedMedia;
  List<UpLabelValuePair> collectionDropdown = [];
  String currentParent = "";
  List<Collection> collections = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController mediaController = TextEditingController();
  Collection selectedCollection = const Collection(name: "", id: -1);
  int view = 1;
  Product? currentProduct;
  bool isExpanded = false;
  bool isReset = false;
  @override
  void initState() {
    super.initState();
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
      child: Container(
        color: Colors.grey[200],
        width: 300,
        height: MediaQuery.of(context).size.height,
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
                }),
                child: Container(
                  color: selectedCollection.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new collection"),
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
                            isExpanded = true;
                            setState(() {});
                          }),
                          child: Container(
                            color: selectedCollection.id == e.id
                                ? UpConfig.of(context).theme.primaryColor[100]
                                : Colors.transparent,
                            child: ListTile(
                              title: UpText(e.name),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: selectedCollection.id == e.id &&
                              selectedCollection.id != -1,
                          child: Container(
                            color: isExpanded
                                ? UpConfig.of(context).theme.primaryColor[100]
                                : Colors.grey[200],
                            child: UpExpansionTile(
                              onExpansionChanged: (p0) {
                                isExpanded = p0;
                                if (p0) {
                                  view = 1;
                                } else {}
                                setState(() {});
                              },
                              title: e.name,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.topLeft,
                              childrenPadding: const EdgeInsets.all(0),
                              initiallyExpanded: true,
                              children: <Widget>[
                                Container(
                                  color: Colors.grey[200],
                                  child: Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        currentProduct = null;
                                        view = 2;
                                        isReset = true;
                                        isExpanded = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                        color: view == 2
                                            ? UpConfig.of(context)
                                                .theme
                                                .primaryColor[100]
                                            : Colors.transparent,
                                        child: const ListTile(
                                          title: UpText("Create a new product"),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (() {
                                        isExpanded = false;

                                        view = 3;
                                        isReset = false;
                                        setState(() {});
                                      }),
                                      child: Container(
                                        color: view == 3 || view == 4
                                            ? UpConfig.of(context)
                                                .theme
                                                .primaryColor[100]
                                            : Colors.transparent,
                                        child: const ListTile(
                                          title: UpText("All Products"),
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
      width: 500,
      child: Visibility(
        visible: selectedCollection.id != -1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
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
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: 400,
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
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                view = 4;
                                                currentProduct = e;
                                                setState(() {});
                                              },
                                              child: UpIcon(
                                                icon: Icons.edit,
                                                style: UpStyle(iconSize: 20),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _deleteProduct(e.id!);
                                              },
                                              child: UpIcon(
                                                icon: Icons.delete,
                                                style: UpStyle(iconSize: 20),
                                              ),
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
    return SizedBox(
      width: 400,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Align(
          alignment: Alignment.topLeft,
          child: UpText(
            "Collection",
            type: UpTextType.heading6,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
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
              width: 300,
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
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              child: UpText(
                "*To delete a collection you must need to delete all its products",
              ),
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: selectedCollection.id != -1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 70,
                    height: 30,
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
                  width: 70,
                  height: 30,
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
      showUpToast(
        context: context,
        text: result.message ?? "",
      );
      getCollections();
    } else {
      showUpToast(
        context: context,
        text: "An Error Occurred",
      );
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
      showUpToast(context: context, text: result.message ?? "");
      selectedCollection = const Collection(name: "", id: -1);
      nameController.text = "";
      mediaController = TextEditingController();
      // currentParent = "";
      getCollections();
    } else {
      showUpToast(
        context: context,
        text: "An Error Occurred",
      );
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
          showUpToast(
            context: context,
            text: result.message ?? "",
          );
          setState(() {});
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppbar(),
      drawer: const NavDrawer(),
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
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          leftSide(),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 50.0,
                                right: 20,
                                top: 10,
                              ),
                              child: SizedBox(
                                child: Center(
                                  child: rightView(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : const UnAuthorizedWidget(),
    );
  }
}
