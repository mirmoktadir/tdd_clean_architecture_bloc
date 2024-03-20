// what does the class depends on ?
// Answer -- MockAuthRemoteDataSource
// how we create a fake version of dependency?
// Answer -- Use Mocktail
// how do we control what our dependencies do?
// Answer -- Using the Mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_bloc/core/errors/exceptions.dart';
import 'package:tdd_clean_architecture_bloc/core/errors/failure.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/data/models/user_model.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/data/sources/auth_remote_data_source.dart';

import 'mock_auth_remote_datasource.mock.dart';

void main() {
  late AuthRepositoryImpl authRepositoryImpl;
  late AuthRemoteDataSource authRemoteDataSource;

  setUp(() {
    authRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl = AuthRepositoryImpl(authRemoteDataSource);
  });

  const tException = APIException(
    message: "Unknown error occurred!",
    statusCode: 500,
  );
  group("createUser", () {
    const createdAt = "__Created At__";
    const name = "__name__";
    const avatar = "__avatar__";
    test("should call the [RemoteDataSource.createUser] method", () async {
      //Arrange
      when(() => authRemoteDataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar"),
          )).thenAnswer((_) async => Future.value());

      //Act
      final result = await authRepositoryImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      //Assert
      expect(result, equals(const Right(null)));
      verify(() => authRemoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });
    test(
        "should return a [API Failure] when the call to remote data source is unsuccessful",
        () async {
      //Arrange
      when(() => authRemoteDataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar"),
          )).thenThrow(tException);
      //Act
      final result = await authRepositoryImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      // Assert
      expect(
        result,
        equals(
          left(
            APIFailures.fromException(tException),
          ),
        ),
      );
      verify(
        () => authRemoteDataSource.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        ),
      ).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });
  });

  group("getUsers", () {
    test("should call the [RemoteDataSource.getUsers] method", () async {
      //Arrange
      when(() => authRemoteDataSource.getUsers()).thenAnswer((_) async => []);
      //Act
      final result = await authRepositoryImpl.getUsers();
      //Assert
      expect(result, isA<Right<dynamic, List<UserModel>>>());
      verify(() => authRemoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });
    test(
        "should return a [API Failure] when the call to remote data source is unsuccessful",
        () async {
      //Arrange
      when(() => authRemoteDataSource.getUsers()).thenThrow(tException);
      //Act
      final result = await authRepositoryImpl.getUsers();
      //Assert
      expect(
        result,
        equals(
          left(
            APIFailures.fromException(tException),
          ),
        ),
      );
      verify(
        () => authRemoteDataSource.getUsers(),
      ).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });
  });
}
