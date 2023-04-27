/// User model
class User1 {
  final int? id;
  final String username;
  final String fullname;
  final String email;

  /// Constructor
  User1({
    this.id,
    required this.username,
    required this.fullname,
    required this.email,
  });

  /// Get model from Json
  factory User1.fromJson(Map<String, dynamic> json) {
    try {
      User1 user = User1(
        id: json['Id'] as int?,
        username: json['Username'] as String,
        fullname: json['Fullname'] != null ? json['Fullname'] as String : "",
        email: json['Email'] as String,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Json from model
  Map<String, dynamic> toJson(User1 instance) => <String, dynamic>{
        'Id': instance.id,
        'Username': instance.username,
        'Fullname': instance.fullname,
        'Email': instance.email,
      };
}
