import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constants/developer_contact.dart';
import '../../../../core/di/injection.dart';
import '../../../../widgets/app_toast.dart';
import '../../domain/entities/license_gate_state.dart';
import '../../domain/repositories/license_repository.dart';
import '../bloc/license_bloc.dart';

class LicenseGatePage extends StatefulWidget {
  const LicenseGatePage({super.key});

  @override
  State<LicenseGatePage> createState() => _LicenseGatePageState();
}

class _LicenseGatePageState extends State<LicenseGatePage> {
  final _keyController = TextEditingController();
  String? _prefilledKey;
  OpenLicenseRequest? _openRequest;

  @override
  void initState() {
    super.initState();
    _loadOpenRequest();
  }

  Future<void> _loadOpenRequest() async {
    final open = await sl<LicenseRepository>().getOpenLicenseRequest();
    if (!mounted) return;
    setState(() => _openRequest = open);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _prefillLicenseKey(String? key) {
    if (key == null || key.isEmpty || key == _prefilledKey) return;
    _prefilledKey = key;
    _keyController.text = key;
  }

  Future<void> _copy(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    AppToast.success(context, '$label copied');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: BlocBuilder<LicenseBloc, LicenseState>(
                builder: (context, state) {
                  if (state is LicenseChecking || state is LicenseInitial) {
                    return const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Verifying license…'),
                      ],
                    );
                  }

                  final snapshot = switch (state) {
                    LicenseBlocked(:final snapshot) => snapshot,
                    LicenseActivating(:final snapshot) => snapshot,
                    LicenseActivationFailure(:final snapshot) => snapshot,
                    LicenseAllowed(:final snapshot) => snapshot,
                    _ => const LicenseGateSnapshot(
                        mode: LicenseAccessMode.activationRequired,
                      ),
                  };

                  _prefillLicenseKey(snapshot.payload?.licenseKey);

                  final error = state is LicenseActivationFailure
                      ? state.error
                      : snapshot.message;
                  final activating = state is LicenseActivating;
                  final showSupportReference =
                      snapshot.mode != LicenseAccessMode.maintenance;

                  return Card(
                    elevation: 0,
                    color: theme.colorScheme.surface.withValues(alpha: 0.92),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'DevClayPOS',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.mode == LicenseAccessMode.maintenance
                                ? 'Maintenance'
                                : 'Activate your license',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A license key is required for Trial and paid plans.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (error != null && error.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _LicenseStatusMessageBox(
                              message: error,
                              snapshot: snapshot,
                            ),
                          ],
                          if (showSupportReference) ...[
                            const SizedBox(height: 12),
                            _CollapsibleSection(
                              icon: Icons.support_agent,
                              title: 'Support reference',
                              subtitle: 'Tap to view IDs for renewal',
                              child: _LicenseSupportReferenceBody(
                                payload: snapshot.payload,
                                onCopy: _copy,
                              ),
                            ),
                          ],
                          if (snapshot.mode !=
                              LicenseAccessMode.maintenance) ...[
                            const SizedBox(height: 20),
                            TextField(
                              controller: _keyController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: const InputDecoration(
                                labelText: 'License key',
                                hintText: 'DCP-XXXX-XXXX-XXXX',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: activating
                                  ? null
                                  : (value) => context.read<LicenseBloc>().add(
                                        LicenseActivateRequested(value),
                                      ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: activating
                                  ? null
                                  : () => context.read<LicenseBloc>().add(
                                        LicenseActivateRequested(
                                          _keyController.text,
                                        ),
                                      ),
                              child: activating
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Activate license'),
                            ),
                          ],
                          const SizedBox(height: 12),
                          _LicenseRequestAction(
                            openRequest:
                                snapshot.openRequest ?? _openRequest,
                            enabled: !activating,
                            onRequest: () => _showRenewRequestDialog(
                              context,
                              snapshot,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: activating
                                ? null
                                : () => context
                                    .read<LicenseBloc>()
                                    .add(const LicenseRetryRequested()),
                            child: const Text('Retry verification'),
                          ),
                          const SizedBox(height: 12),
                          _CollapsibleSection(
                            icon: Icons.contact_mail_outlined,
                            title: 'Contact us',
                            subtitle: 'Email · Mobile & WhatsApp',
                            child: Column(
                              children: [
                                _ContactRow(
                                  icon: Icons.mail_outline,
                                  label: 'Email',
                                  value: DeveloperContact.email,
                                  onCopy: () =>
                                      _copy(DeveloperContact.email, 'Email'),
                                ),
                                _ContactRow(
                                  icon: Icons.phone_outlined,
                                  label: 'Mobile & WhatsApp',
                                  value: DeveloperContact.mobile,
                                  onCopy: () =>
                                      _copy(DeveloperContact.mobile, 'Number'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showRenewRequestDialog(
    BuildContext context,
    LicenseGateSnapshot snapshot,
  ) async {
    if ((_openRequest ?? snapshot.openRequest) != null) {
      AppToast.show(
        context,
        'Your request is already sent. Please wait.',
      );
      return;
    }

    final phone = TextEditingController();
    final email = TextEditingController();
    final message = TextEditingController(
      text: snapshot.payload?.status == LicenseStatus.expired
          ? 'Please renew my license.'
          : 'Please help with my license.',
    );
    var submitting = false;

    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Request renewal / license'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'This sends your business details and license info to DevClayPOS Admin.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      if ((snapshot.payload?.businessName ?? '').isNotEmpty)
                        Text('Business: ${snapshot.payload!.businessName}'),
                      if ((snapshot.payload?.licenseKey ?? '').isNotEmpty)
                        Text('Key: ${snapshot.payload!.licenseKey}'),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Your phone / WhatsApp',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Your email (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: message,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      submitting ? null : () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: submitting
                      ? null
                      : () async {
                          if (phone.text.trim().isEmpty) {
                            AppToast.error(
                              context,
                              'Enter your phone / WhatsApp',
                            );
                            return;
                          }
                          setLocal(() => submitting = true);
                          try {
                            final isExpired = snapshot.payload?.status ==
                                    LicenseStatus.expired ||
                                (snapshot.message ?? '')
                                    .toLowerCase()
                                    .contains('expired');
                            await sl<LicenseRepository>().submitLicenseRequest(
                              type: isExpired
                                  ? LicenseRequestType.renew
                                  : LicenseRequestType.support,
                              contactPhone: phone.text.trim(),
                              contactEmail: email.text.trim().isEmpty
                                  ? null
                                  : email.text.trim(),
                              message: message.text.trim(),
                            );
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext, true);
                            }
                          } catch (e) {
                            setLocal(() => submitting = false);
                            if (context.mounted) {
                              AppToast.error(context, 'Failed to send: $e');
                            }
                          }
                        },
                  child: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send request'),
                ),
              ],
            );
          },
        );
      },
    );

    phone.dispose();
    email.dispose();
    message.dispose();

    if (sent == true && mounted) {
      await _loadOpenRequest();
      if (!mounted) return;
      AppToast.success(
        this.context,
        'Request sent. Please wait while we process it.',
      );
    }
  }
}

class _LicenseRequestAction extends StatelessWidget {
  const _LicenseRequestAction({
    required this.openRequest,
    required this.enabled,
    required this.onRequest,
  });

  final OpenLicenseRequest? openRequest;
  final bool enabled;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final pending = openRequest;
    if (pending != null) {
      final date = DateFormat('MMM d, yyyy · h:mm a').format(
        pending.sentAt.toLocal(),
      );
      final theme = Theme.of(context);
      final color = Colors.orange.shade800;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Icon(Icons.hourglass_top, color: color),
            const SizedBox(height: 8),
            Text(
              'Your request is sent',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sent on $date.\nPlease wait — we will update your license soon.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                height: 1.35,
              ),
            ),
          ],
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: enabled ? onRequest : null,
      icon: const Icon(Icons.send_outlined),
      label: const Text('Request renewal / license'),
    );
  }
}

