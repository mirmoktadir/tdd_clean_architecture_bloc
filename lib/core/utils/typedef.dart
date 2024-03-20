import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failures, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;
