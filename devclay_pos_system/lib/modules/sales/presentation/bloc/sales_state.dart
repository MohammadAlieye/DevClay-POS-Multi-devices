part of 'sales_bloc.dart';

sealed class SalesState extends Equatable {
  const SalesState();

  @override
  List<Object?> get props => [];
}

class SalesInitial extends SalesState {
  const SalesInitial();
}

class SalesLoading extends SalesState {
  const SalesLoading();
}

class SalesError extends SalesState {
  const SalesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SalesLoaded extends SalesState {
  const SalesLoaded({
    required this.sales,
    required this.returns,
    required this.query,
    required this.period,
    required this.viewTab,
  });

  final List<SaleRecord> sales;
  final List<SaleReturnRecord> returns;
  final String query;
  final SalesPeriod period;
  final SalesViewTab viewTab;

  List<SaleRecord> get periodSales =>
      sales.where((sale) => sale.isInPeriod(period)).toList();

  List<SaleReturnRecord> get visibleReturns {
    final records = returns.where((item) {
      final date = item.returnedAt;
      final now = DateTime.now();
      return switch (period) {
        SalesPeriod.all => true,
        SalesPeriod.today =>
          date.year == now.year &&
              date.month == now.month &&
              date.day == now.day,
        SalesPeriod.week => !date.isBefore(
          DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: now.weekday - 1)),
        ),
        SalesPeriod.month => date.year == now.year && date.month == now.month,
      };
    });
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return records.toList();
    return records
        .where(
          (item) =>
              item.returnNo.toLowerCase().contains(q) ||
              item.invoiceNo.toLowerCase().contains(q) ||
              item.customerName.toLowerCase().contains(q) ||
              item.reason.toLowerCase().contains(q),
        )
        .toList();
  }

  List<SaleRecord> get visibleSales {
    final q = query.trim().toLowerCase();
    final base = periodSales;
    if (q.isEmpty) return base;
    return base.where((sale) {
      return sale.invoiceNo.toLowerCase().contains(q) ||
          sale.customerName.toLowerCase().contains(q) ||
          sale.paymentMethod.toLowerCase().contains(q) ||
          sale.lines.any(
            (line) =>
                line.productName.toLowerCase().contains(q) ||
                line.productSku.toLowerCase().contains(q),
          );
    }).toList();
  }

  double get periodTotal =>
      periodSales.fold(0, (sum, sale) => sum + sale.netTotal);

  int get periodReceiptCount => periodSales.length;

  int get periodUnitsSold => periodSales.fold(
    0,
    (sum, sale) => sum + (sale.itemCount * sale.remainingRatio).round(),
  );

  List<ProductSalesSummary> get productBreakdown {
    final map = <int, _ProductAccumulator>{};
    for (final sale in visibleSales) {
      for (final line in sale.lines) {
        final current = map[line.productId];
        if (current == null) {
          map[line.productId] = _ProductAccumulator(
            productId: line.productId,
            productName: line.productName,
            productSku: line.productSku,
            unitsSold: (line.quantity * sale.remainingRatio).round(),
            revenue: line.lineTotal * sale.remainingRatio,
            receiptIds: {sale.id},
          );
        } else {
          map[line.productId] = current.copyWith(
            unitsSold:
                current.unitsSold +
                (line.quantity * sale.remainingRatio).round(),
            revenue: current.revenue + line.lineTotal * sale.remainingRatio,
            receiptIds: {...current.receiptIds, sale.id},
          );
        }
      }
    }

    return map.values
        .map(
          (item) => ProductSalesSummary(
            productId: item.productId,
            productName: item.productName,
            productSku: item.productSku,
            unitsSold: item.unitsSold,
            revenue: item.revenue,
            receiptCount: item.receiptIds.length,
          ),
        )
        .toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));
  }

  List<PaymentSalesSummary> get paymentBreakdown {
    final map = <String, _PaymentAccumulator>{};
    for (final sale in visibleSales) {
      final current = map[sale.paymentMethod];
      if (current == null) {
        map[sale.paymentMethod] = _PaymentAccumulator(
          paymentMethod: sale.paymentMethod,
          receiptCount: 1,
          total: sale.netTotal,
        );
      } else {
        map[sale.paymentMethod] = current.copyWith(
          receiptCount: current.receiptCount + 1,
          total: current.total + sale.netTotal,
        );
      }
    }

    return map.values
        .map(
          (item) => PaymentSalesSummary(
            paymentMethod: item.paymentMethod,
            receiptCount: item.receiptCount,
            total: item.total,
          ),
        )
        .toList()
      ..sort((a, b) => b.total.compareTo(a.total));
  }

  List<CustomerSalesSummary> get customerBreakdown {
    final map = <String, _CustomerAccumulator>{};
    for (final sale in visibleSales) {
      final name = sale.customerName.trim().isEmpty
          ? 'Walk-in'
          : sale.customerName.trim();
      final key = name.toLowerCase();
      final current = map[key];
      if (current == null) {
        map[key] = _CustomerAccumulator(
          customerName: name,
          receiptCount: 1,
          total: sale.netTotal,
          unitsSold: (sale.itemCount * sale.remainingRatio).round(),
        );
      } else {
        map[key] = current.copyWith(
          receiptCount: current.receiptCount + 1,
          total: current.total + sale.netTotal,
          unitsSold:
              current.unitsSold +
              (sale.itemCount * sale.remainingRatio).round(),
        );
      }
    }

    return map.values
        .map(
          (item) => CustomerSalesSummary(
            customerName: item.customerName,
            receiptCount: item.receiptCount,
            total: item.total,
            unitsSold: item.unitsSold,
          ),
        )
        .toList()
      ..sort((a, b) => b.total.compareTo(a.total));
  }

  SalesLoaded copyWith({
    List<SaleRecord>? sales,
    List<SaleReturnRecord>? returns,
    String? query,
    SalesPeriod? period,
    SalesViewTab? viewTab,
  }) {
    return SalesLoaded(
      sales: sales ?? this.sales,
      returns: returns ?? this.returns,
      query: query ?? this.query,
      period: period ?? this.period,
      viewTab: viewTab ?? this.viewTab,
    );
  }

  @override
  List<Object?> get props => [sales, returns, query, period, viewTab];
}

