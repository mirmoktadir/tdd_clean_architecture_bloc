import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CreateUserUseCase createUserUseCase,
    required GetUsersUseCase getUsersUseCase,
  })  : _createUserUseCase = createUserUseCase,
        _getUsersUseCase = getUsersUseCase,
        super(const AuthInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUserEvent>(_getUserHandler);
  }
  final CreateUserUseCase _createUserUseCase;
  final GetUsersUseCase _getUsersUseCase;

  Future<void> _createUserHandler(
      CreateUserEvent event, Emitter<AuthState> emit) async {
    emit(const CreatingUserState());
    final result = await _createUserUseCase(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));
    result.fold(
        (failure) =>
            emit(UserCreatingErrorState(message: failure.errorMessage)),
        (_) => emit(const UserCreatedState()));
  }

  Future<void> _getUserHandler(
      GetUserEvent event, Emitter<AuthState> emit) async {
    emit(const GettingUserState());
    final result = await _getUsersUseCase();
    result.fold(
        (failure) => emit(AuthErrorState(message: failure.errorMessage)),
        (users) => emit(UserGotState(users)));
  }
}
