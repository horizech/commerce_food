import 'package:equatable/equatable.dart';

class Keyword extends Equatable {
  final int id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;

  const Keyword(
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.name,
  );

  factory Keyword.fromJson(Map<String, dynamic> json) {
    Keyword keyword = Keyword(
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

      // const []);
    );

    return keyword;
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(Keyword instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
      };

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
      ];
}
