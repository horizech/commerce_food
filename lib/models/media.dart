import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final List<int>? img;
  final String? url;

  const Media(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
    this.img,
    this.url,
  );

  factory Media.fromJson(Map<String, dynamic> json) {
    Media media = Media(
      json['Id'] as int,
      json['CreatedOn'] != null
          ? (json['CreatedOn'] is String)
              ? DateTime.parse(json['CreatedOn'] as String)
              : json['CreatedOn']
          : null,
      json['CreatedBy'] as int?,
      json['LastUpdatedOn'] != null
          ? (json['LastUpdatedOn'] is String)
              ? DateTime.parse(json['LastUpdatedOn'] as String)
              : json['LastUpdatedOn']
          : null,
      json['LastUpdatedBy'] as int?,
      json['Name'] as String,
      json['Data'] != null
          ? (json['Data'] as List<dynamic>).map((e) => e as int).toList()
          : null,
      json['URL'] as String?,
    );
    return media;
  }

  Map<String, dynamic> toJson(Media instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Data': instance.img,
        'URL': instance.url,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        img,
        url,
      ];
}
