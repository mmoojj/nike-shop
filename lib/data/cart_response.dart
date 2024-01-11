import 'package:nike_shop/data/cart_item.dart';

class CartResponse {
  final List<CartItemEntity> items;
   int payablePrice;
   int totalPrice;
   int shippingCost;

  CartResponse.fromjson(Map<String,dynamic> json):
  items=CartItemEntity.parseJsonArray(json['cart_items']),
  payablePrice=json['payable_price'],
  totalPrice=json['total_price'],
  shippingCost=json['shipping_cost'];

}