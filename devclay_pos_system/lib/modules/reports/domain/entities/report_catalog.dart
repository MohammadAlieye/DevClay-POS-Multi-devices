import 'package:material_symbols_icons/symbols.dart';

/// Unique identifier for each report in the Reports Center.
enum ReportId {
  // Financial
  sales,
  profit,
  expenses,
  // Inventory
  stock,
  stockMovement,
  lowStock,
  outOfStock,
  expiringSoon,
  expiredProducts,
  fastMoving,
  slowMoving,
  deadStock,
  stockValuation,
  expiry,
  // Purchasing
  purchases,
  suppliers,
  outstandingSupplierPayments,
  purchaseReturns,
  // Operations
  cashierStaff,
  shifts,
  returnsRefunds,
  discounts,
  voidedSales,
  // Customers
  customerSales,
  customerPurchaseHistory,
  topCustomers,
  customerOutstandingBalance,
  // Tax
  taxSummary,
  taxCollected,
  taxByProduct,
  taxByPeriod,
  // System
  auditLog,
  userActivity,
  stockAdjustments,
}

enum ReportCategory {
  financial('Financial'),
  inventory('Inventory'),
  purchasing('Purchasing'),
  operations('Operations'),
  customers('Customers'),
  tax('Tax'),
  system('System');

  const ReportCategory(this.label);
  final String label;
}

class ReportDefinition {
  const ReportDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    this.requiresPeriod = true,
    this.available = true,
    this.unavailableMessage,
  });

  final ReportId id;
  final String title;
  final String description;
  final ReportCategory category;
  final dynamic icon;
  final bool requiresPeriod;
  final bool available;
  final String? unavailableMessage;

  String get routeSegment => id.name;
}

