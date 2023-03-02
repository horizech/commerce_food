import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Gender extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final int media;

  const Gender(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
    this.media,
  );

  factory Gender.fromJson(Map<String, dynamic> json) {
    try {
      Gender category = Gender(
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
        json['Media'] as int,
      );
      return category;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(Gender instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Media': instance.media,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        media,
      ];
}
