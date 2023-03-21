import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AddEditAddonWidget extends StatefulWidget {
  final Product currentProduct;

  const AddEditAddonWidget({
    Key? key,
    required this.currentProduct,
  }) : super(key: key);

  @override
  State<AddEditAddonWidget> createState() => _AddEditAddonWidgetState();
}

class _AddEditAddonWidgetState extends State<AddEditAddonWidget> {
  List<Product> products = [];
  List<UpLabelValuePair> addOnProductDropdown = [];
  int? selectedMedia;
  String currentSelectedAddon = "";
  final TextEditingController _addOnPriceController = TextEditingController();
  List<AddOn> selectedAddons = [];
  @override
  void initState() {
    super.initState();
    getAddons();
  }

  _getAddOnProducts() async {
    products = await ProductService.getProducts([], {}, null, null, {});

    if (products.isNotEmpty) {
      if (addOnProductDropdown.isEmpty) {
        if (products.isNotEmpty) {
          for (var element in products) {
            addOnProductDropdown.add(
                UpLabelValuePair(label: element.name, value: "${element.id}"));
          }
        }
      }

      setState(() {});
    }
  }

  getAddons() async {
    List<AddOn>? addons = await AddEditProductService.getAddons();
    if (addons != null && addons.isNotEmpty) {
      List<AddOn> productBasedAddon = [];
      selectedAddons = [];
      productBasedAddon = addons
          .where((element) => element.product == widget.currentProduct.id)
          .toList();
      if (productBasedAddon.isNotEmpty) {
        for (var addOn in productBasedAddon) {
          selectedAddons.add(addOn);
        }
      }
      if (products.isEmpty) {
        _getAddOnProducts();
      } else {
        setState(() {});
      }
    }
  }

  _deleteDialog(AddOn e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        if (widget.currentProduct.id != null) {
          APIResult? result = await AddEditProductService.deleteAddon(e.id!);
          if (result != null && result.success) {
            selectedAddons.remove(e);
            setState(() {});
          }
        } else {
          selectedAddons.remove(e);

          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty && addOnProductDropdown.isNotEmpty
        ? BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UpText(
                        "Addons",
                        type: UpTextType.heading6,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 180,
                              child: UpDropDown(
                                label: "Product",
                                value: currentSelectedAddon,
                                itemList: addOnProductDropdown,
                                onChanged: (value) {
                                  currentSelectedAddon = value ?? "";
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 180,
                                child: UpTextField(
                                  controller: _addOnPriceController,
                                  label: "Price",
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 60,
                              child: UpButton(
                                colorType: UpColorType.tertiary,
                                onPressed: () async {
                                  AddOn newAddOn;

                                  if (widget.currentProduct.id != null) {
                                    newAddOn = AddOn(
                                        addOn: int.parse(currentSelectedAddon),
                                        product: widget.currentProduct.id!,
                                        price: _addOnPriceController
                                                .text.isEmpty
                                            ? -1
                                            : double.parse(
                                                _addOnPriceController.text));
                                    APIResult? result =
                                        await AddEditProductService
                                            .addProductAddon(
                                                AddOn.toJson(newAddOn));
                                    if (result != null && result.success) {
                                      getAddons();
                                    }
                                  }
                                },
                                text: "Add",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Visibility(
                          visible: selectedAddons.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: selectedAddons
                                .map(
                                  (e) => Row(
                                    children: [
                                      UpText(
                                          type: UpTextType.heading6,
                                          products
                                              .where(
                                                (element) =>
                                                    element.id == e.addOn,
                                              )
                                              .first
                                              .name),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      UpText(
                                          type: UpTextType.heading6,
                                          "${e.price.toString()}£"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: (() async {
                                          _deleteDialog(e);
                                        }),
                                        child: const UpIcon(icon: Icons.cancel),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ))
                    ]),
              );
            })
        : const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: UpCircularProgress(
                width: 20,
                height: 20,
              ),
            ),
          );
  }
}
