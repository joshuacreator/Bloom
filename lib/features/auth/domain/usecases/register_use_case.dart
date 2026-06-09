import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo _repo;

  const RegisterUseCase(this._repo);

  Future<UserEntity> execute(
    String email,
    String password,
    UserEntity user,
  ) {
    return _repo.register(email, password, user);
  }
}
