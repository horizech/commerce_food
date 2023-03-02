import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Information extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final String? description;
  final int category;

  const Information(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
    this.description,
    this.category,
  );

  factory Information.fromJson(Map<String, dynamic> json) {
    try {
      Information color = Information(
        json['Id'] as int,
        json['CreatedOn'] != null
            ? DateTime.parse(json['CreatedOn'] as String)
            : null,
        json['CreatedBy'] as int?,
        json['LastUpdatedOn'] != null
            ? DateTime.parse(json['LastUpdatedOn'] as String)
            : null,
        json['LastUpdatedBy'] as int?,
        json['Name'] as String,
        json['Description'] as String?,
        json['Category'] as int,
      );
      return color;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(Information instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Description': instance.description,
        'Category': instance.category,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        description,
        category,
      ];
}
