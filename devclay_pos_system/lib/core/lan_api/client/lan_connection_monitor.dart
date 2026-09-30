import 'package:flutter/foundation.dart';

import '../lan_api_errors.dart';
import 'lan_api_client.dart';
import '../lan_mode_service.dart';

/// Tracks host reachability for client mode (shell chip / POS gate).
class LanConnectionMonitor extends ChangeNotifier {
  LanConnectionMonitor(this._lanMode, this._client);

  final LanModeService _lanMode;
  final LanApiClient _client;

  bool _online = false;
  String? _status;
  DateTime? _lastChecked;

  bool get online => _online;
  String? get status => _status;
  DateTime? get lastChecked => _lastChecked;

  Future<bool> refresh() async {
    if (!_lanMode.isClient) {
      _online = true;
      _status = _lanMode.isHost ? 'Host mode' : 'Solo mode';
      _lastChecked = DateTime.now();
      notifyListeners();
      return true;
    }
    try {
      final health = await _client.health();
      _online = health.ok;
      _status = health.ok
          ? 'Connected · ${health.businessName}'
          : 'Host unreachable';
    } on LanApiException catch (e) {
      _online = false;
      _status = e.message;
    } catch (e) {
      _online = false;
      _status = 'Host unreachable';
    }
    _lastChecked = DateTime.now();
    notifyListeners();
    return _online;
  }
}
