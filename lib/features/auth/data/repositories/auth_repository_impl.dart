import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authRemoteDataSource);
  final AuthRemoteDataSource _authRemoteDataSource;
  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // call the remote data source
    //check if the method return proper data
    // check if when remoteDataSource return an exception ,we return a failure
    // and if it doesn't throw an exception we return actual expected data
    try {
      await _authRemoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on APIException catch (e) {
      return left(APIFailures.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserEntity>> getUsers() async {
    try {
      final result = await _authRemoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return left(APIFailures.fromException(e));
    }
  }
}
