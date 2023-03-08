import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Collection extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final int? parent;
  final int? media;

  const Collection({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.name,
    this.media,
    this.parent,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    try {
      Collection collection = Collection(
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
        media: json['Media'] as int?,
        parent: json['Parent'] as int?,
      );
      return collection;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Collection instance) => <String, dynamic>{
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
