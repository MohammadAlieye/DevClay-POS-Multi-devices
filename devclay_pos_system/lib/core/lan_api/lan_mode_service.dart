import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LanDeviceMode {
  solo,
  host,
  client;

  static LanDeviceMode fromStorage(String? raw) {
    return switch ((raw ?? '').trim().toLowerCase()) {
      'host' => LanDeviceMode.host,
      'client' => LanDeviceMode.client,
      _ => LanDeviceMode.solo,
    };
  }

  String get storageKey => name;

  String get displayLabel => switch (this) {
        LanDeviceMode.solo => 'Solo',
        LanDeviceMode.host => 'Shop Host',
        LanDeviceMode.client => 'Counter (Client)',
      };
}

class LanModeService extends ChangeNotifier {
  static const _modeKey = 'lan_device_mode';
  static const _hostIpKey = 'lan_host_ip';
  static const _hostPortKey = 'lan_host_port';
  static const _bindPortKey = 'lan_bind_port';

  LanDeviceMode _mode = LanDeviceMode.solo;
  String _hostIp = '192.168.1.1';
  int _hostPort = 8080;
  int _bindPort = 8080;
  bool _loaded = false;

  LanDeviceMode get mode => _mode;
  String get hostIp => _hostIp;
  int get hostPort => _hostPort;
  int get bindPort => _bindPort;
  bool get isHost => _mode == LanDeviceMode.host;
  bool get isClient => _mode == LanDeviceMode.client;
  bool get isSolo => _mode == LanDeviceMode.solo;
  bool get loaded => _loaded;

  String get clientBaseUrl => 'http://$_hostIp:$_hostPort';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _mode = LanDeviceMode.fromStorage(prefs.getString(_modeKey));
    _hostIp = prefs.getString(_hostIpKey) ?? _hostIp;
    _hostPort = prefs.getInt(_hostPortKey) ?? _hostPort;
    _bindPort = prefs.getInt(_bindPortKey) ?? _bindPort;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setMode(LanDeviceMode mode) async {
    _mode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.storageKey);
    notifyListeners();
  }

  Future<void> setHostAddress({
    required String ip,
    required int port,
  }) async {
    _hostIp = ip.trim();
    _hostPort = port;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hostIpKey, _hostIp);
    await prefs.setInt(_hostPortKey, _hostPort);
    notifyListeners();
  }

  Future<void> setBindPort(int port) async {
    _bindPort = port;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bindPortKey, port);
    notifyListeners();
  }
}
