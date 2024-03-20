import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_bloc/core/errors/failure.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/usecases/create_user_usecase.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/usecases/get_users_usecase.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/presentation/bloc/auth_bloc.dart';

// Mocking the dependencies
class MockCreateUserUseCase extends Mock implements CreateUserUseCase {}

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

void main() {
  late AuthBloc authBloc;
  late CreateUserUseCase createUserUseCase;
  late GetUsersUseCase getUsersUseCase;
  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailures(message: "message", statusCode: 400);

  setUp(() {
    createUserUseCase = MockCreateUserUseCase();
    getUsersUseCase = MockGetUsersUseCase();
    authBloc = AuthBloc(
      createUserUseCase: createUserUseCase,
      getUsersUseCase: getUsersUseCase,
    );
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => authBloc.close());

  test("initial state should be [AuthInitial]", () async {
    expect(authBloc.state, const AuthInitial());
  });

  group("createUser", () {
    blocTest<AuthBloc, AuthState>(
      "should emit [CreatingUserState, UserCreatedState] when successful",
      build: () {
        when(() => createUserUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        CreateUserEvent(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
      ),
      expect: () => [
        const CreatingUserState(),
        const UserCreatedState(),
      ],
      verify: (_) {
        verify(() => createUserUseCase(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUserUseCase);
      },
    );
    blocTest<AuthBloc, AuthState>(
      "should emit [CreatingUserState,UserCreatingErrorState] when unsuccessful",
      build: () {
        when(() => createUserUseCase(any()))
            .thenAnswer((_) async => const Left(tAPIFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        CreateUserEvent(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
      ),
      expect: () => [
        const CreatingUserState(),
        UserCreatingErrorState(message: tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUserUseCase(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUserUseCase);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthBloc, AuthState>(
      "should emit [GettingUserState,UserGotState]when successful",
      build: () {
        when(() => getUsersUseCase()).thenAnswer((_) async => const Right([]));
        return authBloc;
      },
      act: (bloc) => bloc.add(const GetUserEvent()),
      expect: () => [
        const GettingUserState(),
        const UserGotState([]),
      ],
      verify: (_) {
        verify(() => getUsersUseCase()).called(1);
        verifyNoMoreInteractions(getUsersUseCase);
      },
    );
    blocTest<AuthBloc, AuthState>(
      "should emit [GettingUserState,AuthErrorState] when unsuccessful",
      build: () {
        when(() => getUsersUseCase())
            .thenAnswer((_) async => const Left(tAPIFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const GetUserEvent()),
      expect: () => [
        const GettingUserState(),
        AuthErrorState(message: tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsersUseCase()).called(1);
        verifyNoMoreInteractions(getUsersUseCase);
      },
    );
  });
}
