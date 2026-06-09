class DirectMessageEntity {
  final String id;
  final String message;
  final String fromId;
  final String toId;
  final String? image;
  final String? file;
  final DateTime time;
  final bool pending;
  final List<String> participants;

  const DirectMessageEntity({
    required this.id,
    required this.message,
    required this.fromId,
    required this.toId,
    this.image,
    this.file,
    required this.time,
    this.pending = false,
    this.participants = const [],
  });
}
