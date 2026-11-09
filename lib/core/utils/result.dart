import 'package:j_donuts/core/error/failures.dart';

sealed class Result<T> {
  // sealed class mean no other class can extend this class outside this file
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);
}
