import 'package:flutter/material.dart';

class Restaurant {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final String address;
  final int phoneNo;
  final String openingTime;
  final String closingTime;
  final int? thumbnail;
  final int rating;

  const Restaurant({
    required this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.name,
    required this.rating,
    required this.address,
    required this.phoneNo,
    required this.openingTime,
    required this.closingTime,
    required this.thumbnail,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    try {
      Restaurant restaurant = Restaurant(
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
        address: json['Address'] as String,
        phoneNo: json['PhoneNo'] as int,
        openingTime: json['OpeningTime'] as String,
        closingTime: json['ClosingTime'] as String,
        thumbnail: json['Thumbnail'] as int?,
        rating: json['Rating'] as int,
      );
      return restaurant;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(Restaurant instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Address': instance.address,
        'PhoneNo': instance.phoneNo,
        'OpeningTime': instance.openingTime,
        'ClosingTime': instance.closingTime,
        'Rating': instance.rating,
        'Thumbnail': instance.thumbnail,
      };
}
