import '../repositories/profile_repo.dart';

class DeleteAccountUseCase {
  final ProfileRepo repo;

  const DeleteAccountUseCase(this.repo);

  Future<void> call() => repo.deleteAccount();
}
