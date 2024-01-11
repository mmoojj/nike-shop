import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/repo/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IorderRepository repository;
  OrderHistoryBloc(this.repository) : super(OrderHistoryLoading()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStarted) {
        try {
          emit(OrderHistoryLoading());
          final items = await repository.getOrders();
          emit(OrderHistorySuccess(items));
        } catch (e) {
          emit(OrderHistoryError(AppException()));
        }
      }
    });
  }
}
