import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

/// Asks before signing out. Returns true if the user confirmed.
Future<bool> confirmSignOut(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Sign out?'),
      content: const Text(
        'You will need to sign in again to use the POS.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Sign out'),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Shows [confirmSignOut] then dispatches logout when confirmed.
Future<void> requestSignOut(BuildContext context) async {
  if (!context.mounted) return;
  final confirmed = await confirmSignOut(context);
  if (!context.mounted || !confirmed) return;
  context.read<AuthBloc>().add(const AuthLogoutRequested());
}
