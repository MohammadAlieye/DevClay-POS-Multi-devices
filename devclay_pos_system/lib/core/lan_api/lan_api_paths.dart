/// LAN API v1 path constants.
abstract final class LanApiPaths {
  static const apiVersion = '1';
  static const prefix = '/api/v1';

  static const health = '$prefix/health';
  static const login = '$prefix/auth/login';
  static const profile = '$prefix/settings/profile';
  static const products = '$prefix/products';
  static const productById = '$prefix/products/'; // + id
  static const customers = '$prefix/customers';
  static const customerById = '$prefix/customers/'; // + id
  static const customerPayment = '$prefix/customers/'; // + id/payments
  static const paymentAccounts = '$prefix/accounts/payment';
  static const sales = '$prefix/sales';
  static const saleById = '$prefix/sales/'; // + id
  static const saleReturn = '$prefix/sales/'; // + id/returns
  static const nextInvoicePreview = '$prefix/sales/next-invoice-preview';
  static const heldSales = '$prefix/held-sales';
  static const heldSaleById = '$prefix/held-sales/'; // + id
  static const dashboardSummary = '$prefix/dashboard/summary';

  // Restaurant staff (authenticated). Guest web stays under /guest/*.
  static const restaurantFloors = '$prefix/restaurant/floors';
  static const restaurantTables = '$prefix/restaurant/tables';
  static const restaurantTableById = '$prefix/restaurant/tables/'; // + id
  static const restaurantChecks = '$prefix/restaurant/checks';
  static const restaurantCheckById = '$prefix/restaurant/checks/'; // + id
  static const restaurantKitchenTickets = '$prefix/restaurant/kitchen/tickets';
  static const restaurantKitchenTicketById =
      '$prefix/restaurant/kitchen/tickets/'; // + id
}
