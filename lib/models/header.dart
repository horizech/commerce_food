import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Header extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;

  final List<int> categories;

  const Header(this.id, this.createdOn, this.createdBy, this.lastUpdatedOn,
      this.lastUpdatedBy, this.name, this.categories);

  factory Header.fromJson(Map<String, dynamic> json) {
    try {
      Header header = Header(
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
        json['Categories'] != null
            ? (json['Categories'] as List<dynamic>)
                .map((e) => convertToInt(e))
                .toList()
            // ? (json['Variations'] as List<int>)
            : [],
      );
      return header;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  Map<String, dynamic> toJson(Header instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Categories': instance.categories,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        categories,
      ];
}
