import 'package:apiraiser/apiraiser.dart';
import 'package:shop/models/add_on.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/models/combo.dart';
import 'package:shop/models/gallery.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/models/media.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/models/product_combo.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:http/http.dart' as http;

import 'package:shop/models/product_variation.dart';

class AddEditProductService {
  static Future<APIResult?> addEditAttributeValues({
    int? attributeValueId,
    required Map<String, dynamic> data,
  }) async {
    APIResult? result;
    if (attributeValueId != null) {
      result = await Apiraiser.data
          .update("AttributeValues", attributeValueId, data);
    } else {
      result = await Apiraiser.data.insert("AttributeValues", data);
    }

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteAttribute(int attributeId) async {
    APIResult result = await Apiraiser.data.delete("Attributes", attributeId);

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteAttributeValue(int attributeValueId) async {
    APIResult result =
        await Apiraiser.data.delete("AttributeValues", attributeValueId);

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteAddon(int addOnId) async {
    APIResult? result = await Apiraiser.data.delete("ProductAddons", addOnId);

    return result;
  }

  static Future<APIResult?> addProductAddon(Map<String, dynamic> data) async {
    APIResult? result = await Apiraiser.data.insert("ProductAddons", data);
    return result;
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

  static Future<APIResult?> addEditAttribute(
      {required Map<String, dynamic> data, int? attributeId}) async {
    APIResult? result;
    if (attributeId != null) {
      result = await Apiraiser.data.update("Attributes", attributeId, data);
    } else {
      result = await Apiraiser.data.insert("Attributes", data);
    }

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> addEditProductAttribute(
      {required Map<String, dynamic> data, int? proAttributeId}) async {
    APIResult? result;
    if (proAttributeId != null) {
      result = await Apiraiser.data
          .update("ProductAttributes", proAttributeId, data);
    } else {
      result = await Apiraiser.data.insert("ProductAttributes", data);
    }

    return result;
  }

  static Future<Attribute?> getProductOptionByName(String name) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Name", condition: ColumnCondition.equal, value: name)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("ProductOptions", conditions);

    if (result.success) {
      Attribute productOption = (result.data as List<dynamic>)
          .map((p) => Attribute.fromJson(p as Map<String, dynamic>))
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

  static Future<List<ProductVariation>> getProductVariationByProductId(
      int productId) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Product", condition: ColumnCondition.equal, value: productId)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("ProductVariations", conditions);

    if (result.success) {
      List<ProductVariation> productVariations = (result.data as List<dynamic>)
          .map((p) => ProductVariation.fromJson(p as Map<String, dynamic>))
          .toList();
      return productVariations;
    } else {
      return [];
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

  static Future<List<Product>> getProductBycollection(int collection) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Collection",
          condition: ColumnCondition.equal,
          value: collection)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("Products", conditions);

    if (result.success) {
      List<Product> products = (result.data as List<dynamic>)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<List<Product>> getVariedProducts() async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "IsVariedProduct",
          condition: ColumnCondition.equal,
          value: true)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("Products", conditions);

    if (result.success) {
      List<Product> products = (result.data as List<dynamic>)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<List<AttributeValue>?> getAttributeValues() async {
    APIResult result = await Apiraiser.data.get("AttributeValues", -1);

    if (result.success) {
      List<AttributeValue> attributeValues = (result.data as List<dynamic>)
          .map((p) => AttributeValue.fromJson(p as Map<String, dynamic>))
          .toList();
      return attributeValues;
    } else {
      return null;
    }
  }

  static Future<List<ProductAttribute>?> getProductAttributes() async {
    APIResult result = await Apiraiser.data.get("ProductAttributes", -1);

    if (result.success) {
      List<ProductAttribute> productAttributes = (result.data as List<dynamic>)
          .map((p) => ProductAttribute.fromJson(p as Map<String, dynamic>))
          .toList();
      return productAttributes;
    } else {
      return null;
    }
  }

  static Future<List<AddOn>?> getAddons() async {
    APIResult result = await Apiraiser.data.get("ProductAddons", -1);

    if (result.success) {
      List<AddOn> addons = (result.data as List<dynamic>)
          .map((p) => AddOn.fromJson(p as Map<String, dynamic>))
          .toList();
      return addons;
    } else {
      return null;
    }
  }

  static Future<List<Keyword>> getKeywords() async {
    APIResult result = await Apiraiser.data.get("Keywords", -1);

    if (result.success) {
      List<Keyword> keywords = (result.data as List<dynamic>)
          .map((p) => Keyword.fromJson(p as Map<String, dynamic>))
          .toList();
      return keywords;
    } else {
      return [];
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

  static Future<List<Gallery>> getGallery() async {
    APIResult result = await Apiraiser.data.get("Gallery", -1);

    if (result.success) {
      List<Gallery> gallery = (result.data as List<dynamic>)
          .map((p) => Gallery.fromJson(p as Map<String, dynamic>))
          .toList();
      return gallery;
    } else {
      return [];
    }
  }

  static Future<List<Attribute>?> getAttributes() async {
    APIResult result = await Apiraiser.data.get("Attributes", -1);

    if (result.success) {
      List<Attribute> attributes = (result.data as List<dynamic>)
          .map((p) => Attribute.fromJson(p as Map<String, dynamic>))
          .toList();
      return attributes;
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

  static Future<APIResult?> addEditProductVariations(
    List<Map<String, dynamic>> data,
    int? productVariationId,
  ) async {
    // APIResult result;
    List<APIResult> result = [];
    if (productVariationId != null) {
      dynamic futureResult = await Future.wait([
        ...data
            .map((e) => Apiraiser.data.update("ProductVariations", e["Id"], e))
            .toList()
      ]);
      result = futureResult as List<APIResult>;
    } else {
      dynamic futureResult = await Future.wait([
        ...data
            .map((e) => Apiraiser.data.insert("ProductVariations", e))
            .toList()
      ]);
      result = futureResult as List<APIResult>;
    }

    return result.first;
  }

  static Future<List<Product>?> getProductByIds(List<int>? productIds) async {
    List<QuerySearchItem> conditions = [
      QuerySearchItem(
          name: "Id", condition: ColumnCondition.includes, value: productIds)
    ];
    APIResult result =
        await Apiraiser.data.getByConditions("Products", conditions);

    if (result.success) {
      List<Product> products = (result.data as List<dynamic>)
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<APIResult?> addEditCombos(
      {required Map<String, dynamic> data, int? comboId}) async {
    APIResult? result;
    if (comboId != null) {
      result = await Apiraiser.data.update("Combos", comboId, data);
    } else {
      result = await Apiraiser.data.insert("Combos", data);
    }

    return result;
  }

  static Future<APIResult?> addEditGallery(
      {required Map<String, dynamic> data, int? galleryId}) async {
    APIResult? result;
    if (galleryId != null) {
      result = await Apiraiser.data.update("Gallery", galleryId, data);
    } else {
      result = await Apiraiser.data.insert("Gallery", data);
    }

    return result;
  }

  static Future<List<Combo>?> getCombos() async {
    APIResult result = await Apiraiser.data.get("Combos", -1);

    if (result.success) {
      List<Combo> combos = (result.data as List<dynamic>)
          .map((p) => Combo.fromJson(p as Map<String, dynamic>))
          .toList();
      return combos;
    } else {
      return null;
    }
  }

  static Future<List<ProductCombo>?> getProductCombos() async {
    APIResult result = await Apiraiser.data.get("ProductCombos", -1);

    if (result.success) {
      List<ProductCombo> productCombos = (result.data as List<dynamic>)
          .map((p) => ProductCombo.fromJson(p as Map<String, dynamic>))
          .toList();
      return productCombos;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteCombo(int comboId) async {
    APIResult result = await Apiraiser.data.delete("Combos", comboId);

    return result;
  }

  static Future<APIResult?> deleteKeyword(int keywordId) async {
    APIResult result = await Apiraiser.data.delete("Keywords", keywordId);

    return result;
  }

  static Future<APIResult?> deleteGallery(int galleryId) async {
    APIResult result = await Apiraiser.data.delete("Gallery", galleryId);

    return result;
  }

  static Future<APIResult?> deleteCollection(int collectionId) async {
    APIResult result = await Apiraiser.data.delete("Collections", collectionId);

    return result;
  }

  static Future<APIResult?> insertProductCombo(
    Map<String, dynamic> data,
  ) async {
    APIResult result;

    result = await Apiraiser.data.insert("ProductCombos", data);

    if (result.success) {
      return result;
    } else {
      return null;
    }
  }

  static Future<APIResult?> deleteProductCombo(int productComboId) async {
    APIResult? result =
        await Apiraiser.data.delete("ProductCombos", productComboId);
    return result;
  }

  static Future<APIResult?> deleteProduct(int productId) async {
    APIResult? result = await Apiraiser.data.delete("Products", productId);
    return result;
  }

  static Future<APIResult?> deleteProductVariation(
      int productVariationId) async {
    APIResult? result =
        await Apiraiser.data.delete("ProductVariations", productVariationId);
    return result;
  }

  static Future<List<AttributeValue>?> getProductOptionValuesByConditions(
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
      List<AttributeValue> attributeValues = (result.data as List<dynamic>)
          .map((p) => AttributeValue.fromJson(p as Map<String, dynamic>))
          .toList();
      return attributeValues;
    } else {
      return null;
    }
  }

  static Future<APIResult?> addEditCollection(
      {required Map<String, dynamic> data, int? collectionId}) async {
    APIResult? result;
    if (collectionId != null) {
      result = await Apiraiser.data.update("Collections", collectionId, data);
    } else {
      result = await Apiraiser.data.insert("Collections", data);
    }

    return result;
  }

  static Future<APIResult?> addEditkeyword(
      {required Map<String, dynamic> data, int? keywordId}) async {
    APIResult? result;
    if (keywordId != null) {
      result = await Apiraiser.data.update("Keywords", keywordId, data);
    } else {
      result = await Apiraiser.data.insert("Keywords", data);
    }

    return result;
  }

  static Future<List<Media>> getMedia() async {
    APIResult result = await Apiraiser.data.get("Media", -1);

    if (result.success) {
      List<Media> media = (result.data as List<dynamic>)
          .map((p) => Media.fromJson(p as Map<String, dynamic>))
          .toList();
      return media;
    } else {
      return [];
    }
  }
}
