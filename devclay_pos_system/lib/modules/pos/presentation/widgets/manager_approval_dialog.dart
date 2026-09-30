import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/auth/retail_actor.dart';
import '../../../../core/di/injection.dart';
import '../../../../services/retail/retail_control_service.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';

Future<RetailActor?> requestManagerApproval(
  BuildContext context, {
  required String action,
}) {
  return showDialog<RetailActor>(
    context: context,
    builder: (_) => _ManagerApprovalDialog(action: action),
  );
}

class _ManagerApprovalDialog extends StatefulWidget {
  const _ManagerApprovalDialog({required this.action});

  final String action;

  @override
  State<_ManagerApprovalDialog> createState() => _ManagerApprovalDialogState();
}

class _ManagerApprovalDialogState extends State<_ManagerApprovalDialog> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    setState(() => _loading = true);
    final actor = await sl<RetailControlService>().verifySupervisor(
      username: _username.text,
      password: _password.text,
    );
    if (!mounted) return;
    if (actor == null) {
      setState(() => _loading = false);
      AppToast.show(context, 'Invalid owner or manager credentials.');
      return;
    }
    Navigator.of(context).pop(actor);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Symbols.admin_panel_settings),
      title: const Text('Manager approval'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.action),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _username,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Owner / manager username',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _password,
              obscureText: true,
              onSubmitted: (_) => _approve(),
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Approve',
          icon: Symbols.verified_user,
          isLoading: _loading,
          onPressed: _loading ? null : _approve,
        ),
      ],
    );
  }
}
