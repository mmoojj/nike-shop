part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent{
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo,{this.isRefreshing=false});
}

class CartAuthInfoChange extends CartEvent{
  final AuthInfo? authInfo;

  const CartAuthInfoChange(this.authInfo);
}

class CartDeletButtonClicked extends CartEvent{
  final int cartItemId;

  const CartDeletButtonClicked(this.cartItemId);

}

class CartPlusBtnClicked extends CartEvent{
  final int cartItemId;

  const CartPlusBtnClicked(this.cartItemId);
  @override
  // TODO: implement props
  List<Object> get props => [cartItemId];
}

class CartMinusBtnClicked extends CartEvent{
  final int cartItemId;

  const CartMinusBtnClicked(this.cartItemId);

  @override
  // TODO: implement props
  List<Object> get props => [cartItemId];
}


