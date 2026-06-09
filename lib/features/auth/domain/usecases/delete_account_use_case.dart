import '../repositories/auth_repo.dart';

class DeleteAccountUseCase {
  final AuthRepo _repo;

  const DeleteAccountUseCase(this._repo);

  Future<void> execute() {
    return _repo.deleteAccount();
  }
}