class _ProductAccumulator {
  const _ProductAccumulator({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.unitsSold,
    required this.revenue,
    required this.receiptIds,
  });

  final int productId;
  final String productName;
  final String productSku;
  final int unitsSold;
  final double revenue;
  final Set<int> receiptIds;

  _ProductAccumulator copyWith({
    int? unitsSold,
    double? revenue,
    Set<int>? receiptIds,
  }) {
    return _ProductAccumulator(
      productId: productId,
      productName: productName,
      productSku: productSku,
      unitsSold: unitsSold ?? this.unitsSold,
      revenue: revenue ?? this.revenue,
      receiptIds: receiptIds ?? this.receiptIds,
    );
  }
}

class _PaymentAccumulator {
  const _PaymentAccumulator({
    required this.paymentMethod,
    required this.receiptCount,
    required this.total,
  });

  final String paymentMethod;
  final int receiptCount;
  final double total;

  _PaymentAccumulator copyWith({int? receiptCount, double? total}) {
    return _PaymentAccumulator(
      paymentMethod: paymentMethod,
      receiptCount: receiptCount ?? this.receiptCount,
      total: total ?? this.total,
    );
  }
}

class _CustomerAccumulator {
  const _CustomerAccumulator({
    required this.customerName,
    required this.receiptCount,
    required this.total,
    required this.unitsSold,
  });

  final String customerName;
  final int receiptCount;
  final double total;
  final int unitsSold;

  _CustomerAccumulator copyWith({
    int? receiptCount,
    double? total,
    int? unitsSold,
  }) {
    return _CustomerAccumulator(
      customerName: customerName,
      receiptCount: receiptCount ?? this.receiptCount,
      total: total ?? this.total,
      unitsSold: unitsSold ?? this.unitsSold,
    );
  }
}
