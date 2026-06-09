import '../repositories/auth_repo.dart';

class SendEmailVerificationUseCase {
  final AuthRepo _repo;

  const SendEmailVerificationUseCase(this._repo);

  Future<void> execute() {
    return _repo.sendEmailVerificationLink();
  }
}
