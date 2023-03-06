class ProductCombo {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final int combo;
  final int product;

  const ProductCombo({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.product,
    required this.combo,
  });

  factory ProductCombo.fromJson(Map<String, dynamic> json) {
    ProductCombo combo = ProductCombo(
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
      product: json['Product'] as int,
      combo: json['Combo'] as int,
    );

    return combo;
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(ProductCombo instance) =>
      <String, dynamic>{
        'Id': instance.id,
        'CreatedOn': instance.createdOn,
        'CreatedBy': instance.createdBy,
        'LastUpdatedOn': instance.lastUpdatedOn,
        'LastUpdatedBy': instance.lastUpdatedBy,
        'Product': instance.product,
        'Combo': instance.combo,
      };
}
