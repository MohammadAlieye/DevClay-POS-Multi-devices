import 'package:isar_community/isar.dart';

part 'kitchen_ticket.g.dart';

@collection
class KitchenTicket {
  Id id = Isar.autoIncrement;

  @Index()
  late int checkId;

  @Index()
  late int tableId;

  String tableCode = '';
  String course = 'main';
  String station = 'kitchen';

  /// JSON lines subset for this ticket.
  late String linesJson;

  /// queued | preparing | ready | bumped
  @Index()
  String status = 'queued';

  late DateTime firedAt;
  DateTime? readyAt;
  DateTime? bumpedAt;
}
