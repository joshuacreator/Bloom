import '../../domain/entities/user_entity.dart';

class UserDto {
  final String userId;
  final String name;
  final String email;
  final int phone;
  final String? image;
  final String? about;

  const UserDto({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.about,
  });

  factory UserDto.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserDto(
      userId: documentId,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as int? ?? 0,
      image: data['image'] as String?,
      about: data['about'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      if (image != null) 'image': image,
      if (about != null) 'about': about,
    };
  }

  UserEntity toDomain({bool emailVerified = false}) {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      emailVerified: emailVerified,
      image: image,
      about: about,
    );
  }
}
