import '../repositories/auth_repo.dart';

class SignOutUseCase {
  final AuthRepo _repo;

  const SignOutUseCase(this._repo);

  Future<void> execute() {
    return _repo.signOut();
  }
}
