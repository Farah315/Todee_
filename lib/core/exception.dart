
abstract class AppException implements Exception {
  final String message;

  AppException([this.message = '']);

  @override
  String toString() => 'AppException: $message';
}

class DatabaseException extends AppException {
  DatabaseException([super.message = 'Database error occurred']);
}

class ValidationException extends AppException {
  ValidationException([super.message = 'Validation error occurred']);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Requested item not found']);
}