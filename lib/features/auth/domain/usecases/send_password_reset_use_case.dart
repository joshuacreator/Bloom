import '../repositories/auth_repo.dart';

class SendPasswordResetUseCase {
  final AuthRepo _repo;

  const SendPasswordResetUseCase(this._repo);

  Future<void> execute(String email) {
    return _repo.sendPasswordResetLink(email);
  }
}
