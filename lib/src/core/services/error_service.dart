import 'dart:developer';

abstract class ErrorService {
  void recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
  });
}

class ErrorServiceImpl implements ErrorService {
  @override
  void recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
  }) {
    log(
      'Error: $error',
      stackTrace: stackTrace,
      name: reason ?? '',
    );
  }
}
