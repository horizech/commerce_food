// import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:typed_data';

import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:shop/environment.dart';
import 'package:shop/models/media.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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

  static Future<List<Media>?> getAllMedia() async {
    APIResult result;

    result = await Apiraiser.data.get("Media", -1);

    if (result.success) {
      List<Media> mediaList = (result.data as List<dynamic>)
          .map((c) => Media.fromJson(c as Map<String, dynamic>))
          .toList();
      return mediaList;
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

  static Future<APIResult?> uploadMedia(Uint8List list, String name) async {
    const storage = FlutterSecureStorage();
    String? jwt = await storage.read(key: "jwt");
    Map<String, String> headers = {
      "Authorization": "Bearer $jwt",
    };
    var uuid = const Uuid();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Environment.apiUrl}/API/Media'),
    );
    request.fields.addEntries({
      "MediaId": "0",
      "FileName": name,
      "MediaSource": "0",
      "Path": ""
    }.entries);
    request.headers.addAll(headers);

    request.files.add(http.MultipartFile.fromBytes("FormFile", list,
        filename: name.split("/").last));

    var res = await request.send();
    APIResult? result = APIResult.fromJson(
      json.decode(
        await res.stream.bytesToString(),
      ),
    );
    return result;
  }
}
