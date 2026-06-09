import '../repositories/message_repo.dart';

class DeleteMessageUseCase {
  final MessageRepo _repo;

  const DeleteMessageUseCase(this._repo);

  Future<void> call({
    required String spaceId,
    required String roomId,
    required String messageId,
  }) {
    return _repo.deleteMessage(spaceId, roomId, messageId);
  }
}
