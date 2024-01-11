import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/Auth_info.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final IcartRepository repository;
  CartBloc(this.repository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequared());
        } else {
          await loadCartItem(emit, event.isRefreshing);
        }
      } else if (event is CartDeletButtonClicked) {
        await onDeleteBtn(event, emit);
      } else if (event is CartAuthInfoChange) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequared());
        } else {
          if (state is CartAuthRequared) {
            await loadCartItem(emit, false);
          }
        }
      } else if (event is CartPlusBtnClicked || event is CartMinusBtnClicked) {
        try {
          int cartItemId = 0;
          if (event is CartPlusBtnClicked) {
            cartItemId = event.cartItemId;
          } else if (event is CartMinusBtnClicked) {
            cartItemId = event.cartItemId;
          }
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);

            final cartItemIndex = successState.cartResponse.items
                .indexWhere((element) => element.id == cartItemId);
            successState
                .cartResponse.items[cartItemIndex].changeCountBtnLoading = true;
            emit(CartSuccess(successState.cartResponse));

            await Future.delayed(const Duration(seconds: 2));
            final int newCount = event is CartPlusBtnClicked
                ? ++successState.cartResponse.items[cartItemIndex].count 
                : --successState.cartResponse.items[cartItemIndex].count;

            await repository.changeCount(cartItemId, newCount);
            await repository.count();
            
            successState.cartResponse.items
                .firstWhere((element) => element.id == cartItemId)
                ..count = newCount
                ..changeCountBtnLoading = false;
            
            emit(calcolatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  Future<void> onDeleteBtn(
      CartDeletButtonClicked event, Emitter<CartState> emit) async {
    try {
      if (state is CartSuccess) {
        final successState = (state as CartSuccess);

        final cartItemIndex = successState.cartResponse.items
            .indexWhere((element) => element.id == event.cartItemId);
        successState.cartResponse.items[cartItemIndex].deleteButtonLoading =
            true;
        emit(CartSuccess(successState.cartResponse));
      }
      await repository.delete(event.cartItemId);
      await repository.count();
      if (state is CartSuccess) {
        final successState = (state as CartSuccess);
        successState.cartResponse.items
            .removeWhere((element) => element.id == event.cartItemId);

        if (successState.cartResponse.items.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(calcolatePriceInfo(successState.cartResponse));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadCartItem(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }

      final result = await repository.getAll();
      if (result.items.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(result));
      }
    } catch (e) {
      emit(CartError(e is AppException ? e : AppException()));
    }
  }

  CartSuccess calcolatePriceInfo(CartResponse cartResponse) {
    int payablePrice = 0;
    int totalPrice = 0;
    int shippingCost = 0;

    cartResponse.items.forEach((cartItem) {
      payablePrice += cartItem.product.price * cartItem.count;
      totalPrice += cartItem.product.previousPrice * cartItem.count;
    });
    shippingCost = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.payablePrice = payablePrice;
    cartResponse.totalPrice = totalPrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
