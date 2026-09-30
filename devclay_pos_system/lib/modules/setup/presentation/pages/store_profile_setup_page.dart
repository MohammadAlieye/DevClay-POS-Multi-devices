import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/store_profile/store_profile_service.dart';
import '../../../../core/store_profile/store_profiles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// First-run wizard: pick Pharmacy / Clothing / Milk / Super / General retail.
class StoreProfileSetupPage extends StatefulWidget {
  const StoreProfileSetupPage({super.key});

  @override
  State<StoreProfileSetupPage> createState() => _StoreProfileSetupPageState();
}

class _StoreProfileSetupPageState extends State<StoreProfileSetupPage> {
  StoreProfileId? _selected;
  bool _saving = false;
  String? _error;

  Future<void> _continue() async {
    final profile = _selected;
    if (profile == null) {
      setState(() => _error = 'Select a store type to continue.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await sl<StoreProfileService>().applyProfile(
        profile,
        resetCatalogDefaults: true,
        markConfigured: true,
      );
      if (!mounted) return;
      final auth = context.read<AuthBloc>().state;
      final home = auth.sessionOrNull != null
          ? _homeFor(auth.sessionOrNull!.user.role)
          : AppRoutes.dashboard;
      context.go(home);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  String _homeFor(String role) {
    if (role == AppRoles.cashier) return AppRoutes.pos;
    return AppRoutes.dashboard;
  }

  IconData _iconFor(StoreProfileId id) => switch (id) {
        StoreProfileId.pharmacy => Symbols.medication,
        StoreProfileId.clothing => Symbols.checkroom,
        StoreProfileId.milk => Symbols.water_full,
        StoreProfileId.superStore => Symbols.storefront,
        StoreProfileId.generalRetail => Symbols.shopping_bag,
        StoreProfileId.restaurant => Symbols.restaurant,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profiles = StoreProfiles.allIds;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'What kind of store is this?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'We will set categories, units, and features for your business. '
                    'You can change this later in Settings.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        childAspectRatio: 2.4,
                      ),
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final id = profiles[index];
                        final def = StoreProfiles.of(id);
                        final selected = _selected == id;
                        return Material(
                          color: selected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                            onTap: _saving
                                ? null
                                : () => setState(() {
                                      _selected = id;
                                      _error = null;
                                    }),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                children: [
                                  Icon(
                                    _iconFor(id),
                                    size: 36,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          def.id.displayName,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          def.id.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    Icon(
                                      Symbols.check_circle,
                                      color: theme.colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton(
                      label: _saving ? 'Saving…' : 'Continue',
                      onPressed: _saving ? null : _continue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
