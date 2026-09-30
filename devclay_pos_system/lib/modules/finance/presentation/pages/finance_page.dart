import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/finance_entities.dart';
import '../bloc/finance_bloc.dart';
import '../widgets/finance_sheets.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FinanceBloc>()..add(const FinanceStarted()),
      child: const _FinanceView(),
    );
  }
}

class _FinanceView extends StatelessWidget {
  const _FinanceView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinanceBloc, FinanceState>(
      listenWhen: (prev, curr) => curr is FinanceLoaded && curr.message != null,
      listener: (context, state) {
        if (state is FinanceLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<FinanceBloc>().add(const FinanceMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          FinanceInitial() ||
          FinanceLoading() => const Center(child: CircularProgressIndicator()),
          FinanceError(:final message) => EmptyState(
            title: 'Finance unavailable',
            message: message,
            icon: Symbols.account_balance_wallet,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<FinanceBloc>().add(const FinanceStarted()),
            ),
          ),
          FinanceLoaded() => _FinanceLoadedView(state: state),
        };
      },
    );
  }
}

class _FinanceLoadedView extends StatelessWidget {
  const _FinanceLoadedView({required this.state});

  final FinanceLoaded state;

  String get _periodLabel => switch (state.period) {
    FinancePeriod.all => 'All time',
    FinancePeriod.today => 'Today',
    FinancePeriod.week => 'This week',
    FinancePeriod.month => 'This month',
  };

  Future<void> _addMovement(
    BuildContext context,
    FinanceMovementKind kind,
  ) async {
    final draft = await showFinanceMovementSheet(
      context: context,
      kind: kind,
      accounts: state.data.accounts,
    );
    if (draft == null || !context.mounted) return;
    context.read<FinanceBloc>().add(FinanceMovementAdded(draft));
  }

  Future<void> _editEmployee(
    BuildContext context, {
    EmployeeItem? existing,
  }) async {
    final draft = await showEmployeeEditorSheet(
      context: context,
      existing: existing,
    );
    if (draft == null || !context.mounted) return;
    context.read<FinanceBloc>().add(
      FinanceEmployeeSaved(draft: draft, id: existing?.id),
    );
  }

  Future<void> _paySalary(BuildContext context, EmployeeItem employee) async {
    final draft = await showSalaryPaySheet(
      context: context,
      employee: employee,
      accounts: state.data.accounts,
    );
    if (draft == null || !context.mounted) return;
    context.read<FinanceBloc>().add(FinanceSalaryPaid(draft));
  }

  Future<void> _settlePayable(BuildContext context, PayableItem item) async {
    final result = await showSettleSheet(
      context: context,
      title: 'Pay ${item.supplierName}',
      dueAmount: item.dueAmount,
      accounts: state.data.accounts,
      isPayable: true,
    );
    if (result == null || !context.mounted) return;
    context.read<FinanceBloc>().add(
      FinancePayableSettled(
        purchaseId: item.purchaseId,
        accountId: result.accountId,
        amount: result.amount,
      ),
    );
  }

  Future<void> _settleReceivable(
    BuildContext context,
    ReceivableItem item,
  ) async {
    final result = await showSettleSheet(
      context: context,
      title: 'Collect · ${item.customerName}',
      dueAmount: item.balance,
      accounts: state.data.accounts,
      isPayable: false,
    );
    if (result == null || !context.mounted) return;
    context.read<FinanceBloc>().add(
      FinanceReceivableSettled(
        customerId: item.customerId,
        accountId: result.accountId,
        amount: result.amount,
      ),
    );
  }

  Future<void> _addExpense(BuildContext context) async {
    final draft = await showExpenseSheet(
      context: context,
      accounts: state.data.accounts,
    );
    if (draft == null || !context.mounted) return;
    context.read<FinanceBloc>().add(FinanceExpenseAdded(draft));
  }

