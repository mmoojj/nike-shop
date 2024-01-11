part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> product;
  final int sort;
  final List<String> sortName;
  const ProductListSuccess(this.product, this.sort, this.sortName);
  @override
  List<Object> get props => [sort, sortName, product];
}

class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);

  @override
  List<Object> get props => [exception];
}

class ProductListEmptyState extends ProductListState {
  final String message;

  ProductListEmptyState(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
