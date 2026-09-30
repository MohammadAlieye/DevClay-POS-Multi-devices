part of 'license_bloc.dart';

sealed class LicenseState extends Equatable {
  const LicenseState();

  @override
  List<Object?> get props => [];
}

final class LicenseInitial extends LicenseState {
  const LicenseInitial();
}

final class LicenseChecking extends LicenseState {
  const LicenseChecking();
}

final class LicenseAllowed extends LicenseState {
  const LicenseAllowed(this.snapshot);

  final LicenseGateSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}

final class LicenseBlocked extends LicenseState {
  const LicenseBlocked(this.snapshot);

  final LicenseGateSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}

final class LicenseActivating extends LicenseState {
  const LicenseActivating(this.snapshot);

  final LicenseGateSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}

final class LicenseActivationFailure extends LicenseState {
  const LicenseActivationFailure(this.snapshot, this.error);

  final LicenseGateSnapshot snapshot;
  final String error;

  @override
  List<Object?> get props => [snapshot, error];
}
