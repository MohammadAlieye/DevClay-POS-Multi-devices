import 'dart:convert';

import 'package:http/http.dart' as http;

/// Minimal Firestore REST client for hosts where the native C++ SDK is unsafe
/// (Windows ARM). Public-rule POS operations work with the web API key.
class FirestoreRestClient {
  FirestoreRestClient({
    required this.projectId,
    required this.apiKey,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String projectId;
  final String apiKey;
  final http.Client _http;

  static const _timeout = Duration(seconds: 12);

  String get _base =>
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  Uri _uri(String path, {Map<String, String>? query}) {
    final q = <String, String>{'key': apiKey, ...?query};
    return Uri.parse('$_base/$path').replace(queryParameters: q);
  }

  Future<Map<String, dynamic>?> getDocument(String path) async {
    final res = await _http.get(_uri(path)).timeout(_timeout);
    if (res.statusCode == 404) return null;
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw StateError(
        'Firestore REST get failed (${res.statusCode}): ${res.body}',
      );
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return _decodeFields(body['fields'] as Map<String, dynamic>?);
  }

  Future<void> patchDocument(
    String path,
    Map<String, dynamic> data, {
    List<String>? fieldPaths,
  }) async {
    final paths = fieldPaths ?? data.keys.toList();
    final uri = Uri.parse('$_base/$path').replace(
      queryParameters: <String, dynamic>{
        'key': apiKey,
        'updateMask.fieldPaths': paths,
      },
    );

    final res = await _http
        .patch(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'fields': _encodeFields(data)}),
        )
        .timeout(_timeout);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw StateError(
        'Firestore REST patch failed (${res.statusCode}): ${res.body}',
      );
    }
  }

  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data, {
    String? documentId,
  }) async {
    final query = <String, String>{
      if (documentId != null && documentId.isNotEmpty) 'documentId': documentId,
    };
    final res = await _http
        .post(
          _uri(collection, query: query),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'fields': _encodeFields(data)}),
        )
        .timeout(_timeout);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw StateError(
        'Firestore REST create failed (${res.statusCode}): ${res.body}',
      );
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final name = body['name'] as String? ?? '';
    final slash = name.lastIndexOf('/');
    return slash >= 0 ? name.substring(slash + 1) : name;
  }

  Map<String, dynamic> _encodeFields(Map<String, dynamic> data) {
    final out = <String, dynamic>{};
    data.forEach((key, value) {
      if (value == null) return;
      out[key] = _encodeValue(value);
    });
    return out;
  }

  Map<String, dynamic> _encodeValue(Object value) {
    if (value is String) return {'stringValue': value};
    if (value is bool) return {'booleanValue': value};
    if (value is int) return {'integerValue': '$value'};
    if (value is double) return {'doubleValue': value};
    if (value is Map<String, dynamic>) {
      return {'mapValue': {'fields': _encodeFields(value)}};
    }
    if (value is List) {
      return {
        'arrayValue': {
          'values': value.map((e) => _encodeValue(e as Object)).toList(),
        },
      };
    }
    return {'stringValue': value.toString()};
  }

  Map<String, dynamic>? _decodeFields(Map<String, dynamic>? fields) {
    if (fields == null) return null;
    final out = <String, dynamic>{};
    fields.forEach((key, raw) {
      out[key] = _decodeValue(raw as Map<String, dynamic>);
    });
    return out;
  }

  dynamic _decodeValue(Map<String, dynamic> value) {
    if (value.containsKey('nullValue')) return null;
    if (value.containsKey('stringValue')) return value['stringValue'];
    if (value.containsKey('booleanValue')) return value['booleanValue'] as bool;
    if (value.containsKey('integerValue')) {
      return int.tryParse('${value['integerValue']}') ?? 0;
    }
    if (value.containsKey('doubleValue')) {
      return (value['doubleValue'] as num).toDouble();
    }
    if (value.containsKey('timestampValue')) {
      return value['timestampValue'];
    }
    if (value.containsKey('mapValue')) {
      final map = value['mapValue'] as Map<String, dynamic>;
      return _decodeFields(map['fields'] as Map<String, dynamic>?) ??
          <String, dynamic>{};
    }
    if (value.containsKey('arrayValue')) {
      final arr = value['arrayValue'] as Map<String, dynamic>;
      final values = arr['values'] as List<dynamic>? ?? const [];
      return values
          .map((e) => _decodeValue(e as Map<String, dynamic>))
          .toList();
    }
    return null;
  }
}
