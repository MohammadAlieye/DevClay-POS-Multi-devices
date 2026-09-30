import '../entities/auth_entities.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  const LoginUser(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionSnapshot> call({
    required String username,
    required String password,
    required bool rememberMe,
  }) {
    return _repository.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );
  }
}

class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionSnapshot?> call() => _repository.restoreSession();
}

class GetStores {
  const GetStores(this._repository);

  final AuthRepository _repository;

  Future<List<StoreInfo>> call() => _repository.getStores();
}

class SelectStore {
  const SelectStore(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionSnapshot> call({required int storeId}) {
    return _repository.selectStore(storeId: storeId);
  }
}

class LogoutUser {
  const LogoutUser(this._repository);

  final AuthRepository _repository;

  Future<void> call({bool clearRemembered = false}) {
    return _repository.logout(clearRemembered: clearRemembered);
  }
}

class RefreshSession {
  const RefreshSession(this._repository);

  final AuthRepository _repository;

  Future<AuthSessionSnapshot?> call() => _repository.refreshSession();
}
