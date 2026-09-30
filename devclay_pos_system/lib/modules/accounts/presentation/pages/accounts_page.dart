import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/account_entities.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/account_sheets.dart';
import '../../../../widgets/app_toast.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AccountsBloc>()..add(const AccountsStarted()),
      child: const _AccountsView(),
    );
  }
}

class _AccountsView extends StatelessWidget {
  const _AccountsView();

  Future<void> _openAccountEditor(
    BuildContext context, {
    AccountItem? existing,
  }) async {
    final draft = await showAccountEditorSheet(
      context: context,
      existing: existing,
    );
    if (draft == null || !context.mounted) return;
    context.read<AccountsBloc>().add(
      AccountSaved(draft: draft, id: existing?.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountsBloc, AccountsState>(
      listenWhen: (prev, curr) =>
          curr is AccountsLoaded && curr.message != null,
      listener: (context, state) {
        if (state is AccountsLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<AccountsBloc>().add(const AccountsMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          AccountsInitial() ||
          AccountsLoading() => const Center(child: CircularProgressIndicator()),
          AccountsError(:final message) => EmptyState(
            title: 'Accounts unavailable',
            message: message,
            icon: Symbols.account_balance,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<AccountsBloc>().add(const AccountsStarted()),
            ),
          ),
          AccountsLoaded() => _AccountsLoadedView(
            state: state,
            onAddAccount: () => _openAccountEditor(context),
            onEditAccount: (account) =>
                _openAccountEditor(context, existing: account),
          ),
        };
      },
    );
  }
}

class _AccountsLoadedView extends StatelessWidget {
  const _AccountsLoadedView({
    required this.state,
    required this.onAddAccount,
    required this.onEditAccount,
  });

  final AccountsLoaded state;
  final VoidCallback onAddAccount;
  final ValueChanged<AccountItem> onEditAccount;

  String get _periodLabel => switch (state.period) {
    AccountsPeriod.all => 'All time',
    AccountsPeriod.today => 'Today',
    AccountsPeriod.week => 'This week',
    AccountsPeriod.month => 'This month',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppSearchField(
                  width: double.infinity,
                  hintText: _searchHint(state.viewTab),
                  onChanged: (value) => context.read<AccountsBloc>().add(
                    AccountsSearchChanged(value),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Add account',
                icon: Symbols.account_balance,
                onPressed: onAddAccount,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: 'Total balance',
                value: CurrencyFormatter.format(state.overview.totalBalance),
                icon: Symbols.account_balance_wallet,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Active accounts',
                value: '${state.accounts.where((a) => a.isActive).length}',
                icon: Symbols.account_balance,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: AccountsPeriod.values.map((period) {
              return FilterChip(
                label: Text(_periodChipLabel(period)),
                selected: state.period == period,
                onSelected: (_) => context.read<AccountsBloc>().add(
                  AccountsPeriodChanged(period),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<AccountsViewTab>(
              segments: const [
                ButtonSegment(
                  value: AccountsViewTab.overview,
                  label: Text('Overview'),
                  icon: Icon(Symbols.dashboard, size: 18),
                ),
                ButtonSegment(
                  value: AccountsViewTab.transactions,
                  label: Text('History'),
                  icon: Icon(Symbols.receipt_long, size: 18),
                ),
                ButtonSegment(
                  value: AccountsViewTab.accounts,
                  label: Text('Wallets'),
                  icon: Icon(Symbols.account_balance, size: 18),
                ),
              ],
              selected: {state.viewTab},
              onSelectionChanged: (value) {
                context.read<AccountsBloc>().add(
                  AccountsViewTabChanged(value.first),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: switch (state.viewTab) {
              AccountsViewTab.overview => _OverviewTab(
                state: state,
                periodLabel: _periodLabel,
              ),
              AccountsViewTab.transactions => _TransactionsTab(
                entries: state.entries,
                ledgerFilter: state.ledgerFilter,
                periodLabel: _periodLabel,
              ),
              AccountsViewTab.accounts => _AccountsTab(
                accounts: state.visibleAccounts,
                onEdit: onEditAccount,
              ),
            },
          ),
        ],
      ),
    );
  }

  String _searchHint(AccountsViewTab tab) {
    return switch (tab) {
      AccountsViewTab.overview => 'Search…',
      AccountsViewTab.transactions => 'Search category, account, reference…',
      AccountsViewTab.accounts => 'Search account name…',
    };
  }

  String _periodChipLabel(AccountsPeriod period) {
    return switch (period) {
      AccountsPeriod.all => 'All time',
      AccountsPeriod.today => 'Today',
      AccountsPeriod.week => 'This week',
      AccountsPeriod.month => 'This month',
    };
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.state, required this.periodLabel});

  final AccountsLoaded state;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    final overview = state.overview;

    return ListView(
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet overview',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              _MetricRow(
                label: 'Total balance',
                value: CurrencyFormatter.format(overview.totalBalance),
              ),
              _MetricRow(
                label: '$periodLabel POS sales',
                value: CurrencyFormatter.format(overview.posSalesTotal),
              ),
              _MetricRow(
                label: '$periodLabel purchase payments',
                value: CurrencyFormatter.format(overview.purchasePaymentsTotal),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Cash In, Cash Out, withdrawals, payables, receivables and '
                'employee salaries are managed in Finance.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Account balances', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        ...state.accounts.map(
          (account) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(_accountIcon(account.type), size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          _typeLabel(account.type),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(account.balance),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _accountIcon(String type) {
    return switch (type) {
      'bank' => Symbols.account_balance,
      'mobile' => Symbols.smartphone,
      _ => Symbols.payments,
    };
  }

  String _typeLabel(String type) {
    return switch (type) {
      'bank' => 'Bank account',
      'mobile' => 'Mobile wallet',
      _ => 'Cash',
    };
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab({
    required this.entries,
    required this.ledgerFilter,
    required this.periodLabel,
  });

  final List<LedgerEntryItem> entries;
  final LedgerType? ledgerFilter;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: ledgerFilter == null,
              onSelected: (_) => context.read<AccountsBloc>().add(
                const AccountsLedgerFilterChanged(null),
              ),
            ),
            FilterChip(
              label: const Text('Income'),
              selected: ledgerFilter == LedgerType.income,
              onSelected: (_) => context.read<AccountsBloc>().add(
                const AccountsLedgerFilterChanged(LedgerType.income),
              ),
            ),
            FilterChip(
              label: const Text('Expense'),
              selected: ledgerFilter == LedgerType.expense,
              onSelected: (_) => context.read<AccountsBloc>().add(
                const AccountsLedgerFilterChanged(LedgerType.expense),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: entries.isEmpty
              ? EmptyState(
                  title: 'No transactions',
                  message:
                      'Finance payments and wallet movements for $periodLabel '
                      'will show here.',
                  icon: Symbols.receipt_long,
                )
              : ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final isIncome = entry.ledgerType == LedgerType.income;
                    final formatter = DateFormat('dd MMM yyyy · HH:mm');

                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(
                            isIncome
                                ? Symbols.arrow_downward
                                : Symbols.arrow_upward,
                            color: isIncome
                                ? AppColors.success
                                : AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.category,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  '${entry.accountName} · ${formatter.format(entry.entryDate)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                if (entry.note != null)
                                  Text(
                                    entry.note!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(entry.amount)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isIncome
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _AccountsTab extends StatelessWidget {
  const _AccountsTab({required this.accounts, required this.onEdit});

  final List<AccountItem> accounts;
  final ValueChanged<AccountItem> onEdit;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const EmptyState(
        title: 'No accounts yet',
        message: 'Add cash, bank, or mobile wallet accounts to track balances.',
        icon: Symbols.account_balance,
      );
    }

    return ListView.separated(
      itemCount: accounts.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final account = accounts[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          account.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (account.isDefault) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const Chip(
                            label: Text('Default'),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                        if (!account.isActive) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const Chip(
                            label: Text('Inactive'),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      account.type,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(account.balance),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              IconButton(
                tooltip: 'Edit account',
                icon: const Icon(Symbols.edit, size: 18),
                onPressed: () => onEdit(account),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelMedium),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
