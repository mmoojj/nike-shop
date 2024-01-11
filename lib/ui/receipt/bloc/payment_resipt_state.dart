part of 'payment_resipt_bloc.dart';

sealed class PaymentResiptState extends Equatable {
  const PaymentResiptState();

  @override
  List<Object> get props => [];
}

final class PaymentResiptLoading extends PaymentResiptState {}

class PaymentResiptSuccess extends PaymentResiptState {
  final PaymentReciptData paymentReciptData;

  const PaymentResiptSuccess(this.paymentReciptData);
  @override
  // TODO: implement props
  List<Object> get props => [paymentReciptData];
}

class PaymentResiptError extends PaymentResiptState{
  final AppException exception;

  const PaymentResiptError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
