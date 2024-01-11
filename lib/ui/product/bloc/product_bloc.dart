import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IcartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit)async {
      
      if ( event is CartAddButtonClicked){
          emit(ProductAddToCartButtonLoading());
          try{
            final result= await cartRepository.add(event.productId);
           await cartRepository.count();
            emit(ProductAddToCartSuccess());
          }catch(e){
            emit(ProductAddToCartError(AppException()));
          }
      }
    });
  }
}
