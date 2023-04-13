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
        QuerySearchItem(
            name: "Status", condition: ColumnCondition.equal, value: 1)
      ];
    }
    APIResult result =
        await Apiraiser.data.getByConditions("Orders", conditions);
    if (result.success) {
      Order order = (result.data as List<dynamic>)
          .map((p) => Order.fromJson(p as Map<String, dynamic>))
          .first;
      return order;
    } else {
      return null;
    }
  }

  static Future<APIResult?> updateOrder(
      Map<String, dynamic> orderData, int id) async {
    return null;
  }
}
