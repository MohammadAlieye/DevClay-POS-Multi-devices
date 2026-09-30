DateTime? parseFirestoreDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toUtc();
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  if (value is String) {
    return DateTime.tryParse(value)?.toUtc();
  }
  // Firestore Timestamp duck-typing without depending on cloud_firestore.
  try {
    final dynamic ts = value;
    final DateTime dt = ts.toDate() as DateTime;
    return dt.toUtc();
  } catch (_) {
    return null;
  }
}

Object? toFirestoreDate(DateTime? value) => value?.toUtc().toIso8601String();
