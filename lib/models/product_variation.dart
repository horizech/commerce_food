import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductVariation extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String? description;
  final int product;
  final Map<String, int> options;
  final String? sku;
  final double? price;
  final double? discounPrice;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final int? gallery;
  final String? name;
  // final int? quantity;

  const ProductVariation({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
    this.description,
    required this.product,
    required this.options,
    this.price,
    this.sku,
    this.discounPrice,
    this.discountStartDate,
    this.discountEndDate,
    this.gallery,
  } // this.quantity,
      );

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    try {
      ProductVariation productVariation = ProductVariation(
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
        name: json['Name'] as String?,
        description: json['Description'] as String?,
        product: json['Product'] as int,
        options: (jsonDecode(json['Options'] as String) as Map<String, dynamic>)
            .cast<String, int>(),
        price: json['Price'] as double?,
        sku: json['SKU'] as String?,
        discounPrice: json['DiscountPrice'] as double?,
        discountStartDate: json['DiscountStartDate'] != null
            ? (json['DiscountStartDate'] is String)
                ? DateTime.parse(json['DiscountStartDate'] as String)
                : json['DiscountStartDate']
            : null,
        discountEndDate: json['DiscountEndDate'] != null
            ? (json['DiscountEndDate'] is String)
                ? DateTime.parse(json['DiscountEndDate'] as String)
                : json['DiscountEndDate']
            : null,
        gallery: json['Gallery'] as int?,
        // json['Quantity'] as int?,
      );

      return productVariation;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(ProductVariation instance) {
    Map<String, dynamic> optionsMap = {};
    if (instance.options.isNotEmpty) {
      for (var entry in instance.options.entries) {
        optionsMap[entry.key] = entry.value;
      }
    }
    return <String, dynamic>{
      'Id': instance.id,
      'CreatedOn': instance.createdOn,
      'CreatedBy': instance.createdBy,
      'LastUpdatedOn': instance.lastUpdatedOn,
      'LastUpdatedBy': instance.lastUpdatedBy,
      'Description': instance.description,
      'Product': instance.product,
      'Options': jsonEncode(optionsMap),
      'SKU': instance.sku,
      'Price': instance.price,
      'DiscountPrice': instance.discounPrice,
      'DiscountStartDate': instance.discountStartDate != null
          ? instance.discountStartDate!.toIso8601String()
          : null,
      'DiscountEndDate': instance.discountEndDate != null
          ? instance.discountEndDate!.toIso8601String()
          : null,
      'Gallery': instance.gallery,
      'Name': instance.name,
      // 'Quantity': instance.quantity,
    };
  }

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        description,
        product,
        sku,
        price,
        discounPrice,
        discountStartDate,
        discountEndDate,
        name,
      ];
}
