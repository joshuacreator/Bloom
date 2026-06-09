import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepo _repo;

  const LoginUseCase(this._repo);

  Future<UserEntity> execute(String email, String password) {
    return _repo.login(email, password);
  }
}
