import 'package:nike_shop/data/product.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGetwayUrl;

  CreateOrderResult.fromjson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGetwayUrl = json['bank_gateway_url'];
}

class createOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postaCode;
  final String address;
  final PaymentMethod paymentMethod;

  createOrderParams(this.firstName, this.lastName, this.phoneNumber,
      this.postaCode, this.address, this.paymentMethod);
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id, this.payablePrice, this.items);

  OrderEntity.fromjson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        items = (json['order_items'] as List)
            .map((e) => ProductEntity.fromjsno(e['product']))
            .toList();
}
