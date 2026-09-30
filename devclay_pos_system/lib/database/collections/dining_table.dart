import 'package:isar_community/isar.dart';

part 'dining_table.g.dart';

@collection
class DiningTable {
  Id id = Isar.autoIncrement;

  @Index()
  late int floorId;

  /// Short code shown on floor map / QR, e.g. T1.
  @Index(unique: true, replace: true)
  late String code;

  late String name;

  /// Seat capacity (chairs).
  int capacity = 4;

  /// free | seated | ordered | bill | dirty
  String status = 'free';

  /// Map placement as 0–100 percent of canvas.
  double posX = 10;
  double posY = 10;

  /// round | square | rect
  String shape = 'square';

  /// HMAC / opaque token embedded in guest QR.
  String guestToken = '';

  int guests = 0;
  int? openCheckId;
  bool isActive = true;
  DateTime? deletedAt;
  late DateTime createdAt;
  DateTime? updatedAt;
}
