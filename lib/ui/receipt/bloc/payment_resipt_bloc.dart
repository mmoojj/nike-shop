import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/payment_recipt.dart';
import 'package:nike_shop/data/repo/order_repository.dart';

part 'payment_resipt_event.dart';
part 'payment_resipt_state.dart';

class PaymentResiptBloc extends Bloc<PaymentResiptEvent, PaymentResiptState> {
  
  final IorderRepository repository;
  PaymentResiptBloc(this.repository) : super(PaymentResiptLoading()) {
    on<PaymentResiptEvent>((event, emit) async {
      
      if (event is PaymentResiptStarted){
        try{
            emit(PaymentResiptLoading());
             final result= await repository.getPaymentRecipt(event.orderId);
            emit(PaymentResiptSuccess(result));
        }catch(e){

        }
      }
    });
  }
}
