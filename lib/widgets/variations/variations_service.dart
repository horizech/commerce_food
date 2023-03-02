// import 'package:shop/models/variation.dart';
// import 'package:shop/models/variations_type.dart';
// import 'package:apiraiser/api/apiraiser.dart';
// import 'package:apiraiser/models/api_result.dart';

// class VariationsService {
//   static Future<Variation?> getVariationById(int variationId, int limit) async {
//     Apiraiser.validateAuthentication();
//     List<Map<String, dynamic>> conditions = [
//       <String, dynamic>{
//         'Name': "Id",
//         'Condition': 0,
//         'Value': variationId,
//       }
//     ];

//     APIResult result =
//         await Apiraiser.data.getByConditions("Variations", conditions);

//     if (result.success) {
//       Variation variation = (result.data as List<dynamic>)
//           .map((p) => Variation.fromJson(p as Map<String, dynamic>))
//           .first;
//       return variation;
//     } else {
//       return null;
//     }

//     // var res = await http.get(
//     //   Uri.parse(
//     //       '${const String.fromEnvironment('APIRAISER_API_ENDPOINT')}/API/Products'),
//     //   headers: {"Content-Type": "application/json"},
//     // );
//     // Product.from
//     // return APIResult.fromJson(json.decode(res.body));
//   }

//   static Future<VariationsType?> getVariationByTypeId(
//       int typeId, int limit) async {
//     Apiraiser.validateAuthentication();
//     List<Map<String, dynamic>> conditions = [
//       <String, dynamic>{
//         'Name': "Id",
//         'Condition': 0,
//         'Value': typeId,
//       }
//     ];

//     APIResult result =
//         await Apiraiser.data.getByConditions("VariationTypes", conditions);

//     if (result.success) {
//       VariationsType variationType = (result.data as List<dynamic>)
//           .map((p) => VariationsType.fromJson(p as Map<String, dynamic>))
//           .first;
//       return variationType;
//     } else {
//       return null;
//     }
//   }

//   static Future<List<Variation>> getVariations(int limit) async {
//     Apiraiser.validateAuthentication();
//     APIResult result = await Apiraiser.data.get("Variations", limit);
//     List<Variation> variations = (result.data as List<dynamic>)
//         .map((p) => Variation.fromJson(p as Map<String, dynamic>))
//         .toList();
//     if (result.success) {
//       return variations;
//     } else {
//       return [];
//     // }
//     // var res = await http.get(
//     //   Uri.parse(
//     //       '${const String.fromEnvironment('APIRAISER_API_ENDPOINT')}/API/Products'),
//     //   headers: {"Content-Type": "application/json"},
//     // );
//     // Product.from
//     // return APIResult.fromJson(json.decode(res.body));
//   }
// }
