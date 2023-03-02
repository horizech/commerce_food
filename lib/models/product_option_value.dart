import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductOptionValue extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final int productOption;
  final int collection;

  const ProductOptionValue({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.name,
    required this.productOption,
    required this.collection,
  });

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) {
    try {
      ProductOptionValue size = ProductOptionValue(
        id: json['Id'] as int,
        createdOn: json['CreatedOn'] != null
            ? DateTime.parse(json['CreatedOn'] as String)
            : null,
        createdBy: json['CreatedBy'] as int?,
        lastUpdatedOn: json['LastUpdatedOn'] != null
            ? DateTime.parse(json['LastUpdatedOn'] as String)
            : null,
        lastUpdatedBy: json['LastUpdatedBy'] as int?,
        name: json['Name'] as String,
        productOption: json['ProductOption'] as int,
        collection: json['Collection'] as int,
      );
      return size;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(ProductOptionValue instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'ProductOption': instance.productOption,
        'Collection': instance.collection,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        productOption,
        collection,
      ];
}
