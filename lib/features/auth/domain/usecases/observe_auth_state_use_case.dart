import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class ObserveAuthStateUseCase {
  final AuthRepo _repo;

  const ObserveAuthStateUseCase(this._repo);

  Stream<UserEntity?> execute() {
    return _repo.authStateChanges();
  }
}