abstract final class ReportCatalog {
  static const all = <ReportDefinition>[
    // Financial
    ReportDefinition(
      id: ReportId.sales,
      title: 'Sales',
      description:
          'Gross and net sales, receipts, payment mix, and top products.',
      category: ReportCategory.financial,
      icon: Symbols.payments,
    ),
    ReportDefinition(
      id: ReportId.profit,
      title: 'Profit',
      description:
          'Gross profit, margins, and profitability by product and category.',
      category: ReportCategory.financial,
      icon: Symbols.trending_up,
    ),
    ReportDefinition(
      id: ReportId.expenses,
      title: 'Expenses',
      description: 'Operating costs by category, trends, and largest expenses.',
      category: ReportCategory.financial,
      icon: Symbols.receipt_long,
    ),
    // Inventory
    ReportDefinition(
      id: ReportId.stock,
      title: 'Stock',
      description: 'Active products, units on hand, and stock value at cost.',
      category: ReportCategory.inventory,
      icon: Symbols.inventory_2,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.stockMovement,
      title: 'Stock Movement',
      description: 'Inbound and outbound stock changes over time.',
      category: ReportCategory.inventory,
      icon: Symbols.swap_horiz,
    ),
    ReportDefinition(
      id: ReportId.lowStock,
      title: 'Low Stock',
      description: 'Products at or below their low-stock threshold.',
      category: ReportCategory.inventory,
      icon: Symbols.warning,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.outOfStock,
      title: 'Out of Stock',
      description: 'Products with zero available stock.',
      category: ReportCategory.inventory,
      icon: Symbols.remove_shopping_cart,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.expiringSoon,
      title: 'Expiring Soon',
      description: 'Batch and product lots expiring within a selected window.',
      category: ReportCategory.inventory,
      icon: Symbols.schedule,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.expiredProducts,
      title: 'Expired Products',
      description: 'Products and batches past their expiry date.',
      category: ReportCategory.inventory,
      icon: Symbols.event_busy,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.expiry,
      title: 'Expiry Report',
      description:
          'Detailed expiry list with batch, supplier, and stock value.',
      category: ReportCategory.inventory,
      icon: Symbols.calendar_month,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.fastMoving,
      title: 'Fast Moving Products',
      description: 'Products with the highest sales velocity.',
      category: ReportCategory.inventory,
      icon: Symbols.speed,
    ),
    ReportDefinition(
      id: ReportId.slowMoving,
      title: 'Slow Moving Products',
      description: 'Products with low sales over the selected period.',
      category: ReportCategory.inventory,
      icon: Symbols.hourglass_empty,
    ),
    ReportDefinition(
      id: ReportId.deadStock,
      title: 'Dead Stock',
      description: 'Products with stock on hand but no recent sales.',
      category: ReportCategory.inventory,
      icon: Symbols.block,
    ),
    ReportDefinition(
      id: ReportId.stockValuation,
      title: 'Stock Valuation',
      description: 'Stock value at cost grouped by category.',
      category: ReportCategory.inventory,
      icon: Symbols.account_balance,
      requiresPeriod: false,
    ),
    // Purchasing
    ReportDefinition(
      id: ReportId.purchases,
      title: 'Purchases',
      description: 'Purchase totals, trends, and history.',
      category: ReportCategory.purchasing,
      icon: Symbols.local_shipping,
    ),
    ReportDefinition(
      id: ReportId.suppliers,
      title: 'Suppliers',
      description: 'Purchases grouped by supplier.',
      category: ReportCategory.purchasing,
      icon: Symbols.storefront,
    ),
    ReportDefinition(
      id: ReportId.outstandingSupplierPayments,
      title: 'Outstanding Supplier Payments',
      description: 'Unpaid purchase balances owed to suppliers.',
      category: ReportCategory.purchasing,
      icon: Symbols.pending_actions,
      requiresPeriod: false,
    ),
    ReportDefinition(
      id: ReportId.purchaseReturns,
      title: 'Purchase Returns',
      description: 'Returned goods to suppliers.',
      category: ReportCategory.purchasing,
      icon: Symbols.undo,
    ),
    // Operations
    ReportDefinition(
      id: ReportId.cashierStaff,
      title: 'Cashier / Staff',
      description: 'Sales performance by staff member.',
      category: ReportCategory.operations,
      icon: Symbols.badge,
    ),
    ReportDefinition(
      id: ReportId.shifts,
      title: 'Shifts',
      description: 'Shift opening/closing cash and variance.',
      category: ReportCategory.operations,
      icon: Symbols.schedule,
    ),
    ReportDefinition(
      id: ReportId.returnsRefunds,
      title: 'Returns / Refunds',
      description: 'Returned sales and refund amounts.',
      category: ReportCategory.operations,
      icon: Symbols.assignment_return,
    ),
    ReportDefinition(
      id: ReportId.discounts,
      title: 'Discounts',
      description: 'Cart and line discounts by product and date.',
      category: ReportCategory.operations,
      icon: Symbols.sell,
    ),
    ReportDefinition(
      id: ReportId.voidedSales,
      title: 'Voided Sales',
      description: 'Cancelled or voided receipts.',
      category: ReportCategory.operations,
      icon: Symbols.cancel,
    ),
    // Customers
    ReportDefinition(
      id: ReportId.customerSales,
      title: 'Customer Sales',
      description: 'Sales totals grouped by customer.',
      category: ReportCategory.customers,
      icon: Symbols.person,
    ),
    ReportDefinition(
      id: ReportId.customerPurchaseHistory,
      title: 'Customer Purchase History',
      description: 'Receipt-level history for customers.',
      category: ReportCategory.customers,
      icon: Symbols.history,
    ),
    ReportDefinition(
      id: ReportId.topCustomers,
      title: 'Top Customers',
      description: 'Highest spending customers for the period.',
      category: ReportCategory.customers,
      icon: Symbols.emoji_events,
    ),
    ReportDefinition(
      id: ReportId.customerOutstandingBalance,
      title: 'Customer Outstanding Balance',
      description: 'Khata balances — take and give from customers.',
      category: ReportCategory.customers,
      icon: Symbols.account_balance_wallet,
      requiresPeriod: false,
    ),
    // Tax
    ReportDefinition(
      id: ReportId.taxSummary,
      title: 'Tax Summary',
      description: 'Total tax collected and breakdown.',
      category: ReportCategory.tax,
      icon: Symbols.receipt,
    ),
    ReportDefinition(
      id: ReportId.taxCollected,
      title: 'Tax Collected',
      description: 'Tax amounts from completed sales.',
      category: ReportCategory.tax,
      icon: Symbols.payments,
    ),
    ReportDefinition(
      id: ReportId.taxByProduct,
      title: 'Tax by Product',
      description: 'Tax attributed to each product sold.',
      category: ReportCategory.tax,
      icon: Symbols.category,
    ),
    ReportDefinition(
      id: ReportId.taxByPeriod,
      title: 'Tax by Period',
      description: 'Tax collected over time.',
      category: ReportCategory.tax,
      icon: Symbols.timeline,
    ),
    // System
    ReportDefinition(
      id: ReportId.auditLog,
      title: 'Audit Log',
      description: 'Important changes to products, prices, and stock.',
      category: ReportCategory.system,
      icon: Symbols.fact_check,
    ),
    ReportDefinition(
      id: ReportId.userActivity,
      title: 'User Activity',
      description: 'Actions performed by staff accounts.',
      category: ReportCategory.system,
      icon: Symbols.manage_accounts,
    ),
    ReportDefinition(
      id: ReportId.stockAdjustments,
      title: 'Stock Adjustments',
      description: 'Manual stock corrections and adjustments.',
      category: ReportCategory.system,
      icon: Symbols.tune,
    ),
  ];

  static ReportDefinition? find(ReportId id) {
    for (final def in all) {
      if (def.id == id) return def;
    }
    return null;
  }

  static ReportDefinition? findByRoute(String? segment) {
    if (segment == null || segment.isEmpty) return null;
    for (final def in all) {
      if (def.routeSegment == segment) return def;
    }
    return null;
  }

  static List<ReportDefinition> forCategory(ReportCategory category) {
    return all.where((def) => def.category == category).toList();
  }

  static List<ReportCategory> get categories => ReportCategory.values;
}
