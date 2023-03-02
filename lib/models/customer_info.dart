import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CustomerProfile extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final int userId;
  final Map<String, String>? primaryInfo;
  final Map<String, String>? secondaryInfo;

  const CustomerProfile({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.userId,
    this.primaryInfo,
    this.secondaryInfo,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    try {
      CustomerProfile customerInfo = CustomerProfile(
          id: (json['Id'] as int),
          createdOn: json['CreatedOn'] != null
              ? DateTime.parse(json['CreatedOn'] as String)
              : null,
          createdBy: json['CreatedBy'] as int?,
          lastUpdatedOn: json['LastUpdatedOn'] != null
              ? DateTime.parse(json['LastUpdatedOn'] as String)
              : null,
          lastUpdatedBy: json['LastUpdatedBy'] as int?,
          userId: json['UserId'] as int,
          primaryInfo: json['PrimaryInformation'] != null
              ? (jsonDecode(json['PrimaryInformation'] as String)
                      as Map<String, dynamic>)
                  .cast<String, String>()
              : {},
          secondaryInfo: json['SecondaryInformation'] != null
              ? (jsonDecode(json['SecondaryInformation'] as String)
                      as Map<String, dynamic>)
                  .cast<String, String>()
              : {});
      return customerInfo;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson(CustomerProfile instance) {
    try {
      Map<String, dynamic> customerInfo = {
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'UserId': instance.userId,
        'PrimaryInformation': instance.primaryInfo,
        'SecondaryInformation': instance.secondaryInfo,
      };
      return customerInfo;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        userId,
        primaryInfo,
        secondaryInfo,
      ];
}
