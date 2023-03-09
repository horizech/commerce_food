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
