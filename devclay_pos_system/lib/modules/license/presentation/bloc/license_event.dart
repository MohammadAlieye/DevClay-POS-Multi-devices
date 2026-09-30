part of 'license_bloc.dart';

sealed class LicenseEvent extends Equatable {
  const LicenseEvent();

  @override
  List<Object?> get props => [];
}

final class LicenseStarted extends LicenseEvent {
  const LicenseStarted();
}

final class LicenseActivateRequested extends LicenseEvent {
  const LicenseActivateRequested(this.licenseKey);

  final String licenseKey;

  @override
  List<Object?> get props => [licenseKey];
}

final class LicenseRetryRequested extends LicenseEvent {
  const LicenseRetryRequested();
}
