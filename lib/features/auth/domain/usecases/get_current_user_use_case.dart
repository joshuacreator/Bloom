import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepo _repo;

  const GetCurrentUserUseCase(this._repo);

  Future<UserEntity?> execute() {
    return _repo.getCurrentUser();
  }
}
