import 'package:dio/dio.dart';
import 'package:nike_shop/data/cart_item.dart';
import 'package:nike_shop/data/add_to_cart_respons.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/common/http_respone_validator.dart';

abstract class IcartDataSource{
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId,int count);
  Future<void> delete(int cartItemId);
  Future<int>  count();
  Future<CartResponse>  getAll();
}

class CartRemoteDataSource with HttpResponseValidator implements IcartDataSource{
  
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);
  @override
  Future<AddToCartResponse> add(int productId) async {
    final response = await httpClient.post("cart/add",data: {
      "product_id":productId
    });

    return AddToCartResponse.fromjson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final response =  await httpClient.post("cart/changeCount",data: {
          "cart_item_id":cartItemId,
          "count":count
      });

    return AddToCartResponse.fromjson(response.data);

  }

  @override
  Future<int> count() async {
   final response= await httpClient.get("cart/count");
   
   return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId)async {
   await httpClient.post("cart/remove",data: {
      'cart_item_id':cartItemId
    });
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get("cart/list");
    return CartResponse.fromjson(response.data);


  }

}

