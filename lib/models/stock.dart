import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Stock extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final int product;
  final int? productVariation;
  final int quantity;

  const Stock(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.product,
    this.productVariation,
    this.quantity,
  );

  factory Stock.fromJson(Map<String, dynamic> json) {
    try {
      Stock stock = Stock(
        json['Id'] as int,
        json['CreatedOn'] != null
            ? DateTime.parse(json['CreatedOn'] as String)
            : null,
        json['CreatedBy'] as int?,
        json['LastUpdatedOn'] != null
            ? DateTime.parse(json['LastUpdatedOn'] as String)
            : null,
        json['LastUpdatedBy'] as int?,
        json['Product'] as int,
        json['ProductVariation'] as int?,
        json['Quantity'] as int,
      );
      return stock;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(Stock instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Product': instance.product,
        'ProductVariation': instance.productVariation,
        'Quantity': instance.quantity,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        product,
        productVariation,
        quantity,
      ];
}
