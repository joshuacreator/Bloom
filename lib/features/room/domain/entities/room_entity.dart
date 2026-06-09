class RoomEntity {
  final String name;
  final String creatorId;
  final String? id;
  final String? desc;
  final String? image;
  final DateTime? createdAt;
  final bool private;
  final List<String> participants;

  const RoomEntity({
    required this.name,
    required this.creatorId,
    this.id,
    this.desc,
    this.image,
    this.createdAt,
    required this.private,
    required this.participants,
  });
}
