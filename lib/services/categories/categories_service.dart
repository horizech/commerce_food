import 'package:apiraiser/apiraiser.dart';

import 'package:shop/models/collection.dart';

class CategoryService {
  static Future<List<Collection>> getCategories(
    int limit,
    int? parent,
  ) async {
    APIResult result;

    if (parent == null) {
      List<QuerySearchItem> conditions = [
        QuerySearchItem(
          name: "Parent",
          condition: ColumnCondition.equal,
          value: parent,
        )
      ];

      result = await Apiraiser.data.getByConditions("Categories", conditions);
    } else {
      List<QuerySearchItem> conditions = [
        QuerySearchItem(
          name: "Parent",
          condition: ColumnCondition.equal,
          value: parent,
        )
      ];

      result = await Apiraiser.data.getByConditions("Categories", conditions);
    }

    List<Collection> collection = (result.data as List<dynamic>)
        .map((c) => Collection.fromJson(c as Map<String, dynamic>))
        .toList();
    if (result.success) {
      return collection;
    } else {
      return [];
    }
  }
}