  Future<void> _addAdvance(
    BuildContext context, {
    EmployeeItem? employee,
  }) async {
    final nextMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    );
    final nextMonthLabel = DateFormat('MMM yyyy').format(nextMonth);
    final draft = await showAdvanceSheet(
      context: context,
      accounts: state.data.accounts,
      employees: state.data.employees,
      preselectedEmployee: employee,
      initialNote: employee != null ? 'Advance for $nextMonthLabel' : null,
    );
    if (draft == null || !context.mounted) return;
    context.read<FinanceBloc>().add(FinanceAdvanceAdded(draft));
  }

  Future<void> _addCommission(BuildContext context) async {
    final draft = await showCommissionSheet(
      context: context,
      accounts: state.data.accounts,
      employees: state.data.employees,
    );
    if (draft == null || !context.mounted) return;
    context.read<FinanceBloc>().add(FinanceCommissionAdded(draft));
  }

  void _checkIn(BuildContext context, EmployeeItem employee) {
    context.read<FinanceBloc>().add(
      FinanceAttendanceClockedIn(
        AttendanceClockInDraft(employeeId: employee.id),
      ),
    );
  }

  void _checkOut(BuildContext context, AttendanceItem item) {
    context.read<FinanceBloc>().add(
      FinanceAttendanceClockedOut(
        AttendanceClockOutDraft(attendanceId: item.id),
      ),
    );
  }

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
                child: Text(
                  'Finance',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.secondary,
                icon: Symbols.refresh,
                onPressed: () => context.read<FinanceBloc>().add(
                  const FinanceRefreshRequested(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: FinancePeriod.values.map((period) {
              return FilterChip(
                label: Text(switch (period) {
                  FinancePeriod.all => 'All time',
                  FinancePeriod.today => 'Today',
                  FinancePeriod.week => 'This week',
                  FinancePeriod.month => 'This month',
                }),
                selected: state.period == period,
                onSelected: (_) => context.read<FinanceBloc>().add(
                  FinancePeriodChanged(period),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<FinanceViewTab>(
              segments: const [
                ButtonSegment(
                  value: FinanceViewTab.overview,
                  label: Text('Overview'),
                  icon: Icon(Symbols.dashboard, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.employees,
                  label: Text('Employees'),
                  icon: Icon(Symbols.badge, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.attendance,
                  label: Text('Attendance'),
                  icon: Icon(Symbols.schedule, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.expenses,
                  label: Text('Expenses'),
                  icon: Icon(Symbols.receipt_long, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.salaryHistory,
                  label: Text('Salary'),
                  icon: Icon(Symbols.payments, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.advances,
                  label: Text('Advances'),
                  icon: Icon(Symbols.savings, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.commission,
                  label: Text('Commission'),
                  icon: Icon(Symbols.percent, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.cashIn,
                  label: Text('Cash In'),
                  icon: Icon(Symbols.south_west, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.cashOut,
                  label: Text('Cash Out'),
                  icon: Icon(Symbols.north_east, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.withdrawals,
                  label: Text('Withdrawals'),
                  icon: Icon(Symbols.account_balance_wallet, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.payables,
                  label: Text('Payables'),
                  icon: Icon(Symbols.local_shipping, size: 18),
                ),
                ButtonSegment(
                  value: FinanceViewTab.receivables,
                  label: Text('Receivables'),
                  icon: Icon(Symbols.group, size: 18),
                ),
              ],
              selected: {state.viewTab},
              onSelectionChanged: (value) {
                context.read<FinanceBloc>().add(
                  FinanceViewTabChanged(value.first),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: switch (state.viewTab) {
              FinanceViewTab.overview => _OverviewTab(
                overview: state.data.overview,
                periodLabel: _periodLabel,
                onOpenTab: (tab) =>
                    context.read<FinanceBloc>().add(FinanceViewTabChanged(tab)),
              ),
              FinanceViewTab.expenses => _ExpensesTab(
                expenses: state.data.expenses,
                total: state.data.overview.expensesTotal,
                periodLabel: _periodLabel,
                onAdd: () => _addExpense(context),
              ),
              FinanceViewTab.salaryHistory => _SalaryTab(
                employees: state.data.employees,
                data: state.data,
                onPay: (e) => _paySalary(context, e),
                onAdvance: (e) => _addAdvance(context, employee: e),
              ),
              FinanceViewTab.advances => _EmployeeMoneyTab(
                title: 'Employee advances',
                subtitle: 'Cash advances given to staff',
                items: state.data.advances
                    .map(
                      (a) => _EmployeeMoneyRow(
                        name: a.employeeName,
                        amount: a.amount,
                        accountName: a.accountName,
                        entryDate: a.entryDate,
                        detail: a.note,
                      ),
                    )
                    .toList(),
                total: state.data.overview.advancesTotal,
                periodLabel: _periodLabel,
                emptyTitle: 'No advances yet',
                emptyMessage:
                    'Record cash advances given to employees before salary.',
                emptyIcon: Symbols.savings,
                onAdd: () => _addAdvance(context),
              ),
              FinanceViewTab.commission => _EmployeeMoneyTab(
                title: 'Employee commission',
                subtitle: 'Commission payments to staff',
                items: state.data.commissions
                    .map(
                      (c) => _EmployeeMoneyRow(
                        name: c.employeeName,
                        amount: c.amount,
                        accountName: c.accountName,
                        entryDate: c.entryDate,
                        detail: [
                          if (c.mode == CommissionPayMode.percent &&
                              c.percentage != null &&
                              c.baseAmount != null)
                            '${c.percentage}% of ${CurrencyFormatter.format(c.baseAmount!)}'
                          else if (c.mode == CommissionPayMode.fixed)
                            'Fixed Rs',
                          if (c.reference != null) c.reference!,
                          if (c.note != null) c.note!,
                        ].join(' · '),
                      ),
                    )
                    .toList(),
                total: state.data.overview.commissionsTotal,
                periodLabel: _periodLabel,
                emptyTitle: 'No commission payments yet',
                emptyMessage: 'Pay sales or performance commission to staff.',
                emptyIcon: Symbols.percent,
                onAdd: () => _addCommission(context),
              ),
              FinanceViewTab.cashIn => _MovementTab(
                title: 'Cash In',
                subtitle: 'Money received into business accounts',
                kind: FinanceMovementKind.cashIn,
                movements: state.movementsFor(FinanceMovementKind.cashIn),
                onAdd: () => _addMovement(context, FinanceMovementKind.cashIn),
              ),
              FinanceViewTab.cashOut => _MovementTab(
                title: 'Cash Out',
                subtitle: 'Business payments leaving the till',
                kind: FinanceMovementKind.cashOut,
                movements: state.movementsFor(FinanceMovementKind.cashOut),
                onAdd: () => _addMovement(context, FinanceMovementKind.cashOut),
              ),
              FinanceViewTab.withdrawals => _MovementTab(
                title: 'Owner Withdrawals',
                subtitle: 'Personal drawings by the owner',
                kind: FinanceMovementKind.ownerWithdrawal,
                movements: state.movementsFor(
                  FinanceMovementKind.ownerWithdrawal,
                ),
                onAdd: () =>
                    _addMovement(context, FinanceMovementKind.ownerWithdrawal),
              ),
              FinanceViewTab.payables => _PayablesTab(
                items: state.data.payables,
                onSettle: (item) => _settlePayable(context, item),
              ),
              FinanceViewTab.receivables => _ReceivablesTab(
                items: state.data.receivables,
                onCollect: (item) => _settleReceivable(context, item),
              ),
              FinanceViewTab.employees => _EmployeesTab(
                employees: state.data.employees,
                data: state.data,
                monthlyPayroll: state.data.overview.monthlyPayroll,
                onAdd: () => _editEmployee(context),
                onEdit: (e) => _editEmployee(context, existing: e),
                onPay: (e) => _paySalary(context, e),
                onAdvance: (e) => _addAdvance(context, employee: e),
                onToggleActive: (e, active) => context.read<FinanceBloc>().add(
                  FinanceEmployeeActiveChanged(id: e.id, isActive: active),
                ),
                onDelete: (e) async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Move to Recycle Bin?'),
                      content: Text(
                        'Move "${e.name}" to the Recycle Bin?\n'
                        'You can restore them later. Past salary payments stay in history.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Move to Recycle Bin'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && context.mounted) {
                    context.read<FinanceBloc>().add(
                      FinanceEmployeeDeleted(e.id),
                    );
                  }
                },
              ),
              FinanceViewTab.attendance => _AttendanceTab(
                employees: state.data.employees,
                attendances: state.data.attendances,
                onCheckIn: (e) => _checkIn(context, e),
                onCheckOut: (item) => _checkOut(context, item),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.overview,
    required this.periodLabel,
    required this.onOpenTab,
  });

  final FinanceOverview overview;
  final String periodLabel;
  final ValueChanged<FinanceViewTab> onOpenTab;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _StatTile(
              label: 'Total balance',
              value: CurrencyFormatter.format(overview.totalBalance),
              icon: Symbols.account_balance_wallet,
              color: AppColors.accent,
            ),
            _StatTile(
              label: '$periodLabel cash in',
              value: CurrencyFormatter.format(overview.cashIn),
              icon: Symbols.south_west,
              color: AppColors.success,
              onTap: () => onOpenTab(FinanceViewTab.cashIn),
            ),
            _StatTile(
              label: '$periodLabel cash out',
              value: CurrencyFormatter.format(overview.cashOut),
              icon: Symbols.north_east,
              color: AppColors.warning,
              onTap: () => onOpenTab(FinanceViewTab.cashOut),
            ),
            _StatTile(
              label: '$periodLabel expenses',
              value: CurrencyFormatter.format(overview.expensesTotal),
              icon: Symbols.receipt_long,
              color: AppColors.warning,
              onTap: () => onOpenTab(FinanceViewTab.expenses),
            ),
            _StatTile(
              label: '$periodLabel withdrawals',
              value: CurrencyFormatter.format(overview.withdrawals),
              icon: Symbols.account_balance,
              onTap: () => onOpenTab(FinanceViewTab.withdrawals),
            ),
            _StatTile(
              label: 'To give',
              value: CurrencyFormatter.format(overview.payablesDue),
              icon: Symbols.local_shipping,
              color: KhataBalanceRules.giveColor,
              onTap: () => onOpenTab(FinanceViewTab.payables),
            ),
            _StatTile(
              label: 'To take',
              value: CurrencyFormatter.format(overview.receivablesDue),
              icon: Symbols.group,
              color: KhataBalanceRules.takeColor,
              onTap: () => onOpenTab(FinanceViewTab.receivables),
            ),
            _StatTile(
              label: 'Active employees',
              value: '${overview.activeEmployees}',
              icon: Symbols.badge,
              onTap: () => onOpenTab(FinanceViewTab.employees),
            ),
            _StatTile(
              label: 'Present today',
              value: '${overview.presentToday}',
              icon: Symbols.schedule,
              color: AppColors.success,
              onTap: () => onOpenTab(FinanceViewTab.attendance),
            ),
            _StatTile(
              label: 'Currently in',
              value: '${overview.currentlyIn}',
              icon: Symbols.timer,
              onTap: () => onOpenTab(FinanceViewTab.attendance),
            ),
            _StatTile(
              label: '$periodLabel hours',
              value: overview.attendanceHoursLabel,
              icon: Symbols.hourglass_top,
              onTap: () => onOpenTab(FinanceViewTab.attendance),
            ),
            _StatTile(
              label: 'Monthly payroll',
              value: CurrencyFormatter.format(overview.monthlyPayroll),
              icon: Symbols.payments,
              onTap: () => onOpenTab(FinanceViewTab.employees),
            ),
            _StatTile(
              label: '$periodLabel salaries paid',
              value: CurrencyFormatter.format(overview.salariesPaid),
              icon: Symbols.paid,
              onTap: () => onOpenTab(FinanceViewTab.salaryHistory),
            ),
            _StatTile(
              label: '$periodLabel advances',
              value: CurrencyFormatter.format(overview.advancesTotal),
              icon: Symbols.savings,
              onTap: () => onOpenTab(FinanceViewTab.advances),
            ),
            _StatTile(
              label: '$periodLabel commission',
              value: CurrencyFormatter.format(overview.commissionsTotal),
              icon: Symbols.percent,
              onTap: () => onOpenTab(FinanceViewTab.commission),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick actions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Record shop expenses with categories and receipts, manage '
                'employee salaries, attendance, advances and commission, and '
                'track cash movements, payables and receivables.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? AppColors.accent;
    return SizedBox(
      width: 220,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: accent),
                const SizedBox(height: 8),
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MovementTab extends StatelessWidget {
  const _MovementTab({
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.movements,
    required this.onAdd,
  });

  final String title;
  final String subtitle;
  final FinanceMovementKind kind;
  final List<FinanceMovement> movements;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM · h:mm a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            AppButton(
              label: 'Add ${kind.label}',
              icon: Symbols.add,
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: movements.isEmpty
              ? EmptyState(
                  title: 'No ${kind.label.toLowerCase()} yet',
                  message: 'Tap Add to record the first entry.',
                  icon: Symbols.receipt_long,
                )
              : ListView.separated(
                  itemCount: movements.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = movements[index];
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.accountName,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  [
                                    dateFormat.format(item.entryDate),
                                    if (item.employeeName != null)
                                      item.employeeName!,
                                    if (item.reference != null) item.reference!,
                                    if (item.note != null) item.note!,
                                  ].join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.amount),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: kind.isExpense
                                      ? AppColors.warning
                                      : AppColors.success,
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

class _PayablesTab extends StatelessWidget {
  const _PayablesTab({required this.items, required this.onSettle});

  final List<PayableItem> items;
  final ValueChanged<PayableItem> onSettle;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        title: 'No payables',
        message: 'Supplier purchases to give will appear here.',
        icon: Symbols.local_shipping,
      );
    }

    final dateFormat = DateFormat('d MMM yyyy');
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.supplierName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${item.invoiceNo} · ${dateFormat.format(item.purchaseDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Total ${CurrencyFormatter.format(item.total)}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    KhataBalanceRules.payableLabel(item.dueAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: KhataBalanceRules.colorForPayable(item.dueAmount),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onSettle(item),
                    child: const Text('Give'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReceivablesTab extends StatelessWidget {
  const _ReceivablesTab({required this.items, required this.onCollect});

  final List<ReceivableItem> items;
  final ValueChanged<ReceivableItem> onCollect;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        title: 'No receivables',
        message: 'Customer credit balances will appear here.',
        icon: Symbols.group,
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.customerName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (item.phone.isNotEmpty)
                      Text(
                        item.phone,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    KhataBalanceRules.amountLabel(item.balance),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: KhataBalanceRules.colorFor(item.balance),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onCollect(item),
                    child: const Text('Take'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmployeesTab extends StatelessWidget {
  const _EmployeesTab({
    required this.employees,
    required this.data,
    required this.monthlyPayroll,
    required this.onAdd,
    required this.onEdit,
    required this.onPay,
    required this.onAdvance,
    required this.onToggleActive,
    required this.onDelete,
  });

  final List<EmployeeItem> employees;
  final FinanceData data;
  final double monthlyPayroll;
  final VoidCallback onAdd;
  final ValueChanged<EmployeeItem> onEdit;
  final ValueChanged<EmployeeItem> onPay;
  final ValueChanged<EmployeeItem> onAdvance;
  final void Function(EmployeeItem employee, bool isActive) onToggleActive;
  final ValueChanged<EmployeeItem> onDelete;

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMM yyyy').format(DateTime.now());
    final dateFormat = DateFormat('d MMM');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Payroll · ${CurrencyFormatter.format(monthlyPayroll)} / month',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            AppButton(
              label: 'Add employee',
              icon: Symbols.person_add,
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: employees.isEmpty
              ? EmptyState(
                  title: 'No employees yet',
                  message:
                      'Add staff here, set monthly salary, then pay from the Salary tab.',
                  icon: Symbols.badge,
                  action: AppButton(
                    label: 'Add employee',
                    icon: Symbols.person_add,
                    onPressed: onAdd,
                  ),
                )
              : ListView.separated(
                  itemCount: employees.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    final payment = employee.isActive
                        ? data.salaryPaymentForMonth(employee.id)
                        : null;
                    final isPaid = payment != null;
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: (isPaid
                                    ? AppColors.success
                                    : AppColors.accent)
                                .withValues(alpha: 0.12),
                            child: Text(
                              employee.name.isNotEmpty
                                  ? employee.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: isPaid
                                    ? AppColors.success
                                    : AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  [
                                    if (employee.designation != null)
                                      employee.designation!,
                                    CurrencyFormatter.format(
                                      employee.monthlySalary,
                                    ),
                                    if (!employee.isActive) 'Inactive',
                                  ].join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                if (employee.isActive && isPaid)
                                  Text(
                                    '$monthLabel paid · '
                                    '${CurrencyFormatter.format(payment.amount)} · '
                                    '${dateFormat.format(payment.entryDate)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                else if (employee.isActive)
                                  Text(
                                    '$monthLabel salary not paid',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (employee.isActive) ...[
                            if (isPaid) ...[
                              Container(
                                margin: const EdgeInsets.only(right: AppSpacing.sm),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'PAID',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              AppButton(
                                label: 'Advance',
                                icon: Symbols.savings,
                                variant: AppButtonVariant.secondary,
                                onPressed: () => onAdvance(employee),
                              ),
                            ] else
                              AppButton(
                                label: 'Pay salary',
                                icon: Symbols.payments,
                                onPressed: () => onPay(employee),
                              ),
                          ],
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () => onEdit(employee),
                            icon: const Icon(Symbols.edit, size: 18),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () => onDelete(employee),
                            icon: const Icon(Symbols.delete_outline, size: 18),
                          ),
                          Switch(
                            value: employee.isActive,
                            onChanged: (v) => onToggleActive(employee, v),
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

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab({
    required this.employees,
    required this.attendances,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  final List<EmployeeItem> employees;
  final List<AttendanceItem> attendances;
  final ValueChanged<EmployeeItem> onCheckIn;
  final ValueChanged<AttendanceItem> onCheckOut;

  List<AttendanceItem> _recordsFor(int employeeId) {
    return attendances
        .where((item) => item.employeeId == employeeId)
        .toList()
      ..sort((a, b) => b.clockInAt.compareTo(a.clockInAt));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');
    final staff = employees.where((e) => e.isActive).toList();
    final inCount = staff.where((employee) {
      return attendances.any(
        (item) => item.isOpen && item.employeeId == employee.id,
      );
    }).length;
    final outCount = staff.length - inCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          staff.isEmpty ? 'Attendance' : '$inCount in · $outCount out',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Check in / Check out for today. History shows every day they came.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: staff.isEmpty
              ? const EmptyState(
                  title: 'No employees yet',
                  message: 'Add staff in the Employees tab first.',
                  icon: Symbols.badge,
                )
              : ListView.separated(
                  itemCount: staff.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final employee = staff[index];
                    final records = _recordsFor(employee.id);
                    final open = records.where((item) => item.isOpen).firstOrNull;
                    final isIn = open != null;
                    final stats = AttendanceStats.from(records);
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: (isIn
                                    ? AppColors.success
                                    : AppColors.textSecondary)
                                .withValues(alpha: 0.14),
                            child: Text(
                              employee.name.isNotEmpty
                                  ? employee.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: isIn
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  open == null
                                      ? 'Not in'
                                      : 'In since ${timeFormat.format(open.clockInAt)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isIn
                                        ? AppColors.success
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  stats.checkIns == 0
                                      ? 'No records yet'
                                      : '${stats.days} days · ${stats.checkIns} check-ins · ${stats.hoursLabel}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: AppSpacing.sm),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (isIn
                                      ? AppColors.success
                                      : AppColors.textSecondary)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              isIn ? 'IN' : 'OUT',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isIn
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => showAttendanceHistorySheet(
                              context: context,
                              employee: employee,
                              records: records,
                            ),
                            child: const Text('History'),
                          ),
                          const SizedBox(width: 4),
                          if (open != null)
                            AppButton(
                              label: 'Check out',
                              icon: Symbols.logout,
                              variant: AppButtonVariant.secondary,
                              onPressed: () => onCheckOut(open),
                            )
                          else
                            AppButton(
                              label: 'Check in',
                              icon: Symbols.login,
                              onPressed: () => onCheckIn(employee),
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

class _ExpensesTab extends StatelessWidget {
  const _ExpensesTab({
    required this.expenses,
    required this.total,
    required this.periodLabel,
    required this.onAdd,
  });

  final List<ExpenseItem> expenses;
  final double total;
  final String periodLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');
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
                    'Shop expenses',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$periodLabel total · ${CurrencyFormatter.format(total)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            AppButton(
              label: 'Add expense',
              icon: Symbols.add,
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: expenses.isEmpty
              ? EmptyState(
                  title: 'No expenses yet',
                  message:
                      'Record electricity, rent, transport, marketing and other shop costs.',
                  icon: Symbols.receipt_long,
                  action: AppButton(
                    label: 'Add expense',
                    icon: Symbols.add,
                    onPressed: onAdd,
                  ),
                )
              : ListView.separated(
                  itemCount: expenses.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = expenses[index];
                    final hasReceipt =
                        item.receiptPath != null &&
                        item.receiptPath!.isNotEmpty &&
                        File(item.receiptPath!).existsSync();
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.category,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  [
                                    dateFormat.format(item.entryDate),
                                    item.accountName,
                                    if (item.paidBy != null) item.paidBy!,
                                    if (item.description != null)
                                      item.description!,
                                  ].join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (hasReceipt)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.sm,
                              ),
                              child: Icon(
                                Symbols.attach_file,
                                size: 18,
                                color: AppColors.accent,
                              ),
                            ),
                          Text(
                            CurrencyFormatter.format(item.amount),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warning,
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

class _SalaryTab extends StatelessWidget {
  const _SalaryTab({
    required this.employees,
    required this.data,
    required this.onPay,
    required this.onAdvance,
  });

  final List<EmployeeItem> employees;
  final FinanceData data;
  final ValueChanged<EmployeeItem> onPay;
  final ValueChanged<EmployeeItem> onAdvance;

  String _commissionLabel(SalaryHistoryItem payment) {
    if (!payment.hasCommission) return '';
    final sales = payment.salesCount;
    if (sales != null && sales > 0) {
      return 'Commission ${CurrencyFormatter.format(payment.commissionAmount)} · $sales sale${sales == 1 ? '' : 's'}';
    }
    return 'Commission ${CurrencyFormatter.format(payment.commissionAmount)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthLabel = DateFormat('MMM yyyy').format(DateTime.now());
    final dateFormat = DateFormat('d MMM');
    final staff = employees.where((e) => e.isActive).toList();
    final paidCount = staff.where((e) {
      return data.salaryPaymentForMonth(e.id) != null;
    }).length;
    final unpaidCount = staff.length - paidCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          staff.isEmpty ? 'Salary' : '$paidCount paid · $unpaidCount pending',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '$monthLabel payroll — pay base salary and optional sales commission.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: staff.isEmpty
              ? const EmptyState(
                  title: 'No employees yet',
                  message: 'Add staff in the Employees tab first.',
                  icon: Symbols.badge,
                )
              : ListView.separated(
                  itemCount: staff.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final employee = staff[index];
                    final payment = data.salaryPaymentForMonth(employee.id);
                    final isPaid = payment != null;
                    final records = data.salaryHistoryForEmployee(employee.id);
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: (isPaid
                                    ? AppColors.success
                                    : AppColors.warning)
                                .withValues(alpha: 0.14),
                            child: Text(
                              employee.name.isNotEmpty
                                  ? employee.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: isPaid
                                    ? AppColors.success
                                    : AppColors.warning,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  'Monthly ${CurrencyFormatter.format(employee.monthlySalary)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                                if (isPaid) ...[
                                  Text(
                                    'Paid ${CurrencyFormatter.format(payment.amount)} · ${dateFormat.format(payment.entryDate)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (payment.hasCommission)
                                    Text(
                                      _commissionLabel(payment),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: AppColors.success,
                                      ),
                                    ),
                                ] else
                                  Text(
                                    'Not paid for $monthLabel',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: AppSpacing.sm),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (isPaid
                                      ? AppColors.success
                                      : AppColors.warning)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              isPaid ? 'PAID' : 'UNPAID',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isPaid
                                    ? AppColors.success
                                    : AppColors.warning,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => showSalaryHistorySheet(
                              context: context,
                              employee: employee,
                              records: records,
                            ),
                            child: const Text('History'),
                          ),
                          const SizedBox(width: 4),
                          if (!isPaid)
                            AppButton(
                              label: 'Pay salary',
                              icon: Symbols.payments,
                              onPressed: () => onPay(employee),
                            )
                          else
                            AppButton(
                              label: 'Advance',
                              icon: Symbols.savings,
                              variant: AppButtonVariant.secondary,
                              onPressed: () => onAdvance(employee),
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

class _EmployeeMoneyRow {
  const _EmployeeMoneyRow({
    required this.name,
    required this.amount,
    required this.accountName,
    required this.entryDate,
    this.detail,
  });

  final String name;
  final double amount;
  final String accountName;
  final DateTime entryDate;
  final String? detail;
}

class _EmployeeMoneyTab extends StatelessWidget {
  const _EmployeeMoneyTab({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.total,
    required this.periodLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.onAdd,
  });

  final String title;
  final String subtitle;
  final List<_EmployeeMoneyRow> items;
  final double total;
  final String periodLabel;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    '$subtitle · $periodLabel ${CurrencyFormatter.format(total)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            AppButton(label: 'Add', icon: Symbols.add, onPressed: onAdd),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: items.isEmpty
              ? EmptyState(
                  title: emptyTitle,
                  message: emptyMessage,
                  icon: emptyIcon,
                  action: AppButton(
                    label: 'Add',
                    icon: Symbols.add,
                    onPressed: onAdd,
                  ),
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  [
                                    dateFormat.format(item.entryDate),
                                    item.accountName,
                                    if (item.detail != null &&
                                        item.detail!.isNotEmpty)
                                      item.detail!,
                                  ].join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.amount),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warning,
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
