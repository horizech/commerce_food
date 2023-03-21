// import 'package:apiraiser/apiraiser.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_up/enums/up_color_type.dart';
// import 'package:flutter_up/helpers/up_toast.dart';
// import 'package:flutter_up/widgets/up_button.dart';
// import 'package:flutter_up/widgets/up_checkbox.dart';
// import 'package:flutter_up/widgets/up_text.dart';
// import 'package:flutter_up/widgets/up_textfield.dart';
// import 'package:shop/date_time_picker.dart';
// import 'package:shop/models/add_on.dart';
// import 'package:shop/models/product.dart';
// import 'package:shop/pages/admin/add_addons.dart';
// import 'package:shop/pages/admin/add_edit_keyword_widget.dart';
// import 'package:shop/pages/admin/add_edit_attribute_widget.dart';
// import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
// import 'package:shop/widgets/add_media_widget.dart';
// import 'package:shop/widgets/gallery_dropdown.dart';

// class AddEditProductDialog extends StatefulWidget {
//   final Product? currentProduct;
//   final int currentCollection;
//   const AddEditProductDialog({
//     Key? key,
//     this.currentProduct,
//     required this.currentCollection,
//   }) : super(key: key);

//   @override
//   State<AddEditProductDialog> createState() => _AddEditProductDialogState();
// }

// class _AddEditProductDialogState extends State<AddEditProductDialog> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _skuController = TextEditingController();
//   final TextEditingController _discountPriceController =
//       TextEditingController();
//   final TextEditingController _discountStartController =
//       TextEditingController();
//   final TextEditingController _discountEndController = TextEditingController();
//   int? gallery;
//   int? thumbnail;
//   List<int> keywords = [];
//   bool isVariedProduct = false;
//   Map<String, int> options = {};
//   Map<String, dynamic> meta = {};
//   int? selectedMedia;
//   List<AddOn> addons = [];

//   _initializeFields() {
//     _nameController.text = widget.currentProduct!.name;
//     _nameController.text = widget.currentProduct!.name;
//     _descriptionController.text = widget.currentProduct!.description ?? "";
//     isVariedProduct = widget.currentProduct!.isVariedProduct;
//     _priceController.text = widget.currentProduct!.price.toString();
//     _skuController.text = widget.currentProduct!.sku.toString();

