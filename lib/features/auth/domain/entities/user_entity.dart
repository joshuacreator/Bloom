class UserEntity {
  final String userId;
  final String name;
  final String email;
  final int phone;
  final bool emailVerified;
  final String? image;
  final String? about;

  const UserEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.emailVerified = false,
    this.image,
    this.about,
  });

  UserEntity copyWith({
    String? userId,
    String? name,
    String? email,
    int? phone,
    bool? emailVerified,
    String? image,
    String? about,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emailVerified: emailVerified ?? this.emailVerified,
      image: image ?? this.image,
      about: about ?? this.about,
    );
  }
}
