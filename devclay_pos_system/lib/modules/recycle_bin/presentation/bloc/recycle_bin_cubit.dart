import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/recycle_bin_item.dart';
import '../../domain/repositories/recycle_bin_repository.dart';

class RecycleBinState extends Equatable {
  const RecycleBinState({
    this.items = const [],
    this.loading = false,
    this.message,
  });

  final List<RecycleBinItem> items;
  final bool loading;
  final String? message;

  RecycleBinState copyWith({
    List<RecycleBinItem>? items,
    bool? loading,
    String? message,
    bool clearMessage = false,
  }) {
    return RecycleBinState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [items, loading, message];
}

class RecycleBinCubit extends Cubit<RecycleBinState> {
  RecycleBinCubit(this._repository) : super(const RecycleBinState());

  final RecycleBinRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearMessage: true));
    try {
      final items = await _repository.listItems();
      emit(state.copyWith(items: items, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, message: e.toString()));
    }
  }

  Future<void> restore(RecycleBinItem item) async {
    try {
      await _repository.restore(item.kind, item.id);
      final items = await _repository.listItems();
      emit(
        state.copyWith(
          items: items,
          message: '${item.title} restored',
        ),
      );
    } catch (e) {
      emit(state.copyWith(message: 'Restore failed: $e'));
    }
  }

  Future<void> purge(RecycleBinItem item) async {
    try {
      await _repository.purge(item.kind, item.id);
      final items = await _repository.listItems();
      emit(
        state.copyWith(
          items: items,
          message: '${item.title} permanently deleted',
        ),
      );
    } catch (e) {
      emit(state.copyWith(message: 'Delete failed: $e'));
    }
  }

  Future<void> emptyBin() async {
    try {
      await _repository.emptyBin();
      emit(
        state.copyWith(
          items: const [],
          message: 'Recycle Bin emptied',
        ),
      );
    } catch (e) {
      emit(state.copyWith(message: 'Could not empty bin: $e'));
    }
  }
}
