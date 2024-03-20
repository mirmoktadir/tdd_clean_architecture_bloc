import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/auth_repository.dart';

class CreateUserUseCase extends UseCaseWithParams<void, CreateUserParams> {
  final AuthRepository _authRepository;

  CreateUserUseCase(this._authRepository);

  @override
  ResultVoid call(CreateUserParams params) async => _authRepository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  const CreateUserParams.empty()
      : this(
            createdAt: "_empty.createdAt",
            name: "_empty.name",
            avatar: "empty.avatar");

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
