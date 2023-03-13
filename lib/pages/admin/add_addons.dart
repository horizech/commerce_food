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
import 'package:shop/models/add_on.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/services/products_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_up/widgets/up_text.dart';
// import 'package:flutter_up/widgets/up_textfield.dart';

// class AddEditProductMetaWidget extends StatefulWidget {
//   final Map<String, dynamic>? meta;
//   final Function onChange;
//   const AddEditProductMetaWidget({
//     Key? key,
//     required this.onChange,
//     this.meta,
//   }) : super(key: key);

//   @override
//   State<AddEditProductMetaWidget> createState() =>
//       _AddEditProductMetaWidgetState();
// }

// class _AddEditProductMetaWidgetState extends State<AddEditProductMetaWidget> {
//   Map<String, dynamic> newMeta = {};
//   Map<String, dynamic> flavourMeta = {};
//   TextEditingController nameController = TextEditingController();

//   addFlavour(String key, String value) {
//     flavourMeta[key] = value;
//     newMeta["Flavours"] = flavourMeta;
//     widget.onChange(newMeta);
//   }

//   removeFlavour(String key, String value) {
//     flavourMeta.remove(key);
//     newMeta["Flavours"] = flavourMeta;
//     widget.onChange(newMeta);
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.meta != null && widget.meta!.isNotEmpty) {
//       if ((widget.meta!["Flavours"] as Map<String, dynamic>).isNotEmpty) {
//         (widget.meta!["Flavours"] as Map<String, dynamic>)
//             .forEach((key, value) {
//           flavourMeta[key] = value;
//         });
//       }
//       // if ((widget.meta!["Features"] as Map<String, dynamic>).isNotEmpty) {
//       //   (widget.meta!["Features"] as Map<String, dynamic>)
//       //       .forEach((key, value) {
//       //     featuresMeta[key] = value;
//       //   });
//       // }
//     }
//     newMeta["Flavours"] = flavourMeta;
//     // newMeta["Features"] = featuresMeta;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: [
//         const UpText("Flavours"),
//         UpTextField(
//           label: "Flavour",
//           controller: nameController,
//         ),
//         flavourMeta.isNotEmpty
//             ? Column(
//                 children:  [ ...flavourMeta.values.map(
//           (key) => Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               width: 200,
//               child: UpText(
//                       // addFlavours(key, value ?? ""),

//               ),
//             ),

//               )
//             : const SizedBox(),
//       ],
//     );
//   }
// }

class AddonsWidget extends StatefulWidget {
  final Function? onChange;
  final int? productId;

  const AddonsWidget({
    Key? key,
    this.onChange,
    this.productId,
  }) : super(key: key);

  @override
  State<AddonsWidget> createState() => _AddonsWidgetState();
}

class _AddonsWidgetState extends State<AddonsWidget> {
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
          .where((element) => element.product == widget.productId)
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

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty && addOnProductDropdown.isNotEmpty
        ? BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {},
            builder: (context, state) {
              // if (selectedAddons.isEmpty && widget.productId != null) {
              //   List<AddOn> productBasedAddon = [];
              //   if (state.addOns != null && state.addOns!.isNotEmpty) {
              //     productBasedAddon = state.addOns!
              //         .where((element) => element.product == widget.productId)
              //         .toList();
              //     if (productBasedAddon.isNotEmpty) {
              //       for (var addOn in productBasedAddon) {
              //         selectedAddons.add(addOn);
              //       }
              //     }
              //   }
              // }
              return Column(
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

                                  if (widget.productId != null) {
                                    newAddOn = AddOn(
                                        addOn: int.parse(currentSelectedAddon),
                                        product: widget.productId!,
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
                                      // selectedAddons.add(newAddOn);
                                      getAddons();
                                    }
                                  } else {
                                    newAddOn = AddOn(
                                        product: 0,
                                        addOn: int.parse(currentSelectedAddon),
                                        price: _addOnPriceController
                                                .text.isEmpty
                                            ? -1
                                            : double.parse(
                                                _addOnPriceController.text));

                                    selectedAddons.add(newAddOn);
                                    if (widget.onChange != null) {
                                      widget.onChange!(selectedAddons);
                                    }
                                    setState(() {});
                                  }
                                },
                                text: "Add",
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(
                        visible: selectedAddons.isNotEmpty,
                        child: Column(
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
                                          if (widget.productId != null) {
                                            APIResult? result =
                                                await AddEditProductService
                                                    .deleteAddon(e.id!);
                                            if (result != null &&
                                                result.success) {
                                              selectedAddons.remove(e);
                                              setState(() {});
                                            }
                                          } else {
                                            selectedAddons.remove(e);

                                            if (widget.onChange != null) {
                                              widget.onChange!(selectedAddons);
                                            }
                                            setState(() {});
                                          }
                                        }),
                                        child:
                                            const UpIcon(icon: Icons.cancel)),
                                  ],
                                ),
                              )
                              .toList(),
                        ))
                  ]);
            })
        : const UpCircularProgress(
            width: 20,
            height: 20,
          );
  }
}
