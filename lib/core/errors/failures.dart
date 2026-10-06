import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class BadRequestFailure extends Failure {
  BadRequestFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(super.message);
}

class ForbiddenFailure extends Failure{
   ForbiddenFailure(super.message);
}

class NotFoundFailure extends Failure{
  NotFoundFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  TimeoutFailure(super.message);
}