import '../../domain/entities/room_entity.dart';

class RoomDto {
  final String name;
  final String creatorId;
  final String? id;
  final String? desc;
  final String? image;
  final DateTime? createdAt;
  final bool private;
  final List<String> participants;

  const RoomDto({
    required this.name,
    required this.creatorId,
    this.id,
    this.desc,
    this.image,
    this.createdAt,
    required this.private,
    required this.participants,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json, {String? docId}) {
    return RoomDto(
      id: docId ?? json['id'] as String?,
      name: json['name'] as String,
      creatorId: json['creatorId'] as String,
      desc: json['desc'] as String?,
      image: json['image'] as String?,
      createdAt: (json['createdAt'] as dynamic)?.toDate(),
      private: json['private'] as bool,
      participants: List<String>.from(json['participants'] as List),
    );
  }

  RoomEntity toDomain() {
    return RoomEntity(
      id: id,
      name: name,
      creatorId: creatorId,
      desc: desc,
      image: image,
      createdAt: createdAt,
      private: private,
      participants: participants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'creatorId': creatorId,
      if (desc != null) 'desc': desc,
      if (image != null) 'image': image,
      'createdAt': createdAt ?? DateTime.now(),
      'private': private,
      'participants': participants,
    };
  }
}
