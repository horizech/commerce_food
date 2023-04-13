import 'dart:convert';

class Order {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final List<dynamic> orderDetail;
  final int user;
  final int? chef;
  final int? rider;
  final String? message;
  final int status;

  const Order({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.orderDetail,
    required this.user,
    this.rider,
    this.chef,
    this.message,
    required this.status,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    Order order = Order(
      id: json['Id'] as int,
      createdOn: json['CreatedOn'] != null
          ? (json['CreatedOn'] is String)
              ? DateTime.parse(json['CreatedOn'] as String)
              : json['CreatedOn']
          : null,
      createdBy: json['CreatedBy'] as int?,
      lastUpdatedOn: json['LastUpdatedOn'] != null
          ? (json['LastUpdatedOn'] is String)
              ? DateTime.parse(json['LastUpdatedOn'] as String)
              : json['LastUpdatedOn']
          : null,
      lastUpdatedBy: json['LastUpdatedBy'] as int?,
      orderDetail: (json['OrderDetails'] as String).isNotEmpty
          ? (jsonDecode((json['OrderDetails'] as String)) as List<dynamic>)
          : [],
      status: json["Status"] as int,
      user: json["User"] as int,
      chef: json["Chef"] as int?,
      rider: json["Rider"] as int?,
      message: json["Message"] as String?,

      // const []);
    );

    return order;
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(Order instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'OrderDetails': instance.orderDetail,
        'User': instance.user,
        'Chef': instance.chef,
        'Rider': instance.rider,
        'Message': instance.message,
        'Status': instance.status,
      };
}
