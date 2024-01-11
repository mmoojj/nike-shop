import 'package:nike_shop/data/product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
   int count;
  bool deleteButtonLoading=false;
  bool changeCountBtnLoading = false;

  CartItemEntity.fromjson(Map<String, dynamic> json)
      : product = ProductEntity.fromjsno(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    List<CartItemEntity> cartItems = [];

    jsonArray.forEach((element) {
      cartItems.add(CartItemEntity.fromjson(element));
    });
    return cartItems;
  }
}
