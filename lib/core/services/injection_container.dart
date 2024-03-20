import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/sources/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/create_user_usecase.dart';
import '../../features/auth/domain/usecases/get_users_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;
Future<void> diInit() async {
  sl
    //App Logic
    ..registerFactory(() => AuthBloc(
          createUserUseCase: sl(),
          getUsersUseCase: sl(),
        ))
    // Use cases
    ..registerLazySingleton(() => CreateUserUseCase(sl()))
    ..registerLazySingleton(() => GetUsersUseCase(sl()))
    // Repositories
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    //Data sources
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()))
    // External Dependencies
    ..registerLazySingleton(http.Client.new);
}
