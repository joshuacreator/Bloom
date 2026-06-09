import '../repositories/message_repo.dart';

class EditMessageUseCase {
  final MessageRepo _repo;

  const EditMessageUseCase(this._repo);

  Future<void> call({
    required String spaceId,
    required String roomId,
    required String messageId,
    required String newMessage,
  }) {
    return _repo.editMessage(spaceId, roomId, messageId, newMessage);
  }
}
