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
  static const paymentAccounts = '$prefix/accounts/payment';
  static const sales = '$prefix/sales';
  static const saleById = '$prefix/sales/'; // + id
  static const nextInvoicePreview = '$prefix/sales/next-invoice-preview';
}
