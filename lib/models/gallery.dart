import 'package:equatable/equatable.dart';

class Gallery extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String? name;
  final List<int> mediaList;

  const Gallery({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
    required this.mediaList,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    Gallery gallery = Gallery(
      id: json['Id'] as int,
      createdOn: json['CreatedOn'] != null
          ? (json['CreatedOn'] is String)
              ? DateTime.parse(json['CreatedOn'] as String)
              : json['CreatedOn']
          : null,
      createdBy: json['CreatedBy'] as int?,
      lastUpdatedOn: json['LastUpdatedOn'] != null
          ? (json['LastUpdatedOn'] is String)
              ? DateTime.parse(json['LastUpdatedOn'] as String)
              : json['LastUpdatedOn']
          : null,
      lastUpdatedBy: json['LastUpdatedBy'] as int?,
      name: json['Name'] as String?,
      mediaList: json['MediaList'] != null
          ? (json['MediaList'] as List<dynamic>)
              .map((e) => convertToInt(e))
              .toList()
          // ? (json['Variations'] as List<int>)
          : [],
    );
    return gallery;
  }
  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(Gallery instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'MediaList': instance.mediaList,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        mediaList,
      ];
}
