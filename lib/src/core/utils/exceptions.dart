import 'dart:developer';

class BaseException implements Exception {
  final String message;

  BaseException(this.message) {
    log('$runtimeType  :$message');
  }
}

class UsecaseException extends BaseException {
  UsecaseException(super.message);
}

class NetworkException extends BaseException {
  NetworkException(super.message);
}

class DataSourceException extends BaseException {
  DataSourceException(super.message);
}

class RepositoryException extends BaseException {
  RepositoryException(super.message);
}
