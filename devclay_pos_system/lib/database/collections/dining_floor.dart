import 'package:isar_community/isar.dart';

part 'dining_floor.g.dart';

@collection
class DiningFloor {
  Id id = Isar.autoIncrement;

  late String name;
  int sortOrder = 0;
  bool isActive = true;
  DateTime? deletedAt;
  late DateTime createdAt;
}
