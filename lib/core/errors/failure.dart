import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failures extends Equatable {
  final String message;
  final int statusCode;

  const Failures({
    required this.message,
    required this.statusCode,
  });
  String get errorMessage => '$statusCode  Error: $message';
  @override
  List<Object> get props => [message, statusCode];
}

/// Failures comes from API
class APIFailures extends Failures {
  const APIFailures({
    required super.message,
    required super.statusCode,
  });

  APIFailures.fromException(APIException exception)
      : this(message: exception.message, statusCode: exception.statusCode);
}
