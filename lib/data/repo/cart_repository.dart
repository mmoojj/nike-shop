import 'package:flutter/cupertino.dart';
import 'package:nike_shop/data/cart_item.dart';
import 'package:nike_shop/data/add_to_cart_respons.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/source/cart_data_source.dart';

final CartRepository cartRepository =
    CartRepository(CartRemoteDataSource(httpClient));

abstract class IcartRepository {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRepository implements IcartRepository {
  final IcartDataSource dataSource;
  static final ValueNotifier<int>  countNotifier = ValueNotifier<int>(0); 

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count)async {
    return  await dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final response = await dataSource.count();
    countNotifier.value = response;
    return response;
  }

  @override
  Future<void> delete(int cartItemId) {
   return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() async {
    return await dataSource.getAll();
  }
}
