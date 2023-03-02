import 'package:apiraiser/apiraiser.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/models/customer_info.dart';

class CustomerProfileService {
  static Future<CustomerProfile?> getcustomerProfile() async {
    int? userId = Apiraiser.authentication.getCurrentUser()!.id;
    APIResult customerProfileResult;

    List<QuerySearchItem> conditions = [];

    try {
      if (userId != null) {
        conditions = [
          QuerySearchItem(
            name: "UserId",
            condition: ColumnCondition.equal,
            value: userId,
          )
        ];

        customerProfileResult =
            await Apiraiser.data.getByConditions("CustomerProfile", conditions);

        if (customerProfileResult.success &&
            (customerProfileResult.data as List<dynamic>).isNotEmpty) {
          CustomerProfile customerProfile = (customerProfileResult.data
                  as List<dynamic>)
              .map((c) => CustomerProfile.fromJson(c as Map<String, dynamic>))
              .first;
          return customerProfile;
        } else {
          Map<String, dynamic> customerProfile = {
            "UserId": userId,
            "PrimaryInformation": null,
            "SecondaryInformation": null,
          };

          APIResult result =
              await Apiraiser.data.insert("CustomerProfile", customerProfile);
          if (result.success) {
            customerProfileResult = await Apiraiser.data
                .getByConditions("CustomerProfile", conditions);
            if (customerProfileResult.success &&
                (customerProfileResult.data as List<dynamic>).isNotEmpty) {
              CustomerProfile customerProfile =
                  (customerProfileResult.data as List<dynamic>)
                      .map(
                        (c) =>
                            CustomerProfile.fromJson(c as Map<String, dynamic>),
                      )
                      .first;
              return customerProfile;
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<APIResult?> updatecustomerProfile(
      CustomerProfile? customerProfile,
      Map<String, String> updatedInfo,
      bool isPrimary,
      bool isSecondary) async {
    Apiraiser.validateAuthentication();
    Map<String, dynamic> updatedProfile = {};
    try {
      if (customerProfile!.id != null) {
        if (isPrimary) {
          Map<String, String> primaryInfo = updatedInfo;

          updatedProfile = {
            // "UserId": userId,
            "PrimaryInformation": jsonEncode(primaryInfo),
            "SecondaryInformation": customerProfile.secondaryInfo!.isEmpty
                ? null
                : jsonEncode(customerProfile.secondaryInfo!),
          };
        } else if (isSecondary) {
          Map<String, String> secondaryInfo = updatedInfo;
          updatedProfile = {
            "UserId": customerProfile.userId,
            "PrimaryInformation": customerProfile.primaryInfo!.isEmpty
                ? null
                : jsonEncode(customerProfile.primaryInfo!),
            "SecondaryInformation": jsonEncode(secondaryInfo),
          };
        }
        APIResult result = await Apiraiser.data
            .update("CustomerProfile", customerProfile.id!, updatedProfile);
        if (result.success) {
          return result;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
