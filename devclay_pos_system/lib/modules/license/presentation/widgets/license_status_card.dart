import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../bloc/license_bloc.dart';
import '../../domain/entities/license_gate_state.dart';

/// Shows current POS license / trial status for Settings.
class LicenseStatusCard extends StatelessWidget {
  const LicenseStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return BlocBuilder<LicenseBloc, LicenseState>(
      builder: (context, state) {
        final info = _LicenseStatusInfo.fromState(state);

        return Material(
          color: info.tone.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: info.tone.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(info.icon, color: info.tone, size: 22),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'License',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: info.tone.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        info.badge,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: info.tone,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refresh license status',
                      onPressed: () => context
                          .read<LicenseBloc>()
                          .add(const LicenseRetryRequested()),
                      icon: const Icon(Symbols.refresh, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  info.headline,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: info.tone,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (info.detail != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(info.detail!, style: theme.textTheme.bodyMedium),
                ],
                if (info.payload != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _MetaRow(
                    label: 'Business',
                    value: info.payload!.businessName,
                  ),
                  _MetaRow(
                    label: 'Plan',
                    value: info.payload!.licenseType.firestoreValue,
                  ),
                  _MetaRow(
                    label: 'Key',
                    value: _maskKey(info.payload!.licenseKey),
                  ),
                  if (info.payload!.expiryDate != null)
                    _MetaRow(
                      label: 'Expires',
                      value: dateFormat.format(
                        info.payload!.expiryDate!.toLocal(),
                      ),
                    ),
                  if (info.payload!.activationDate != null)
                    _MetaRow(
                      label: 'Activated',
                      value: dateFormat.format(
                        info.payload!.activationDate!.toLocal(),
                      ),
                    ),
                  if (info.offline)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        'Offline — showing last verified status',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static String _maskKey(String key) {
    if (key.isEmpty) return '—';
    if (key.length <= 8) return key;
    return '${key.substring(0, 7)}••••${key.substring(key.length - 4)}';
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LicenseStatusInfo {
  const _LicenseStatusInfo({
    required this.badge,
    required this.headline,
    required this.tone,
    required this.icon,
    this.detail,
    this.payload,
    this.offline = false,
  });

  final String badge;
  final String headline;
  final String? detail;
  final Color tone;
  final IconData icon;
  final LocalLicensePayload? payload;
  final bool offline;

  factory _LicenseStatusInfo.fromState(LicenseState state) {
    if (state is LicenseChecking || state is LicenseInitial) {
      return const _LicenseStatusInfo(
        badge: 'Checking',
        headline: 'Verifying license…',
        tone: Colors.blueGrey,
        icon: Symbols.hourglass_top,
      );
    }

    final snapshot = switch (state) {
      LicenseAllowed(:final snapshot) => snapshot,
      LicenseBlocked(:final snapshot) => snapshot,
      LicenseActivating(:final snapshot) => snapshot,
      LicenseActivationFailure(:final snapshot) => snapshot,
      _ => const LicenseGateSnapshot(mode: LicenseAccessMode.activationRequired),
    };

    final payload = snapshot.payload;
    final status = payload?.status;

    if (snapshot.mode == LicenseAccessMode.maintenance) {
      return _LicenseStatusInfo(
        badge: 'Maintenance',
        headline: 'App is in maintenance mode',
        detail: snapshot.message,
        tone: Colors.deepOrange,
        icon: Symbols.engineering,
        payload: payload,
        offline: snapshot.offline,
      );
    }

    if (status == LicenseStatus.suspended) {
      return _LicenseStatusInfo(
        badge: 'Suspended',
        headline: 'Your license is suspended',
        detail: snapshot.message ??
            'Contact DevClayPOS support to restore access.',
        tone: Colors.red.shade700,
        icon: Symbols.block,
        payload: payload,
        offline: snapshot.offline,
      );
    }

    if (status == LicenseStatus.expired ||
        ((payload?.isExpired ?? false) &&
            snapshot.mode == LicenseAccessMode.blocked)) {
      return _LicenseStatusInfo(
        badge: 'Expired',
        headline: 'Your license has expired',
        detail: snapshot.message ??
            'Renew your license in Admin to continue using DevClayPOS.',
        tone: Colors.red.shade700,
        icon: Symbols.event_busy,
        payload: payload,
        offline: snapshot.offline,
      );
    }

    if (snapshot.mode == LicenseAccessMode.trial ||
        (payload != null &&
            (payload.isTrial || payload.licenseType == LicenseType.trial) &&
            snapshot.allowsAppAccess)) {
      final days = snapshot.trialDaysRemaining ?? payload?.trialDaysRemaining;
      final headline = days == null
          ? 'You are on a trial license'
          : days == 0
              ? 'Your trial ends today'
              : days == 1
                  ? 'Trial ends in 1 day'
                  : 'Trial ends in $days days';
      return _LicenseStatusInfo(
        badge: 'Trial',
        headline: headline,
        detail: 'Activate a paid license anytime for uninterrupted access.',
        tone: Colors.orange.shade800,
        icon: Symbols.timelapse,
        payload: payload,
        offline: snapshot.offline,
      );
    }

    if (snapshot.mode == LicenseAccessMode.licensed ||
        status == LicenseStatus.active) {
      final type = payload?.licenseType;
      final headline = switch (type) {
        LicenseType.lifetime => 'You have an active Lifetime license',
        LicenseType.yearly => 'You have an active Yearly license',
        LicenseType.monthly => 'You have an active Monthly license',
        LicenseType.custom => 'You have an active Custom license',
        _ => 'You have an active license',
      };
      String? detail;
      if (payload?.expiryDate != null && type != LicenseType.lifetime) {
        final remaining =
            payload!.expiryDate!.difference(DateTime.now().toUtc()).inDays;
        detail = remaining < 0
            ? 'License expiry date has passed — renew soon.'
            : remaining <= 7
                ? 'Expires in $remaining days — renew soon.'
                : 'Your license is valid and active.';
      } else {
        detail = 'Your license is valid and active.';
      }
      return _LicenseStatusInfo(
        badge: 'Active',
        headline: headline,
        detail: detail,
        tone: Colors.green.shade700,
        icon: Symbols.verified,
        payload: payload,
        offline: snapshot.offline,
      );
    }

    if (snapshot.mode == LicenseAccessMode.activationRequired ||
        state is LicenseActivationFailure) {
      return _LicenseStatusInfo(
        badge: 'Required',
        headline: 'License key required',
        detail: snapshot.message ??
            (state is LicenseActivationFailure ? state.error : null) ??
            'Enter a valid license key to use DevClayPOS.',
        tone: Colors.blueGrey.shade700,
        icon: Symbols.vpn_key,
        payload: payload,
        offline: snapshot.offline,
      );
    }

    return _LicenseStatusInfo(
      badge: 'Blocked',
      headline: 'License access blocked',
      detail: snapshot.message ?? 'Contact DevClayPOS support.',
      tone: Colors.red.shade700,
      icon: Symbols.lock,
      payload: payload,
      offline: snapshot.offline,
    );
  }
}
