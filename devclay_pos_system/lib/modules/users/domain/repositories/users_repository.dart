import '../entities/user_entities.dart';

abstract class UsersRepository {
  Future<List<StaffUserItem>> getUsers();

  Future<StaffUserItem> saveUser(
    StaffUserDraft draft, {
    int? id,
    StaffUserSaveContext? context,
  });

  Future<StaffUserItem> resetPassword({
    required int userId,
    required String password,
  });

  Future<StaffUserItem> setActive({
    required int userId,
    required bool isActive,
  });

  Future<void> deleteUser(int userId);
}
