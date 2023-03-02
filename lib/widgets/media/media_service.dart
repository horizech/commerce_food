import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/media.dart';

class MediaService {
  static Future<Media?> getMedia(int? mediaId) async {
    APIResult result;

    List<QuerySearchItem> conditions = [
      QuerySearchItem(
        name: "Id",
        condition: ColumnCondition.equal,
        value: mediaId,
      )
    ];

    result = await Apiraiser.data.getByConditions("Media", conditions);

    if (result.success) {
      Media media = (result.data as List<dynamic>)
          .map((c) => Media.fromJson(c as Map<String, dynamic>))
          .first;
      return media;
    } else {
      return null;
    }
  }

  static Future<List<Media>> getMediaByList(List<int> mediaList) async {
    Apiraiser.validateAuthentication();

    APIResult result;
    List<Media> media = [];

    List<QuerySearchItem> conditions = [
      QuerySearchItem(
        name: "Id",
        condition: ColumnCondition.includes,
        value: mediaList,
      )
    ];

    try {
      result = await Apiraiser.data.getByConditions("Media", conditions);
      media = (result.data as List<dynamic>)
          .map((c) => Media.fromJson(c as Map<String, dynamic>))
          .toList();
      if (result.success) {
        return media;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
