import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/space_entity.dart';

class SpaceDTO {
  final String? id;
  final String name;
  final String? desc, image, creatorId;
  final List<String>? participants, rooms;
  final DateTime createdAt;
  final bool private;

  const SpaceDTO({
    this.id,
    required this.name,
    this.desc,
    this.image,
    this.creatorId,
    this.participants,
    this.rooms,
    required this.createdAt,
    required this.private,
  });

  factory SpaceDTO.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SpaceDTO(
      id: doc.id,
      name: data['name'] as String? ?? '',
      desc: data['desc'] as String?,
      image: data['image'] as String?,
      creatorId: data['creatorId'] as String?,
      participants: data['participants'] != null
          ? List<String>.from(data['participants'] as List)
          : null,
      rooms: data['rooms'] is List
          ? List<String>.from(data['rooms'] as List)
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      private: data['private'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'desc': desc,
        'image': image,
        'creatorId': creatorId,
        'participants': participants,
        'rooms': rooms,
        'createdAt': createdAt,
        'private': private,
      };

  SpaceEntity toDomain() => SpaceEntity(
        id: id,
        name: name,
        desc: desc,
        image: image,
        creatorId: creatorId,
        participants: participants,
        rooms: rooms,
        createdAt: createdAt,
        private: private,
      );

  factory SpaceDTO.fromDomain(SpaceEntity entity) => SpaceDTO(
        id: entity.id,
        name: entity.name,
        desc: entity.desc,
        image: entity.image,
        creatorId: entity.creatorId,
        participants: entity.participants,
        rooms: entity.rooms,
        createdAt: entity.createdAt,
        private: entity.private,
      );
}
