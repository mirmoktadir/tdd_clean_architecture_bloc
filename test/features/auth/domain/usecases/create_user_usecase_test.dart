// what does the class depends on ?
// Answer -- AuthRepository
// how we create a fake version of dependency?
// Answer -- Use Mocktail
// how do we control what our dependencies do?
// Answer -- Using the Mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/usecases/create_user_usecase.dart';

import 'mock_auth_repository.mock.dart';

void main() {
  late CreateUserUseCase createUserUseCase;
  late AuthRepository repository;
  const params = CreateUserParams.empty();
  setUp(() {
    repository = MockAuthRepository();
    createUserUseCase = CreateUserUseCase(repository);
  });
  test(
    "Should call the [AuthRepository.createUser]",
    () async {
      // Arrange
      when(
        () => repository.createUser(
          createdAt: any(named: "createdAt"),
          name: any(named: "name"),
          avatar: any(named: "avatar"),
        ),
      ).thenAnswer((_) async => const Right(null));
      // Act
      final result = await createUserUseCase(params);
      // Assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repository.createUser(
            createdAt: params.createdAt,
            name: params.name,
            avatar: params.avatar,
          )).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
