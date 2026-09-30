class LanApiException implements Exception {
  LanApiException(this.message, {this.code = 'lan_error', this.statusCode});

  final String message;
  final String code;
  final int? statusCode;

  @override
  String toString() => message;

  static LanApiException hostOffline([String? detail]) => LanApiException(
        detail == null || detail.isEmpty
            ? 'Shop host offline — check Host PC and Wi‑Fi.'
            : 'Shop host offline — $detail',
        code: 'host_offline',
      );

  static LanApiException fromBody(int status, Map<String, dynamic>? body) {
    final msg = '${body?['error'] ?? 'Request failed ($status)'}';
    final code = '${body?['code'] ?? 'http_$status'}';
    return LanApiException(msg, code: code, statusCode: status);
  }
}
