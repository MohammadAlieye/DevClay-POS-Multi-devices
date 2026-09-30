import '../domain/entities/auth_entities.dart';
import '../domain/repositories/auth_repository.dart';
import 'datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._local);

  final AuthLocalDataSource _local;

  @override
  Future<AuthSessionSnapshot?> restoreSession() => _local.restoreSession();

  @override
  Future<AuthSessionSnapshot> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) {
    return _local.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );
  }

  @override
  Future<List<StoreInfo>> getStores() => _local.getStores();

  @override
  Future<AuthSessionSnapshot> selectStore({required int storeId}) {
    return _local.selectStore(storeId: storeId);
  }

  @override
  Future<void> logout({bool clearRemembered = false}) {
    return _local.logout(clearRemembered: clearRemembered);
  }

  @override
  Future<AuthSessionSnapshot?> refreshSession() => _local.refreshSession();
}
