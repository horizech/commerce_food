import 'package:apiraiser/apiraiser.dart';
import 'package:shop/models/order.dart';

class OrderService {
  static Future<APIResult?> createOrder(Map<String, dynamic> orderData) async {
    APIResult? result = await Apiraiser.data.insert("Orders", orderData);

    return result;
  }

  static Future<Order?> getOrder() async {
    List<QuerySearchItem> conditions = [];
    if (Apiraiser.authentication.isSignedIn()) {
      conditions = [
        QuerySearchItem(
            name: "User",
            condition: ColumnCondition.equal,
            value: Apiraiser.authentication.getCurrentUser()!.id!),
      ];
    }
    APIResult result =
        await Apiraiser.data.getByConditions("Orders", conditions);
    if (result.success) {
      List<Order> orders = (result.data as List<dynamic>)
          .map((p) => Order.fromJson(p as Map<String, dynamic>))
          .toList();
      if (orders.isNotEmpty) {
        orders.sort((a, b) => a.id!.compareTo(b.id!));
      }
      return orders.last;
    } else {
      return null;
    }
  }

  static Future<List<Order>?> getOrders(statusId1, statusId2) async {
    List<QuerySearchItem> conditions = [];
    if (Apiraiser.authentication.isSignedIn()) {
      conditions = [
        QuerySearchItem(
            name: "Status",
            condition: ColumnCondition.includes,
            value: [
              statusId1,
              statusId2,
            ]),
      ];
    }
    APIResult result =
        await Apiraiser.data.getByConditions("Orders", conditions);
    if (result.success) {
      List<Order>? orders = (result.data as List<dynamic>)
          .map((p) => Order.fromJson(p as Map<String, dynamic>))
          .toList();
      return orders;
    } else {
      return null;
    }
  }

  static Future<APIResult?> updateOrder(
      Map<String, dynamic> orderData, int id) async {
    APIResult? result = await Apiraiser.data.update("Orders", id, orderData);

    return result;
  }
}
