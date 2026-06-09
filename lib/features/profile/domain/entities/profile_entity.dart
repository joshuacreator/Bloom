class ProfileEntity {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String about;
  final String image;

  const ProfileEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.about,
    required this.image,
  });

  ProfileEntity copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? about,
    String? image,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          about == other.about &&
          image == other.image;

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      about.hashCode ^
      image.hashCode;
}
