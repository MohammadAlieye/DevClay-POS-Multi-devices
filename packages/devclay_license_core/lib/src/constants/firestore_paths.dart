/// Firestore collection / document paths shared by POS and Admin.
abstract final class FirestorePaths {
  static const licenses = 'licenses';
  static const customers = 'customers';
  static const settings = 'settings';
  static const settingsGlobal = 'global';
  static const auditLogs = 'auditLogs';
  static const admins = 'admins';
  static const deviceTrials = 'deviceTrials';
  static const licenseRequests = 'licenseRequests';

  static String license(String id) => '$licenses/$id';
  static String customer(String id) => '$customers/$id';
  static String auditLog(String id) => '$auditLogs/$id';
  static String admin(String uid) => '$admins/$uid';
  static String deviceTrial(String machineId) => '$deviceTrials/$machineId';
  static String licenseRequest(String id) => '$licenseRequests/$id';
  static String licenseHistory(String licenseId) =>
      '$licenses/$licenseId/activationHistory';
}
