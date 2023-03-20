import 'package:flutter/material.dart';

class ProductAttribute {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final int product;
  final int attribute;
  final List<int> attributeValues;
  final bool mandatory;
  final bool useForVariation;

  const ProductAttribute(
      {this.id,
      this.createdOn,
      this.createdBy,
      this.lastUpdatedOn,
      this.lastUpdatedBy,
      required this.product,
      required this.attribute,
      required this.attributeValues,
      required this.mandatory,
      required this.useForVariation});

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    try {
      ProductAttribute attribute = ProductAttribute(
        id: json['Id'] as int,
        createdOn: json['CreatedOn'] != null
            ? DateTime.parse(json['CreatedOn'] as String)
            : null,
        createdBy: json['CreatedBy'] as int?,
        lastUpdatedOn: json['LastUpdatedOn'] != null
            ? DateTime.parse(json['LastUpdatedOn'] as String)
            : null,
        lastUpdatedBy: json['LastUpdatedBy'] as int?,
        product: json['Product'] as int,
        attribute: json['Attribute'] as int,
        mandatory: json['Mandatory'] as bool,
        useForVariation: json['UseForVariation'] as bool,
        attributeValues: json['AttributeValues'] != null
            ? (json['AttributeValues'] as List<dynamic>)
                .map((e) => convertToInt(e))
                .toList()
            : [],
      );
      return attribute;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  Map<String, dynamic> toJson(ProductAttribute instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Product': instance.product,
        'Attribute': instance.attribute,
        'AttributeValues': instance.attributeValues,
        'Mandatory': instance.mandatory,
        'UseForVariation': instance.useForVariation,
      };
}
