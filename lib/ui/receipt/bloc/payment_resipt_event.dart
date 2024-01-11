part of 'payment_resipt_bloc.dart';

sealed class PaymentResiptEvent extends Equatable {
  const PaymentResiptEvent();

  @override
  List<Object> get props => [];
}


class PaymentResiptStarted extends PaymentResiptEvent{
  final int orderId;

  const PaymentResiptStarted(this.orderId);

  @override
  List<Object> get props => [orderId];
}