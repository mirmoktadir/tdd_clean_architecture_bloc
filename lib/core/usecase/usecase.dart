import '../utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {
  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  ResultFuture<Type> call();
}
