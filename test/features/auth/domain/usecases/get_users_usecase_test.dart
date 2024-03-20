// what does the class depends on ?
// Answer -- AuthRepository
// how we create a fake version of dependency?
// Answer -- Use Mocktail
// how do we control what our dependencies do?
// Answer -- Using the Mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/entities/user_entity.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/usecases/get_users_usecase.dart';

import 'mock_auth_repository.mock.dart';

void main() {
  late GetUsersUseCase getUsersUseCase;
  late AuthRepository repository;
  setUp(() {
    repository = MockAuthRepository();
    getUsersUseCase = GetUsersUseCase(repository);
  });
  const tResponse = [UserEntity.empty()];
  test(
      "Should call the [AuthRepository.getUsers] and return [List<UserEntity>]",
      () async {
    // Arrange
    when(() => repository.getUsers())
        .thenAnswer((_) async => const Right(tResponse));
    //Act
    final result = await getUsersUseCase();
    //Assert
    expect(result, equals(const Right<dynamic, List<UserEntity>>(tResponse)));
    verify(() => repository.getUsers()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
