import 'package:isar_community/isar.dart';

part 'restaurant_check.g.dart';

@collection
class RestaurantCheck {
  Id id = Isar.autoIncrement;

  @Index()
  late int tableId;

  String tableCode = '';
  int guests = 1;

  /// open | sent | ready | served | closed | cancelled
  @Index()
  String status = 'open';

  /// JSON array of check line maps (productId, name, qty, unitPrice, …).
  late String linesJson;

  double serviceCharge = 0;
  double discount = 0;
  double subtotal = 0;
  double total = 0;

  /// pos | web
  String source = 'pos';

  /// When source=web and pin required: pending | accepted | rejected
  String webAcceptStatus = '';

  String notes = '';
  int? closedSaleId;
  String? closedInvoiceNo;

  late DateTime createdAt;
  DateTime? sentAt;
  DateTime? closedAt;
  DateTime? updatedAt;
}
