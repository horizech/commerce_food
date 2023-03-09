import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Product extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final String? description;
  final double? price;
  final bool isVariedProduct;
  final int thumbnail;
  final int gallery;
  final int collection;
  final List<int>? keywords;
  final double? discounPrice;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final String sku;
  final Map<String, int>? options;
  final Map<String, dynamic>? meta;

  // final int? media;

  const Product({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.name,
    this.description,
    this.price,
    this.isVariedProduct = false,
    required this.collection,
    required this.thumbnail,
    required this.keywords,
    required this.gallery,
    this.discounPrice,
    this.meta,
    this.discountStartDate,
    this.discountEndDate,
    required this.sku,
    this.options,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      Product product = Product(
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
        name: json['Name'] as String,
        description: json['Description'] as String?,
        price: json['Price'] as double?,
        isVariedProduct: json['IsVariedProduct'] as bool,
        collection: json['Collection'] as int,
        thumbnail: json['Thumbnail'] as int,
        keywords: json['Keywords'] != null
            ? (json['Keywords'] as List<dynamic>)
                .map((e) => convertToInt(e))
                .toList()
            : [],
        gallery: json['Gallery'] as int,
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
        sku: json['SKU'] as String,
        options: json['Options'] != null &&
                (json['Options'] as String).isNotEmpty
            ? (jsonDecode(json['Options'] as String) as Map<String, dynamic>)
                .cast<String, int>()
            : {},
        meta: json['Meta'] != null && (json['Meta'] as String).isNotEmpty
            ? (jsonDecode(json['Meta'] as String) as Map<String, dynamic>)
            : {},
      );
      // const []);
      return product;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(Product instance) {
    Map<String, dynamic> optionsMap = {};
    if (instance.options != null && instance.options!.isNotEmpty) {
      for (var entry in instance.options!.entries) {
        optionsMap[entry.key] = entry.value;
      }
    }
    Map<String, dynamic> metaMap = {};
    if (instance.meta != null && instance.meta!.isNotEmpty) {
      for (var entry in instance.meta!.entries) {
        metaMap[entry.key] = entry.value;
      }
    }

    return <String, dynamic>{
      'Id': instance.id,
      'CreatedOn': instance.createdOn,
      'CreatedBy': instance.createdBy,
      'LastUpdatedOn': instance.lastUpdatedOn,
      'LastUpdatedBy': instance.lastUpdatedBy,
      'Name': instance.name,
      'Description': instance.description,
      'Price': instance.price,
      'IsVariedProduct': instance.isVariedProduct,
      'Collection': instance.collection,
      'Thumbnail': instance.thumbnail,
      'Keywords': instance.keywords,
      'Gallery': instance.gallery,
      'DiscountPrice': instance.discounPrice,
      'DiscountStartDate': instance.discountStartDate != null
          ? instance.discountStartDate!.toIso8601String()
          : null,
      'DiscountEndDate': instance.discountEndDate != null
          ? instance.discountEndDate!.toIso8601String()
          : null,
      'SKU': instance.sku,
      'Options': jsonEncode(optionsMap),
      'Meta': jsonEncode(metaMap),
    };
  }

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        description,
        price,
        thumbnail,
      ];
}
