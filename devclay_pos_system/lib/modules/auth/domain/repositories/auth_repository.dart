import '../entities/auth_entities.dart';

abstract class AuthRepository {
  Future<AuthSessionSnapshot?> restoreSession();

  Future<AuthSessionSnapshot> login({
    required String username,
    required String password,
    required bool rememberMe,
  });

  Future<List<StoreInfo>> getStores();

  Future<AuthSessionSnapshot> selectStore({
    required int storeId,
  });

  Future<void> logout({bool clearRemembered = false});
  Future<AuthSessionSnapshot?> refreshSession();
}
