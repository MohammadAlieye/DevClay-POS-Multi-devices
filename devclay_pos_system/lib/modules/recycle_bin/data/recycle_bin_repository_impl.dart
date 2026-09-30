import '../domain/entities/recycle_bin_item.dart';
import '../domain/repositories/recycle_bin_repository.dart';
import 'datasources/recycle_bin_local_datasource.dart';

class RecycleBinRepositoryImpl implements RecycleBinRepository {
  RecycleBinRepositoryImpl(this._local);

  final RecycleBinLocalDataSource _local;

  @override
  Future<List<RecycleBinItem>> listItems() => _local.listItems();

  @override
  Future<void> restore(RecycleBinKind kind, int id) =>
      _local.restore(kind, id);

  @override
  Future<void> purge(RecycleBinKind kind, int id) => _local.purge(kind, id);

  @override
  Future<void> emptyBin() => _local.emptyBin();

  @override
  Future<int> count() => _local.count();
}
