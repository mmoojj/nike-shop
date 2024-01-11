part of 'cart_bloc.dart';

sealed class CartState  {
  const CartState();


}

final class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponse cartResponse;

  const CartSuccess(this.cartResponse);


}

class CartError extends CartState {
  final AppException exception;

  CartError(this.exception);

}

class CartAuthRequared extends CartState{}

class CartEmpty extends CartState{}
