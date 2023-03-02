import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ProductKeyword extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final int product;
  final int keyword;

  const ProductKeyword(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.product,
    this.keyword,
  );

  factory ProductKeyword.fromJson(Map<String, dynamic> json) {
    try {
      ProductKeyword productKeyword = ProductKeyword(
        json['Id'] as int,
        json['CreatedOn'] != null
            ? (json['CreatedOn'] is String)
                ? DateTime.parse(json['CreatedOn'] as String)
                : json['CreatedOn']
            : null,
        json['CreatedBy'] as int?,
        json['LastUpdatedOn'] != null
            ? (json['LastUpdatedOn'] is String)
                ? DateTime.parse(json['LastUpdatedOn'] as String)
                : json['LastUpdatedOn']
            : null,
        json['LastUpdatedBy'] as int?,
        json['Product'] as int,
        json['Keyword'] as int,
      );

      return productKeyword;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(ProductKeyword instance) =>
      <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Product': instance.product,
        'ProductKeyword': instance.keyword,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        product,
        keyword,
      ];
}
