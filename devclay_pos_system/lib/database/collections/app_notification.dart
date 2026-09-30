import 'package:isar_community/isar.dart';

part 'app_notification.g.dart';

@collection
class AppNotification {
  Id id = Isar.autoIncrement;

  late String title;
  late String body;
  late String type;
  late DateTime createdAt;
  late bool isRead;

  /// Optional undo action, e.g. `restore_product` / `restore_held_sale`.
  String? actionType;

  /// Payload for [actionType], usually the entity id as a string.
  String? actionPayload;
}
