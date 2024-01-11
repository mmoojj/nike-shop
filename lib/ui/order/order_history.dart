import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_shop/ui/widget/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderHistoryBloc>(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("سوابق سفارش"),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.items;
              return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("شناسه سفارش"),
                                Text(order.id.toString())
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(" مبلغ"),
                                Text(order.payablePrice.withPriceLabale)
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          SizedBox(
                            height: 130,
                            child:
                       ListView.builder(
                        itemCount: order.items.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.all(8),
                                child: ImageLoadingService(
                                  borderRadius: BorderRadius.circular(8),
                                    imageurl: order.items[index].imageurl),
                              );
                            }),
                          )
                        ],
                      ),
                    );
                  });
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
