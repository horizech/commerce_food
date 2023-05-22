import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/services/products_service.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_combo.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/media/add_media_widget.dart';
import 'package:shop/widgets/media/gallery_dropdown.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminCombosMob extends StatefulWidget {
  final Map<String, String>? queryParams;

  const AdminCombosMob({Key? key, this.queryParams}) : super(key: key);

  @override
  State<AdminCombosMob> createState() => _AdminCombosMobState();
}

class _AdminCombosMobState extends State<AdminCombosMob> {
  List<Product> products = [];
  int? selectedMedia;

  List<UpLabelValuePair> productsDropdown = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<Combo> combos = [];
  List<ProductCombo> productCombos = [];
  String currentSelectedProduct = "";
  List<Product> comboBasedProducts = [];
  int? gallery;
  Combo selectedCombo = const Combo(name: "", price: 0, id: -1);
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }
getAllProducts() async {
    products = await ProductService.getProducts([], {}, null, null, {});
    setState(() {});
  }

  getCombos() async {
    combos = await AddEditProductService.getCombos() ?? combos;
    if (combos.isNotEmpty) {
      setState(() {});
    }
  }

  getProductCombos() async {
    productCombos =
        await AddEditProductService.getProductCombos() ?? productCombos;
    if (productCombos.isNotEmpty) {
      _setProducts();
      setState(() {});
    }
  }

  _updateCombos(Combo? c) async {
    Combo combo = Combo(
        name: nameController.text,
        price: priceController.text.isNotEmpty
            ? double.parse(priceController.text)
            : 0,
        gallery: gallery,
        thumbnail: selectedMedia ?? 1,
        description: descriptionController.text);
    APIResult? result = await AddEditProductService.addEditCombos(
        data: Combo.toJson(combo), comboId: c != null ? c.id! : null);
    if (result != null && result.success) {
      if(mounted){
      UpToast().showToast(
        context: context,
        text: result.message ?? "",
      );}
      getCombos();
    } else {if(mounted){
      UpToast().showToast(
        context: context,
        text: "An Error Occurred",
      );}
    }
  }

  _deleteCombo(int comboId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result = await AddEditProductService.deleteCombo(comboId);
        if (result != null && result.success) {if(mounted){
          UpToast().showToast(context: context, text: result.message ?? "");}
          selectedCombo =
              const Combo(name: "", price: 0, id: -1, thumbnail: null);
          nameController.text = "";
          priceController = TextEditingController();
          descriptionController.text = "";
          selectedMedia = null;
          getCombos();
        } else {if(mounted){
          UpToast().showToast(
            context: context,
            text: "An Error Occurred",
          );}
        }
      }
    });
  }

  _addProductCombo() async {
    if (currentSelectedProduct.isNotEmpty &&
        selectedCombo.id != null &&
        selectedCombo.id != -1) {
      ProductCombo productCombo = ProductCombo(
          product: int.parse(currentSelectedProduct), combo: selectedCombo.id!);
      APIResult? result = await AddEditProductService.insertProductCombo(
          ProductCombo.toJson(productCombo));
      if (result != null && result.success) {
        if(mounted){
        UpToast().showToast(
          context: context,
          text: result.message ?? "",
        );}

        getProductCombos();
      } else {
        if(mounted){
        UpToast().showToast(
          context: context,
          text: "An Error Occurred",
        );}
      }
    }
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.grey[200],
        width: 300,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 60,
        ),
        child: Column(
          children: [
            GestureDetector(
                onTap: (() {
                  selectedCombo = const Combo(name: "", price: 0, id: -1);
                  nameController.text = selectedCombo.name;
                  priceController = TextEditingController();
                  descriptionController.text = selectedCombo.description ?? "";
                  selectedMedia = null;
                  setState(() {});
                  Navigator.pop(context);
                }),
                child: Container(
                  color: selectedCombo.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new combo"),
                  ),
                )),
            ...combos
                .map(
                  (e) => GestureDetector(
                    onTap: (() {
                      selectedCombo = e;
                      nameController.text = selectedCombo.name;
                      priceController.text = selectedCombo.price.toString();
                      descriptionController.text =
                          selectedCombo.description ?? "";
                      gallery = selectedCombo.gallery;
                      selectedMedia = selectedCombo.thumbnail;
                      _setProducts();
                      Navigator.pop(context);
                      setState(() {});
                    }),
                    child: Container(
                      color: selectedCombo.id == e.id
                          ? UpConfig.of(context).theme.primaryColor[100]
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
    );
  }

  _deleteProductCombo(int productId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        if (productCombos.any((element) =>
            element.combo == selectedCombo.id &&
            element.product == productId)) {
          int id = productCombos
              .where((element) =>
                  element.combo == selectedCombo.id &&
                  element.product == productId)
              .first
              .id!;
          APIResult? result =
              await AddEditProductService.deleteProductCombo(id);
          if (result != null && result.success) {
            if(mounted){
            UpToast().showToast(
              context: context,
              text: result.message ?? "",
            );}

            getProductCombos();
          } else {if(mounted){
            UpToast().showToast(
              context: context,
              text: "An Error Occurred",
            );}
          }
        }
      }
    });
  }

  _setProducts() {
    comboBasedProducts = [];
    if (selectedCombo.id != null && selectedCombo.id != -1) {
      List<int> productsIds = productCombos
          .where((element) => element.combo == selectedCombo.id)
          .map((e) => e.product)
          .toList();

      for (var element in productsIds) {
        comboBasedProducts
            .add(products.where((product) => product.id == element).first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ? products.isNotEmpty
              ? BlocConsumer<StoreCubit, StoreState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (combos.isEmpty) {
                      if (state.combos != null && state.combos!.isNotEmpty) {
                        combos = state.combos!.toList();
                      }
                    }
                    if (productCombos.isEmpty) {
                      if (state.productCombos != null &&
                          state.productCombos!.isNotEmpty) {
                        productCombos = state.productCombos!.toList();
                      }
                    }

                    if (productsDropdown.isEmpty) {
                      if (products.isNotEmpty) {
                        for (var product in products) {
                          productsDropdown.add(
                            UpLabelValuePair(
                                label: product.name, value: "${product.id}"),
                          );
                        }
                      }
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            UpText(
                              selectedCombo.id == -1
                                  ? "Create Combo"
                                  : "Update Combo",
                              style: UpStyle(
                                  textSize: 24,
                                  textWeight: FontWeight.bold,
                                  textFontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: UpConfig.of(context)
                                          .theme
                                          .primaryColor,
                                      width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: UpTextField(
                                                controller: nameController,
                                                label: 'Name',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: UpTextField(
                                                controller:
                                                    descriptionController,
                                                label: 'Description',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: UpTextField(
                                                controller: priceController,
                                                label: 'Price',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: AddMediaWidget(
                                                selectedMedia: selectedMedia,
                                                onChnage: (media) {
                                                  selectedMedia = media;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GalleryDropdown(
                                                  gallery: gallery,
                                                  onChange: (value) {
                                                    gallery = int.parse(value);
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      selectedCombo.id != -1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: 70,
                                                      height: 30,
                                                      child: UpButton(
                                                        onPressed: () {
                                                          _deleteCombo(
                                                              selectedCombo
                                                                  .id!);
                                                        },
                                                        text: "Delete",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 70,
                                                    height: 30,
                                                    child: UpButton(
                                                      onPressed: () {
                                                        _updateCombos(
                                                            selectedCombo.id !=
                                                                    -1
                                                                ? selectedCombo
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Visibility(
                                      visible: selectedCombo.id != -1,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Divider(
                                                  color: UpConfig.of(context)
                                                      .theme
                                                      .primaryColor,
                                                  thickness: 1,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: UpText(
                                                    "Products",
                                                    type: UpTextType.heading4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: UpText(
                                                    "Add new product",
                                                    type: UpTextType.heading6,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            productsDropdown.isNotEmpty
                                                ? Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: UpDropDown(
                                                          value:
                                                              currentSelectedProduct,
                                                          label: "Product",
                                                          itemList:
                                                              productsDropdown,
                                                          onChanged: ((value) {
                                                            currentSelectedProduct =
                                                                value ?? "";

                                                            setState(() {});
                                                          }),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              6,
                                                          child: UpButton(
                                                            onPressed: () {
                                                              _addProductCombo();
                                                            },
                                                            text: "Add",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Visibility(
                                                  visible: comboBasedProducts
                                                      .isNotEmpty,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.7,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ...comboBasedProducts
                                                            .map(
                                                          (e) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              bottom: 8.0,
                                                            ),
                                                            child: Wrap(
                                                              direction:
                                                                  Axis.vertical,
                                                              children: [
                                                                Flexible(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      UpText(
                                                                        e.name,
                                                                        style:
                                                                            UpStyle(
                                                                          textSize:
                                                                              16,
                                                                          textWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              20),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          _deleteProductCombo(
                                                                              e.id!);
                                                                        },
                                                                        child:
                                                                            UpIcon(
                                                                          icon:
                                                                              Icons.delete,
                                                                          style:
                                                                              UpStyle(iconSize: 20),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: UpText(
                                                                    e.description ??
                                                                        "",
                                                                    style: UpStyle(
                                                                        textSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  })
              : const UpCircularProgress()
          : const UnAuthorizedWidget(),
    );
  }
}
