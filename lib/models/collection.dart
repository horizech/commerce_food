import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Collection extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final int? parent;
  final int? media;

  const Collection(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
    this.media,
    this.parent,
  );

  factory Collection.fromJson(Map<String, dynamic> json) {
    try {
      Collection collection = Collection(
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
        json['Media'] as int?,
        json['Parent'] as int?,
      );
      return collection;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(Collection instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Media': instance.media,
        'Parent': instance.parent,
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
        parent
      ];
}
