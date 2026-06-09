import '../entities/message_entity.dart';
import '../repositories/message_repo.dart';

class SendMessageUseCase {
  final MessageRepo _repo;

  const SendMessageUseCase(this._repo);

  Future<void> call({
    required MessageEntity message,
    required String spaceId,
    required String roomId,
    String? imagePath,
    String? filePath,
  }) {
    return _repo.sendMessage(
      message,
      spaceId,
      roomId,
      imagePath,
      filePath,
    );
  }
}
