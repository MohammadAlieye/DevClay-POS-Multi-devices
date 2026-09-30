import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../constants/app_constants.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_logo.dart';
import '../../../../widgets/app_search_field.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) return;
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            username: username,
            password: password,
            rememberMe: _rememberMe,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF0B1220), Color(0xFF121A2A), Color(0xFF0F172A)]
                : const [Color(0xFFF8FAFC), Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthAuthenticating;
                  final error = state is AuthFailureState ? state.message : null;

                  return AppCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const AppLogo(size: 48),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.appName,
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  Text(
                                    'Sign in to continue',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppTextField(
                          controller: _usernameController,
                          label: 'Username',
                          hintText: 'Enter username',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('Password', style: theme.textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.xs),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Symbols.visibility
                                    : Symbols.visibility_off,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: isLoading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                            ),
                            Text(
                              'Remember me on this device',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (error != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withValues(alpha: 0.1),
                              borderRadius: AppRadii.xsAll,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Symbols.error,
                                  color: AppColors.danger,
                                  size: 18,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Text(
                                    error,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(
                          label: 'Sign in',
                          icon: Symbols.login,
                          expanded: true,
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _submit,
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
    );
  }
}
