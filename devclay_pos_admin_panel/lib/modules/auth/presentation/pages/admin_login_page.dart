import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_auth_bloc.dart';
import '../../../../widgets/app_toast.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _email = TextEditingController(text: SuperAdminConfig.email);
  final _password = TextEditingController(text: '12345678');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
              const Color(0xFF0B2E36),
              theme.colorScheme.primary.withValues(alpha: 0.85),
              const Color(0xFFE8F1F2),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: BlocConsumer<AdminAuthBloc, AdminAuthState>(
                  listener: (context, state) {
                    if (state is AdminAuthFailure) {
                      AppToast.show(context, state.message);
                    }
                    if (state is AdminAuthPasswordResetSent) {
                      AppToast.show(context, 'Reset email sent to ${state.email}');
                    }
                  },
                  builder: (context, state) {
                    final loading = state is AdminAuthLoading;
                    return Form(
                      key: _formKey,
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
                          const SizedBox(height: 4),
                          Text(
                            'Admin Panel',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: loading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    context.read<AdminAuthBloc>().add(
                                          AdminAuthLoginRequested(
                                            email: _email.text,
                                            password: _password.text,
                                          ),
                                        );
                                  },
                            child: loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Sign in'),
                          ),
                          TextButton(
                            onPressed: loading
                                ? null
                                : () {
                                    if (_email.text.trim().isEmpty) {
                                      AppToast.error(
                                        context,
                                        'Enter email first',
                                      );
                                      return;
                                    }
                                    context.read<AdminAuthBloc>().add(
                                          AdminAuthPasswordResetRequested(
                                            _email.text,
                                          ),
                                        );
                                  },
                            child: const Text('Forgot password'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
