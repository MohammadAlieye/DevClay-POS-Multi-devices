part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

final class ProductsStarted extends ProductsEvent {
  const ProductsStarted();
}

final class ProductsSearchChanged extends ProductsEvent {
  const ProductsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ProductsFilterChanged extends ProductsEvent {
  const ProductsFilterChanged(this.filter);

  final ProductsListFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class ProductsSortChanged extends ProductsEvent {
  const ProductsSortChanged(this.sort);

  final ProductsListSort sort;

  @override
  List<Object?> get props => [sort];
}

final class ProductsRefreshRequested extends ProductsEvent {
  const ProductsRefreshRequested();
}

final class ProductsMessageDismissed extends ProductsEvent {
  const ProductsMessageDismissed();
}

final class ProductSaved extends ProductsEvent {
  const ProductSaved({required this.draft, this.id});

  final ProductDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

final class ProductDeleted extends ProductsEvent {
  const ProductDeleted(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
