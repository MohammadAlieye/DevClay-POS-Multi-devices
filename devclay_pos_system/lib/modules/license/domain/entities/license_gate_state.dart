import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:equatable/equatable.dart';

enum LicenseAccessMode {
  checking,
  trial,
  licensed,
  blocked,
  activationRequired,
  maintenance,
}

class OpenLicenseRequest extends Equatable {
  const OpenLicenseRequest({
    required this.id,
    required this.sentAt,
    required this.type,
  });

  final String id;
  final DateTime sentAt;
  final LicenseRequestType type;

  @override
  List<Object?> get props => [id, sentAt, type];
}

class LicenseGateSnapshot extends Equatable {
  const LicenseGateSnapshot({
    required this.mode,
    this.payload,
    this.message,
    this.trialDaysRemaining,
    this.offline = false,
    this.openRequest,
  });

  final LicenseAccessMode mode;
  final LocalLicensePayload? payload;
  final String? message;
  final int? trialDaysRemaining;
  final bool offline;
  final OpenLicenseRequest? openRequest;

  bool get allowsAppAccess =>
      mode == LicenseAccessMode.trial || mode == LicenseAccessMode.licensed;

  LicenseGateSnapshot copyWith({
    LicenseAccessMode? mode,
    LocalLicensePayload? payload,
    String? message,
    int? trialDaysRemaining,
    bool? offline,
    OpenLicenseRequest? openRequest,
    bool clearOpenRequest = false,
  }) {
    return LicenseGateSnapshot(
      mode: mode ?? this.mode,
      payload: payload ?? this.payload,
      message: message ?? this.message,
      trialDaysRemaining: trialDaysRemaining ?? this.trialDaysRemaining,
      offline: offline ?? this.offline,
      openRequest:
          clearOpenRequest ? null : (openRequest ?? this.openRequest),
    );
  }

  @override
  List<Object?> get props =>
      [mode, payload, message, trialDaysRemaining, offline, openRequest];
}
