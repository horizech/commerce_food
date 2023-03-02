import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductOption extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;

  const ProductOption({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.name,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    try {
      ProductOption size = ProductOption(
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
      );
      return size;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(ProductOption instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
      ];
}
