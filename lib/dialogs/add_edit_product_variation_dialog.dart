// import 'package:apiraiser/apiraiser.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_up/enums/up_color_type.dart';
// import 'package:flutter_up/helpers/up_toast.dart';
// import 'package:flutter_up/widgets/up_button.dart';
// import 'package:flutter_up/widgets/up_text.dart';
// import 'package:flutter_up/widgets/up_textfield.dart';
// import 'package:shop/date_time_picker.dart';
// import 'package:shop/models/product_variation.dart';
// import 'package:shop/pages/admin/add_edit_attribute_widget.dart';
// import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
// import 'package:shop/widgets/gallery_dropdown.dart';

// class AddEditProductVariationDialog extends StatefulWidget {
//   final int currentProduct;
//   final int currentCollection;
//   final ProductVariation? currentProductVariation;
//   const AddEditProductVariationDialog({
//     Key? key,
//     required this.currentProduct,
//     required this.currentCollection,
//     this.currentProductVariation,
//   }) : super(key: key);

//   @override
//   State<AddEditProductVariationDialog> createState() =>
//       _AddEditProductVariationDialogState();
// }

// class _AddEditProductVariationDialogState
//     extends State<AddEditProductVariationDialog> {
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

//   _initializeFields() {
//     _nameController.text = widget.currentProductVariation!.name ?? "";
//     _descriptionController.text =
//         widget.currentProductVariation!.description ?? "";
//     _priceController.text = widget.currentProductVariation!.price.toString();
//     _skuController.text = widget.currentProductVariation!.sku.toString();

//     _discountPriceController.text =
//         widget.currentProductVariation!.discounPrice != null
//             ? widget.currentProductVariation!.discounPrice.toString()
//             : "";
//     _discountStartController.text =
//         widget.currentProductVariation!.discountStartDate != null
//             ? widget.currentProductVariation!.discountStartDate.toString()
//             : "";
//     _discountEndController.text =
//         widget.currentProductVariation!.discountEndDate != null
//             ? widget.currentProductVariation!.discountEndDate.toString()
//             : "";
//     gallery = widget.currentProductVariation!.gallery;
//     options = widget.currentProductVariation!.options;
//     // meta = widget.currentProductVariation.meta ?? {};

//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (widget.currentProductVariation != null) {
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

//   addEditProductVariation() async {
//     ProductVariation productVariation = ProductVariation(
//       name: _nameController.text,
//       id: widget.currentProductVariation != null
//           ? widget.currentProductVariation!.id
//           : null,
//       price: _priceController.text.isNotEmpty
//           ? double.parse(_priceController.text)
//           : null,
//       description: _descriptionController.text,
//       sku: _skuController.text,
//       product: widget.currentProduct,
//       gallery: gallery ?? 1,
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
//       // meta: meta,
//     );

//     APIResult? result = await AddEditProductService.addEditProductVariation(
//         ProductVariation.toJson(productVariation),
//         widget.currentProductVariation != null
//             ? widget.currentProductVariation!.id!
//             : null);

//     if (result != null) {
//       if (mounted) {}
//       Navigator.pop(context, "success");

//       showUpToast(
//         context: context,
//         text: result.message ?? "",
//       );
//     } else {
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
//           widget.currentProductVariation != null
//               ? "Edit Product Variation"
//               : "Add Product Variation",
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
//                         child: GalleryDropdown(
//                             gallery: gallery,
//                             onChange: (value) {
//                               gallery = int.parse(value);
//                             }),
//                       ),

//                       // options value
//                       Visibility(
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
//                 addEditProductVariation();
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
