class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
    };
  }
}
