import 'package:devclay_pos_system/modules/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:devclay_pos_system/modules/dashboard/domain/entities/dashboard_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardLocalDataSource.mapHostDashboardSummary', () {
    test('maps dense host payload including profit and top products', () {
      final data = DashboardLocalDataSource.mapHostDashboardSummary({
        'todaySales': 1000,
        'todayProfit': 250,
        'monthlySales': 9000,
        'monthlyProfit': 2000,
        'todaySalesChange': 10,
        'todayProfitChange': 5,
        'monthlySalesChange': 8,
        'monthlyProfitChange': 4,
        'todayKhataSales': 100,
        'todayExpenses': 50,
        'monthlyExpenses': 400,
        'receivables': 300,
        'payablesDue': 200,
        'cashOnHand': 1500,
        'heldSalesCount': 2,
        'todayReceiptCount': 4,
        'avgTicket': 250,
        'voidedToday': 20,
        'returnsToday': 30,
        'paymentMix': {
          'cash': 600,
          'card': 200,
          'wallet': 100,
          'khata': 100,
        },
        'hourlySalesToday': [
          {'hour': 10, 'amount': 100},
          {'hour': 11, 'amount': 200},
        ],
        'staffSalesToday': [
          {'name': 'Ali', 'amount': 700, 'receipts': 3},
        ],
        'salesSeries': [
          {
            'date': '2026-09-29T00:00:00.000',
            'amount': 400,
            'profit': 90,
          },
        ],
        'topProducts': [
          {
            'name': 'Burger',
            'sku': 'B1',
            'unitsSold': 5,
            'revenue': 500,
          },
        ],
        'recentSales': [
          {
            'invoiceNo': 'INV-1',
            'customerName': 'Walk-in',
            'amount': 250,
            'paymentMethod': 'Cash',
            'soldAt': '2026-09-30T12:00:00.000',
          },
        ],
        'lowStockItems': [
          {
            'name': 'Coke',
            'sku': 'C1',
            'quantity': 2,
            'reorderLevel': 10,
          },
        ],
        'isRestaurant': true,
        'openTables': 3,
        'kitchenOpenTickets': 2,
      });

      expect(data.todaySales, 1000);
      expect(data.todayProfit, 250);
      expect(data.avgTicket, 250);
      expect(data.todayReceiptCount, 4);
      expect(data.paymentMix.cash, 600);
      expect(data.hourlySalesToday, hasLength(2));
      expect(data.staffSalesToday.first.name, 'Ali');
      expect(data.salesSeries.first.profit, 90);
      expect(data.topProducts.first.name, 'Burger');
      expect(data.recentSales, hasLength(1));
      expect(data.lowStockItems.first.sku, 'C1');
      expect(data.isRestaurant, isTrue);
      expect(data.openTables, 3);
      expect(data.kitchenOpenTickets, 2);
    });

    test('defaults missing fields safely', () {
      final data = DashboardLocalDataSource.mapHostDashboardSummary(const {});
      expect(data.todaySales, 0);
      expect(data.salesSeries, isEmpty);
      expect(data.paymentMix, const PaymentMix());
    });
  });

  group('PaymentMix', () {
    test('computes total', () {
      const mix = PaymentMix(cash: 10, card: 20, wallet: 5, khata: 5);
      expect(mix.total, 40);
    });
  });
}
