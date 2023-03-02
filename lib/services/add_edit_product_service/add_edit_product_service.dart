import 'package:apiraiser/apiraiser.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:http/http.dart' as http;

import 'package:shop/models/product_variation.dart';

class AddEditProductService {
  static Future<APIResult?> addEditProductOptionValues({
    int? productOptionValueId,
    required Map<String, dynamic> data,
  }) async {
    APIResult? result;
    if (productOptionValueId != null) {
      result = await Apiraiser.data
          .update("ProductOptionValues", productOptionValueId, data);
    } else {
      result = await Apiraiser.data.insert("ProductOptionValues", data);
    }

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteProductOption(int productOptionId) async {
    APIResult result =
        await Apiraiser.data.delete("ProductOptions", productOptionId);

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteProductOptionValue(
      int productOptionValueId) async {
    APIResult result = await Apiraiser.data
        .delete("ProductOptionValues", productOptionValueId);

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> addEditProduct(
    Map<String, dynamic> data,
    int? productId,
  ) async {
    APIResult result;
    if (productId != null) {
      result = await Apiraiser.data.update("Products", productId, data);
    } else {
      result = await Apiraiser.data.insert("Products", data);
    }

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> addEditProductVariation(
    Map<String, dynamic> data,
    int? productVariationId,
  ) async {
    APIResult result;
    if (productVariationId != null) {
      result = await Apiraiser.data
          .update("ProductVariations", productVariationId, data);
    } else {
      result = await Apiraiser.data.insert("ProductVariations", data);
    }

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<ProductOption?> addEditProductOption(
      {required Map<String, dynamic> data, int? productOptionId}) async {
    APIResult? result;
    if (productOptionId != null) {
      result =
          await Apiraiser.data.update("ProductOptions", productOptionId, data);
    } else {
      result = await Apiraiser.data.insert("ProductOptions", data);
    }

    if (result.success) {
      ProductOption? productOption = await getProductOptionByName(data["Name"]);
      return productOption;
    } else {
      return null;
    }
  }

  static Future<ProductOption?> getProductOptionByName(String name) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Name", condition: ColumnCondition.equal, value: name)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("ProductOptions", conditions);

    if (result.success) {
      ProductOption productOption = (result.data as List<dynamic>)
          .map((p) => ProductOption.fromJson(p as Map<String, dynamic>))
          .first;
      return productOption;
    } else {
      return null;
    }
  }

  static Future<ProductVariation?> getProductVariationById(
      int productVariationId) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Id",
          condition: ColumnCondition.equal,
          value: productVariationId)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("ProductVariations", conditions);

    if (result.success) {
      ProductVariation productVariation = (result.data as List<dynamic>)
          .map((p) => ProductVariation.fromJson(p as Map<String, dynamic>))
          .first;
      return productVariation;
    } else {
      return null;
    }
  }

  static Future<Product?> getProductById(int productId) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Id", condition: ColumnCondition.equal, value: productId)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("Products", conditions);

    if (result.success) {
      Product product = (result.data as List<dynamic>)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .first;
      return product;
    } else {
      return null;
    }
  }

  static Future<List<ProductOptionValue>?> getProductOptionValues(
      int? currentCollection, int? currentProductOption) async {
    List<QuerySearchItem> conditions = [];
    if (currentProductOption != null) {
      conditions.add(
        QuerySearchItem(
          name: "ProductOption",
          condition: ColumnCondition.equal,
          value: currentProductOption,
        ),
      );
    }

    if (currentCollection != null) {
      conditions.add(
        QuerySearchItem(
          name: "Collection",
          condition: ColumnCondition.equal,
          value: currentCollection,
        ),
      );
    }

    APIResult result =
        await Apiraiser.data.getByConditions("ProductOptionValues", conditions);

    if (result.success) {
      List<ProductOptionValue> productOptionValues = (result.data
              as List<dynamic>)
          .map((p) => ProductOptionValue.fromJson(p as Map<String, dynamic>))
          .toList();
      return productOptionValues;
    } else {
      return null;
    }
  }

  static Future<List<Collection>?> getCollections() async {
    APIResult result = await Apiraiser.data.get("Collections", -1);

    if (result.success) {
      List<Collection> collections = (result.data as List<dynamic>)
          .map((p) => Collection.fromJson(p as Map<String, dynamic>))
          .toList();
      return collections;
    } else {
      return null;
    }
  }

  static Future<List<ProductOption>?> getProductOptions() async {
    APIResult result = await Apiraiser.data.get("ProductOptions", -1);

    if (result.success) {
      List<ProductOption> productOptions = (result.data as List<dynamic>)
          .map((p) => ProductOption.fromJson(p as Map<String, dynamic>))
          .toList();
      return productOptions;
    } else {
      return null;
    }
  }

  static uploadFile(String path) async {
    try {
      http.MultipartRequest request = http.MultipartRequest("POST", Uri());
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('file_name', path);
      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        // return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }
    // // open a bytestream
    // var stream = http.ByteStream(file.openRead());
    // // get file length
    // var length = await file.length();

    // // string to uri
    // var uri = Uri.parse("");

    // // create multipart request
    // var request = http.MultipartRequest("POST", uri);

    // // multipart that takes file
    // var multipartFile = http.MultipartFile('file', stream, length,
    //     filename: file.path.split("/").last);

    // // add file to multipart
    // request.files.add(multipartFile);

    // // send
    // var response = await request.send();
    // print(response.statusCode);

    // // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    // var request = http.MultipartRequest('POST', Uri.parse(""));
    // request.files.add(http.MultipartFile('picture',
    //     File(filePath).readAsBytes().asStream(), File(filePath).lengthSync(),
    //     filename: filePath.split("/").last));
    // var res = await request.send();
  }
}
