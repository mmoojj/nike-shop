import 'package:dio/dio.dart';
import 'package:nike_shop/data/common/http_respone_validator.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment_recipt.dart';
import 'package:nike_shop/data/product.dart';

abstract class IorderDataSource {
  Future<CreateOrderResult> create(createOrderParams params);
  Future<PaymentReciptData>  getPaymentRecipt(int orderId);
  Future<List<OrderEntity>>  getOrders();
}

class OrderRemoteDataSource with HttpResponseValidator implements IorderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> create(createOrderParams params)async {
    final response = await httpClient.post("order/submit", data: {
      "first_name": params.firstName,
      "last_name": params.lastName,
      "mobile": params.phoneNumber,
      "postal_code": params.postaCode,
      "address": params.address,
      "payment_method": params.paymentMethod == PaymentMethod.online
          ? "online"
          : "cash_on_delivery"
    });
    validateResponse(response);
    return CreateOrderResult.fromjson(response.data);
  }
  
  @override
  Future<PaymentReciptData> getPaymentRecipt(int orderId) async {
   final response = await httpClient.get("order/checkout?order_id=$orderId");
   return PaymentReciptData.fromjson(response.data);
  }
  
  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get("order/list");
    return (response.data as List).map((e) => OrderEntity.fromjson(e) ).toList();
  }
}
