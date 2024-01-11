part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductAddToCartButtonLoading extends ProductState{}

class ProductAddToCartError extends ProductState{
  final AppException exception;

  ProductAddToCartError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}

class ProductAddToCartSuccess extends ProductState{}
