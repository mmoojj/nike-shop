part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

final class OrderHistoryLoading extends OrderHistoryState {}

final class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderEntity> items;

  const OrderHistorySuccess(this.items);

  @override
  // TODO: implement props
  List<Object> get props => [items];
}

final class OrderHistoryError extends OrderHistoryState {
  final AppException exception;

  const OrderHistoryError(this.exception);

  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