//     _discountPriceController.text = widget.currentProduct!.discounPrice != null
//         ? widget.currentProduct!.discounPrice.toString()
//         : "";
//     _discountStartController.text =
//         widget.currentProduct!.discountStartDate != null
//             ? widget.currentProduct!.discountStartDate.toString()
//             : "";
//     _discountEndController.text = widget.currentProduct!.discountEndDate != null
//         ? widget.currentProduct!.discountEndDate.toString()
//         : "";
//     gallery = widget.currentProduct!.gallery;
//     thumbnail = widget.currentProduct!.thumbnail;
//     keywords = widget.currentProduct!.keywords ?? [];
//     options = widget.currentProduct!.options ?? {};
//     meta = widget.currentProduct!.meta ?? {};
//     selectedMedia = widget.currentProduct!.thumbnail;

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (widget.currentProduct != null && widget.currentProduct!.id != null) {
//       _initializeFields();
//     }
//   }

//   _discountStartDate() async {
//     DateTime date = await getPicker(context);
//     setState(() {
//       _discountStartController.text = date.toString();
//     });
//   }

//   _discountEndDate() async {
//     DateTime date = await getPicker(context);

//     setState(() {
//       _discountEndController.text = date.toString();
//     });
//   }

//   addEditProduct() async {
//     Product product = Product(
//       name: _nameController.text,
//       id: widget.currentProduct != null && widget.currentProduct!.id != null
//           ? widget.currentProduct!.id
//           : null,
//       collection: widget.currentCollection,
//       price: _priceController.text.isNotEmpty
//           ? double.parse(_priceController.text)
//           : null,
//       description: _descriptionController.text,
//       sku: _skuController.text,
//       isVariedProduct: isVariedProduct,
//       gallery: gallery ?? 1,
//       keywords: keywords,
//       thumbnail: selectedMedia ?? 1,
//       options: options,
//       discountStartDate: _discountStartController.text.isNotEmpty
//           ? DateTime.parse(_discountStartController.text)
//           : null,
//       discountEndDate: _discountEndController.text.isNotEmpty
//           ? DateTime.parse(_discountEndController.text)
//           : null,
//       discounPrice: _discountPriceController.text.isNotEmpty
//           ? double.parse(_discountPriceController.text)
//           : null,
//       meta: meta,
//     );

//     APIResult? result = await AddEditProductService.addEditProduct(
//         Product.toJson(product),
//         widget.currentProduct != null ? widget.currentProduct!.id! : null);

//     if (result != null) {
//       if (result.success) {
//         if (widget.currentProduct == null) {
//           List<AddOn> newAddons = [];
//           for (var element in addons) {
//             newAddons.add(
//               AddOn(
//                   addOn: element.addOn,
//                   price: element.price,
//                   product: result.data),
//             );
//           }
//           addons = newAddons;

//           for (var element in addons) {
//             await AddEditProductService.addProductAddon(AddOn.toJson(element));
//           }
//         }
//         if (mounted) {}
//         Navigator.pop(context, "success");
//       } else {
//         if (mounted) {}
//         Navigator.pop(
//           context,
//         );
//         showUpToast(
//           context: context,
//           text: result.message ?? "",
//         );
//       }
//     } else {
//       if (mounted) {}

//       Navigator.pop(
//         context,
//       );

//       showUpToast(
//         context: context,
//         text: "An error occurred",
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: UpText(
//           widget.currentProduct != null ? "Edit Product" : "Add Product",
//         ),
//       ),
//       actionsPadding: const EdgeInsets.all(0),
//       titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//       content: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SizedBox(
//               width: 500,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: 300,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // name
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                           controller: _nameController,
//                           label: "Name",
//                         ),
//                       ),
//                       // description
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                           controller: _descriptionController,
//                           label: "Description",
//                           maxLines: 4,
//                         ),
//                       ),
//                       // price
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                           keyboardType: TextInputType.number,
//                           controller: _priceController,
//                           label: "Price",
//                         ),
//                       ),
//                       // sku
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                           controller: _skuController,
//                           label: "Sku",
//                         ),
//                       ),
//                       // discount price
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                           controller: _discountPriceController,
//                           label: "Discound Price",
//                         ),
//                       ),
//                       // discount start date
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                             controller: _discountStartController,
//                             prefixIcon: const Icon(Icons.calendar_today),
//                             label: "Discound Start Date",
//                             onTap: () {
//                               _discountStartDate();
//                             }),
//                       ),
//                       // discount end date
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: UpTextField(
//                             controller: _discountEndController,
//                             prefixIcon: const Icon(Icons.calendar_today),
//                             label: "Discound End Date",
//                             onTap: () {
//                               _discountEndDate();
//                             }),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: AddEditKeywordWidget(
//                           keywordList: keywords,
//                           change: (value) {
//                             if (value != null) {
//                               keywords.clear();

//                               for (var element in (value as List<String>)) {
//                                 keywords.add(int.parse(element));
//                               }
//                             }
//                           },
//                         ),
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: GalleryDropdown(
//                           gallery: gallery,
//                           onChange: (value) {
//                             gallery = int.parse(value);
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: AddMediaWidget(
//                           selectedMedia: selectedMedia,
//                           onChnage: (media) {
//                             selectedMedia = media;
//                             setState(() {});
//                           },
//                         ),
//                       ),

//                       // is varried checkbox
//                       UpCheckbox(
//                         initialValue: isVariedProduct,
//                         label: "Is Varied",
//                         onChange: (newCheck) => {
//                           isVariedProduct = newCheck,
//                           setState(() {}),
//                         },
//                       ),
//                       // options value
//                       Visibility(
//                         visible: widget.currentCollection > 0 &&
//                             isVariedProduct == false,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: AddEditAttributesWidget(
//                             change: (newOptions) {
//                               options = newOptions;
//                             },
//                             options: options,
//                             currentCollection: widget.currentCollection,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: AddEditAddonWidget(
//                           productId: widget.currentProduct?.id,
//                           onChange: (value) {
//                             if (value != null) {
//                               addons = value;
//                             }
//                           },
//                         ),
//                       )

//                       // widget.currentProduct != null
//                       //     ? Padding(
//                       //         padding: const EdgeInsets.all(8.0),
//                       //         child: AddEditProductMetaWidget(
//                       //           meta: meta,
//                       //           onChange: (value) {
//                       //             meta = value;
//                       //           },
//                       //         ),
//                       //       )
//                       //     : Padding(
//                       //         padding: const EdgeInsets.all(8.0),
//                       //         child: AddEditProductMetaWidget(
//                       //           meta: meta,
//                       //           onChange: (value) {
//                       //             meta = value;
//                       //           },
//                       //         ),
//                       //       ),
//                     ],
//                   ),
//                 ),
//               )),
//         ),
//       ),
//       actions: <Widget>[
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//           child: SizedBox(
//             width: 100,
//             child: UpButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               text: "Cancel",
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
//           child: SizedBox(
//             width: 100,
//             child: UpButton(
//               colorType: UpColorType.success,
//               text: "Save",
//               onPressed: () {
//                 addEditProduct();
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
