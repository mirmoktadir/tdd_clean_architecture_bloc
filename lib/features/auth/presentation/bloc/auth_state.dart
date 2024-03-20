part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

///------------- Loading States ----------------///
class CreatingUserState extends AuthState {
  const CreatingUserState();
}

class GettingUserState extends AuthState {
  const GettingUserState();
}

///-------------------End-----------------///

///------------------- Success States-------------///
class UserCreatedState extends AuthState {
  const UserCreatedState();
}

class UserGotState extends AuthState {
  const UserGotState(this.users);
  final List<UserEntity> users;

  @override
  List<String> get props => users.map((user) => user.id).toList();
}

///------------------End-------------------///

/// ---------------Operation Failed-------------------///
class UserCreatingFailedState extends AuthState {
  const UserCreatingFailedState();
}

///------------------End-------------------///

///------------------Error States --------------///
class UserCreatingErrorState extends AuthState {
  final String message;

  const UserCreatingErrorState({required this.message});
  @override
  List<String> get props => [message];
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});
  @override
  List<String> get props => [message];
}

///------------------End-------------------///
