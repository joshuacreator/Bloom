import '../../domain/entities/profile_entity.dart';

class ProfileDto {
  final String userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? about;
  final String? image;

  const ProfileDto({
    required this.userId,
    this.name,
    this.email,
    this.phone,
    this.about,
    this.image,
  });

  factory ProfileDto.fromFirestore(Map<String, dynamic> data, String id) {
    return ProfileDto(
      userId: id,
      name: data['name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      about: data['about'] as String?,
      image: data['image'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'about': about,
      'image': image,
    };
  }

  ProfileEntity toDomain() {
    return ProfileEntity(
      userId: userId,
      name: name ?? '',
      email: email ?? '',
      phone: phone ?? '',
      about: about ?? '',
      image: image ?? '',
    );
  }
}
