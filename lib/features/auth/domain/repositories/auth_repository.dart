import '../../../../core/utils/typedef.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<UserEntity>> getUsers();
}
