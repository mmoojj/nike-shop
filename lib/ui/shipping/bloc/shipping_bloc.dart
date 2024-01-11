import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/repo/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IorderRepository repository;
  ShippingBloc(this.repository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        try {
          emit(ShippingLoading());
          final result = await repository.create(event.params);
          emit(ShippingSucess(result));
        } catch (e) {
          emit(ShippingError(e is AppException ? e : AppException()));
        }
      }
    });
  }
}
