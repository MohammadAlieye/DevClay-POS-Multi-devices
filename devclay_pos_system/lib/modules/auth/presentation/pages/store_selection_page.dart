import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../domain/entities/auth_entities.dart';
import '../widgets/sign_out_dialog.dart';
import '../bloc/auth_bloc.dart';

class StoreSelectionPage extends StatelessWidget {
  const StoreSelectionPage({super.key});

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
                ? const [Color(0xFF0B1220), Color(0xFF121A2A)]
                : const [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final session = state.sessionOrNull;
                    final stores = state is AuthNeedsStore
                        ? state.stores
                        : const <StoreInfo>[];
                    final error =
                        state is AuthNeedsStore ? state.errorMessage : null;
                    final selecting = state is AuthSelectingStore;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select store',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    session == null
                                        ? 'Choose where you are working today.'
                                        : 'Welcome, ${session.user.displayName}. Choose your branch.',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            AppButton(
                              label: 'Sign out',
                              variant: AppButtonVariant.ghost,
                              icon: Symbols.logout,
                              onPressed: () => requestSignOut(context),
                            ),
                          ],
                        ),
                        if (error != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            error,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        Expanded(
                          child: selecting
                              ? const Center(child: CircularProgressIndicator())
                              : GridView.builder(
                                  itemCount: stores.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 320,
                                    mainAxisSpacing: AppSpacing.md,
                                    crossAxisSpacing: AppSpacing.md,
                                    childAspectRatio: 1.15,
                                  ),
                                  itemBuilder: (context, index) {
                                    final store = stores[index];
                                    return _StoreTile(
                                      store: store,
                                      onTap: () {
                                        context.read<AuthBloc>().add(
                                              AuthStoreSelected(store.id),
                                            );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
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

class _StoreTile extends StatelessWidget {
  const _StoreTile({required this.store, required this.onTap});

  final StoreInfo store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: AppRadii.smAll,
            ),
            child: Icon(Symbols.store, color: AppColors.accent),
          ),
          const Spacer(),
          Text(
            store.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${store.city} · ${store.code}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            store.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
