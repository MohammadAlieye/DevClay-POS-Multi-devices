/// Hidden Super Admin identity.
///
/// This account is created manually in Firebase Authentication and is NEVER
/// stored in the `admins` collection, so it never appears in Users lists.
///
/// Change these values before production and keep them out of public repos
/// if you fork this project.
abstract final class SuperAdminConfig {
  static const email = 'superadmin@devclaypos.internal';
  static const displayName = 'Super Admin';

  static bool isSuperAdminEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return email.trim().toLowerCase() == SuperAdminConfig.email.toLowerCase();
  }
}
