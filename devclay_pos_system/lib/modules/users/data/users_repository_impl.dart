import '../domain/entities/user_entities.dart';
import '../domain/repositories/users_repository.dart';
import 'datasources/users_local_datasource.dart';

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(this._local);

  final UsersLocalDataSource _local;

  @override
  Future<List<StaffUserItem>> getUsers() => _local.getUsers();

  @override
  Future<StaffUserItem> saveUser(
    StaffUserDraft draft, {
    int? id,
    StaffUserSaveContext? context,
  }) {
    return _local.saveUser(draft, id: id, context: context);
  }

  @override
  Future<StaffUserItem> resetPassword({
    required int userId,
    required String password,
  }) {
    return _local.resetPassword(userId: userId, password: password);
  }

  @override
  Future<StaffUserItem> setActive({
    required int userId,
    required bool isActive,
  }) {
    return _local.setActive(userId: userId, isActive: isActive);
  }

  @override
  Future<void> deleteUser(int userId) => _local.deleteUser(userId);
}
