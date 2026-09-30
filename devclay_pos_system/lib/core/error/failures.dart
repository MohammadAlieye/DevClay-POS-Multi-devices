/// Failure types for domain and data layers.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local data unavailable']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong']);
}
