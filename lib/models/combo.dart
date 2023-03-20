class Combo {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final String? description;
  final double price;
  final int? gallery;
  final int? thumbnail;
  final Map<String, dynamic>? fixedVariations;

  const Combo(
      {this.id,
      this.createdOn,
      this.createdBy,
      this.lastUpdatedOn,
      this.lastUpdatedBy,
      required this.name,
      this.description,
      required this.price,
      this.gallery,
      this.thumbnail,
      this.fixedVariations});

  factory Combo.fromJson(Map<String, dynamic> json) {
    Combo combo = Combo(
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
      name: json['Name'] as String,
      description: json['Description'] as String,
      price: json['Price'] as double,
      gallery: json['Gallery'] as int?,
      thumbnail: json['Thumbnail'] as int?,
      fixedVariations: json['FixedVariations'] != null &&
              (json['FixedVariations'] as String).isNotEmpty
          ? (json['FixedVariations'] as String) as Map<String, dynamic>
          : null,

      // const []);
    );

    return combo;
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(Combo instance) => <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Name': instance.name,
        'Description': instance.description,
        'Gallery': instance.gallery,
        'Price': instance.price,
        'Thumbnail': instance.thumbnail
      };
}
