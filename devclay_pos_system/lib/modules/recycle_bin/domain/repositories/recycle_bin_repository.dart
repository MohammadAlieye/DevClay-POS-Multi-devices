import '../entities/recycle_bin_item.dart';

abstract class RecycleBinRepository {
  Future<List<RecycleBinItem>> listItems();

  Future<void> restore(RecycleBinKind kind, int id);

  Future<void> purge(RecycleBinKind kind, int id);

  Future<void> emptyBin();

  Future<int> count();
}
