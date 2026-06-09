class SpaceEntity {
  final String name;
  final String? id, desc, image, creatorId;
  final List<String>? participants, rooms;
  final DateTime createdAt;
  final bool private;

  const SpaceEntity({
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
}
