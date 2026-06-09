import 'app_exceptions.dart';

String mapErrorToUserFriendlyMessage(AppException exception) {
  return switch (exception.runtimeType) {
    AuthException _ => _mapAuthError(exception),
    NetworkException _ => 'Network error. Please check your connection.',
    StorageException _ => 'Storage error. Please try again.',
    ValidationException _ => exception.message,
    NotFoundException _ => 'The requested resource was not found.',
    _ => 'Something went wrong. Please try again.',
  };
}

String _mapAuthError(AppException exception) {
  return switch (exception.code) {
    'user-not-found' => 'No account found with this email.',
    'wrong-password' => 'Incorrect password. Please try again.',
    'email-already-in-use' => 'An account already exists with this email.',
    'weak-password' => 'Password must be at least 6 characters.',
    'invalid-email' => 'Please enter a valid email address.',
    'too-many-requests' => 'Too many attempts. Please try again later.',
    'network-request-failed' => 'Network error. Please check your connection.',
    _ => exception.message,
  };
}
