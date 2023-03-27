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
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminProductOptions extends StatefulWidget {
  const AdminProductOptions({Key? key}) : super(key: key);

  @override
  State<AdminProductOptions> createState() => _AdminProductOptionsState();
}

class _AdminProductOptionsState extends State<AdminProductOptions> {
  String currentAttribute = "";
  List<Attribute> attributes = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController attributeValueNameController = TextEditingController();
  List<AttributeValue> attributeValues = [];
  User? user;
  Attribute selectedAttribute = const Attribute(name: "", id: -1);
  List<AttributeValue> filteredAttributeValues = [];
  @override
  void initState() {
    super.initState();
    user ??= Apiraiser.authentication.getCurrentUser();
    getAttributes();
    getAttributeValues();
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
                  selectedAttribute = const Attribute(name: "", id: -1);
                  nameController.text = selectedAttribute.name;

                  setState(() {});
                }),
                child: Container(
                  color: selectedAttribute.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new attribute"),
                  ),
                )),
            ...attributes
                .map(
                  (e) => GestureDetector(
                    onTap: (() {
                      selectedAttribute = e;
                      nameController.text = selectedAttribute.name;
                      _setAttributeValues();
                      setState(() {});
                    }),
                    child: Container(
                      color: selectedAttribute.id == e.id
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

  _updateAttribute(Attribute? attribute) async {
    if (nameController.text.isNotEmpty) {
      Attribute newAttribute = Attribute(
        name: nameController.text,
      );
      APIResult? result = await AddEditProductService.addEditAttribute(
          data: newAttribute.toJson(newAttribute), attributeId: attribute?.id);

      if (result != null) {
        showUpToast(
          context: context,
          text: result.message ?? "",
        );
        if (attribute == null) {
          nameController.text = "";
        }
        getAttributes();
      } else {
        showUpToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    } else {
      showUpToast(
        context: context,
        text: "Please enter attribute name",
      );
    }
  }

  //by api
  getAttributes() async {
    List<Attribute>? newAttributes =
        await AddEditProductService.getAttributes();
    if (newAttributes != null && newAttributes.isNotEmpty) {
      attributes = newAttributes;

      setState(() {});
    }
  }

  getAttributeValues() async {
    if (selectedAttribute.id != -1) {
      List<AttributeValue>? newAttributeValues =
          await AddEditProductService.getAttributeValues();
      if (newAttributeValues != null && newAttributeValues.isNotEmpty) {
        attributeValues = newAttributeValues;
        _setAttributeValues();
        setState(() {});
      }
    }
  }

  _deleteAttribute(int attributeId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteAttribute(attributeId);
        if (result != null && result.success) {
          showUpToast(context: context, text: result.message ?? "");
          nameController.text = "";
          selectedAttribute = const Attribute(name: "", id: -1);
          getAttributes();
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    });
  }

  _deleteAttributeValue(int attributeValueId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteAttributeValue(attributeValueId);
        if (result != null && result.success) {
          showUpToast(context: context, text: result.message ?? "");
          getAttributeValues();
        } else {
          showUpToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    });
  }

  _updateAttributeValue() async {
    if (attributeValueNameController.text.isNotEmpty &&
        selectedAttribute.id != -1) {
      AttributeValue newAttributeValue = AttributeValue(
        name: attributeValueNameController.text,
        attribute: selectedAttribute.id!,
      );
      APIResult? result = await AddEditProductService.addEditAttributeValues(
        data: newAttributeValue.toJson(newAttributeValue),
      );
      if (result != null) {
        showUpToast(
          context: context,
          text: result.message ?? "",
        );
        attributeValueNameController.text = "";
        getAttributeValues();
      } else {
        showUpToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    } else {
      showUpToast(
        context: context,
        text: "Please enter attribute value name",
      );
    }
  }

  _setAttributeValues() {
    filteredAttributeValues = [];
    if (selectedAttribute.id != -1) {
      filteredAttributeValues = attributeValues
          .where((element) => element.attribute == selectedAttribute.id)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: user != null &&
              user!.roleIds != null &&
              (user!.roleIds!.contains(2) || user!.roleIds!.contains(1))
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (attributeValues.isEmpty) {
                  if (state.attributeValues != null &&
                      state.attributeValues!.isNotEmpty) {
                    attributeValues = state.attributeValues!.toList();
                  }
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftSide(),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 300,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20,
                                top: 10,
                              ),
                              child: SizedBox(
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: UpText(
                                          "Attribute",
                                          type: UpTextType.heading5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 300,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: UpTextField(
                                                controller: nameController,
                                                label: 'Name',
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  selectedAttribute.id != -1,
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: UpText(
                                                    "*To delete an attribute you must need to delete its attribute values"),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      selectedAttribute.id !=
                                                          -1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: 70,
                                                      height: 30,
                                                      child: UpButton(
                                                        onPressed: () {
                                                          _deleteAttribute(
                                                              selectedAttribute
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
                                                        _updateAttribute(
                                                          selectedAttribute
                                                                      .id !=
                                                                  -1
                                                              ? selectedAttribute
                                                              : null,
                                                        );
                                                      },
                                                      text: "Save",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 400,
                                      child: Visibility(
                                        visible: selectedAttribute.id != -1,
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: UpText(
                                                  "Add new attribute value",
                                                  type: UpTextType.heading6,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 250,
                                                    child: UpTextField(
                                                      controller:
                                                          attributeValueNameController,
                                                      label: "Attribute Value",
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: UpButton(
                                                        onPressed: () {
                                                          _updateAttributeValue();
                                                        },
                                                        text: "Add",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Visibility(
                                                  visible:
                                                      filteredAttributeValues
                                                          .isNotEmpty,
                                                  child: SizedBox(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ...filteredAttributeValues
                                                              .map(
                                                                  (e) =>
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          bottom:
                                                                              8.0,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Flexible(
                                                                              child: UpText(
                                                                                e.name,
                                                                                style: UpStyle(
                                                                                  textSize: 16,
                                                                                  textWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                _deleteAttributeValue(e.id!);
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
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
