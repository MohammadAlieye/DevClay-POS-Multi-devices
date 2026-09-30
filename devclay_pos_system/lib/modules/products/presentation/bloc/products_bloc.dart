import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/product_item.dart';
import '../../domain/repositories/products_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._repository) : super(const ProductsInitial()) {
    on<ProductsStarted>(_onStarted);
    on<ProductsSearchChanged>(_onSearch);
    on<ProductsFilterChanged>(_onFilter);
    on<ProductsSortChanged>(_onSort);
    on<ProductsRefreshRequested>(_onRefresh);
    on<ProductsMessageDismissed>(_onMessageDismissed);
    on<ProductSaved>(_onSaved);
    on<ProductDeleted>(_onDeleted);
  }

  final ProductsRepository _repository;

  Future<void> _onStarted(
    ProductsStarted event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    ProductsSearchChanged event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    final query = event.query;
    if (current is ProductsLoaded) {
      emit(current.copyWith(query: query, isRefreshing: true));
      await _load(
        emit,
        query: query,
        filter: current.filter,
        sort: current.sort,
      );
      return;
    }
    await _load(emit, query: query);
  }

  Future<void> _onFilter(
    ProductsFilterChanged event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    if (current is! ProductsLoaded) return;
    emit(current.copyWith(filter: event.filter, clearMessage: true));
  }

  Future<void> _onSort(
    ProductsSortChanged event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    if (current is! ProductsLoaded) return;
    emit(current.copyWith(sort: event.sort, clearMessage: true));
  }

  Future<void> _onRefresh(
    ProductsRefreshRequested event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    if (current is ProductsLoaded) {
      await _load(
        emit,
        query: current.query,
        filter: current.filter,
        sort: current.sort,
      );
      return;
    }
    await _load(emit);
  }

  Future<void> _onSaved(ProductSaved event, Emitter<ProductsState> emit) async {
    final previous = state;
    try {
      if (event.id == null) {
        await _repository.createProduct(event.draft);
      } else {
        await _repository.updateProduct(event.id!, event.draft);
      }
      final current = state;
      if (current is ProductsLoaded) {
        await _load(
          emit,
          query: current.query,
          filter: current.filter,
          sort: current.sort,
          message: 'Product saved',
        );
      } else {
        await _load(emit, message: 'Product saved');
      }
    } catch (error) {
      if (previous is ProductsLoaded) {
        emit(previous.copyWith(message: userFacingError(error)));
      } else {
        emit(ProductsError(userFacingError(error)));
      }
    }
  }

  Future<void> _onDeleted(
    ProductDeleted event,
    Emitter<ProductsState> emit,
  ) async {
    final previous = state;
    try {
      await _repository.deleteProduct(event.id);
      final current = state;
      if (current is ProductsLoaded) {
        await _load(
          emit,
          query: current.query,
          filter: current.filter,
          sort: current.sort,
        );
      } else {
        await _load(emit);
      }
    } catch (error) {
      if (previous is ProductsLoaded) {
        emit(previous.copyWith(message: userFacingError(error)));
      } else {
        emit(ProductsError(userFacingError(error)));
      }
    }
  }

  void _onMessageDismissed(
    ProductsMessageDismissed event,
    Emitter<ProductsState> emit,
  ) {
    final current = state;
    if (current is ProductsLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _load(
    Emitter<ProductsState> emit, {
    String query = '',
    ProductsListFilter filter = ProductsListFilter.all,
    ProductsListSort sort = ProductsListSort.nameAsc,
    String? message,
  }) async {
    try {
      final products = await _repository.getProducts(query: query);
      final categories = await _repository.getCategories();
      emit(
        ProductsLoaded(
          products: products,
          categories: categories,
          query: query,
          filter: filter,
          sort: sort,
          message: message,
        ),
      );
    } catch (error) {
      emit(ProductsError(userFacingError(error)));
    }
  }
}
