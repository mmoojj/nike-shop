import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment_recipt.dart';
import 'package:nike_shop/data/source/order_sata_source.dart';

final OrderRepository orderRepository =
    OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IorderRepository extends IorderDataSource {}

class OrderRepository implements IorderRepository {
  final IorderDataSource dataSource;

  OrderRepository(this.dataSource);
  @override
  Future<CreateOrderResult> create(createOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReciptData> getPaymentRecipt(int orderId) => dataSource.getPaymentRecipt(orderId);
  
  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();
}
