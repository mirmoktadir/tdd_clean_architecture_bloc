import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetUsersUseCase extends UseCaseWithoutParams<List<UserEntity>> {
  final AuthRepository _authRepository;

  GetUsersUseCase(this._authRepository);

  @override
  ResultFuture<List<UserEntity>> call() async => _authRepository.getUsers();
}