class _LicenseStatusMessageBox extends StatelessWidget {
  const _LicenseStatusMessageBox({
    required this.message,
    required this.snapshot,
  });

  final String message;
  final LicenseGateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final payload = snapshot.payload;

    final isExpired = payload?.status == LicenseStatus.expired ||
        message.toLowerCase().contains('expired');
    final isSuspended = payload?.status == LicenseStatus.suspended ||
        message.toLowerCase().contains('suspended');
    final isMaintenance =
        snapshot.mode == LicenseAccessMode.maintenance;

    final Color color;
    final IconData icon;
    final String title;

    if (isMaintenance) {
      color = Colors.deepOrange.shade800;
      icon = Icons.engineering;
      title = 'Under maintenance';
    } else if (isExpired) {
      color = Colors.red.shade700;
      icon = Icons.event_busy;
      title = 'License expired';
    } else if (isSuspended) {
      color = Colors.red.shade800;
      icon = Icons.block;
      title = 'License suspended';
    } else {
      color = theme.colorScheme.error;
      icon = Icons.error_outline;
      title = 'Action required';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  const _CollapsibleSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _expanded ? 'Tap to collapse' : widget.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

class _LicenseSupportReferenceBody extends StatefulWidget {
  const _LicenseSupportReferenceBody({
    required this.payload,
    required this.onCopy,
  });

  final LocalLicensePayload? payload;
  final Future<void> Function(String value, String label) onCopy;

  @override
  State<_LicenseSupportReferenceBody> createState() =>
      _LicenseSupportReferenceBodyState();
}

class _LicenseSupportReferenceBodyState
    extends State<_LicenseSupportReferenceBody> {
  late Future<String> _machineIdFuture;

  @override
  void initState() {
    super.initState();
    _machineIdFuture = sl<LicenseRepository>().getMachineId();
  }

  String _supportText({
    required String machineId,
    required LocalLicensePayload? payload,
  }) {
    final lines = <String>[
      'DevClayPOS support reference',
      if (payload != null && payload.businessName.isNotEmpty)
        'Business: ${payload.businessName}',
      if (payload?.ownerName != null && payload!.ownerName!.isNotEmpty)
        'Owner: ${payload.ownerName}',
      if (payload?.customerId != null && payload!.customerId!.isNotEmpty)
        'Customer ID: ${payload.customerId}',
      if (payload != null && payload.licenseKey.isNotEmpty)
        'License key: ${payload.licenseKey}',
      'Device ID: $machineId',
    ];
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final payload = widget.payload;

    return FutureBuilder<String>(
      future: _machineIdFuture,
      builder: (context, snap) {
        final machineId = snap.data ?? '…';
        final supportText = _supportText(
          machineId: machineId,
          payload: payload,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: snap.hasData
                    ? () => widget.onCopy(supportText, 'Support info')
                    : null,
                icon: const Icon(Icons.copy_all, size: 18),
                label: const Text('Copy all'),
              ),
            ),
            if (payload != null && payload.businessName.isNotEmpty)
              _SupportRow(
                label: 'Business',
                value: payload.businessName,
                onCopy: () =>
                    widget.onCopy(payload.businessName, 'Business name'),
              ),
            if (payload?.ownerName != null && payload!.ownerName!.isNotEmpty)
              _SupportRow(
                label: 'Owner',
                value: payload.ownerName!,
                onCopy: () => widget.onCopy(payload.ownerName!, 'Owner name'),
              ),
            if (payload?.customerId != null &&
                payload!.customerId!.isNotEmpty)
              _SupportRow(
                label: 'Customer ID',
                value: payload.customerId!,
                onCopy: () => widget.onCopy(payload.customerId!, 'Customer ID'),
              ),
            if (payload != null && payload.licenseKey.isNotEmpty)
              _SupportRow(
                label: 'License key',
                value: payload.licenseKey,
                onCopy: () => widget.onCopy(payload.licenseKey, 'License key'),
              ),
            _SupportRow(
              label: 'Device ID',
              value: machineId,
              onCopy: snap.hasData
                  ? () => widget.onCopy(machineId, 'Device ID')
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class _SupportRow extends StatelessWidget {
  const _SupportRow({
    required this.label,
    required this.value,
    this.onCopy,
  });

  final String label;
  final String value;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: label == 'License key' || label == 'Device ID'
                    ? 'monospace'
                    : null,
              ),
            ),
          ),
          if (onCopy != null)
            IconButton(
              tooltip: 'Copy $label',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.copy, size: 16),
              onPressed: onCopy,
            ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20),
      title: Text(label, style: theme.textTheme.labelMedium),
      subtitle: Text(value, style: theme.textTheme.bodyMedium),
      trailing: IconButton(
        tooltip: 'Copy',
        icon: const Icon(Icons.copy, size: 18),
        onPressed: onCopy,
      ),
    );
  }
}
