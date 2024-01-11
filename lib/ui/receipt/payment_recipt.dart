import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/themes.dart';
import 'package:nike_shop/ui/receipt/bloc/payment_resipt_bloc.dart';

class PaymentReciptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReciptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("رسید پرداخت"),
      ),
      body: BlocProvider<PaymentResiptBloc>(
        create: (context) => PaymentResiptBloc(orderRepository)
          ..add(PaymentResiptStarted(orderId)),
        child: BlocBuilder<PaymentResiptBloc, PaymentResiptState>(
          builder: (context, state) {
            if (state is PaymentResiptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                         state.paymentReciptData.purchesSucess? "پرداخت با موفقیت انجام شد":"پرداخت نا موفق بود",
                          style: Theme.of(context).textTheme.titleLarge!.apply(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "وضعیت سفارش",
                              style: TextStyle(
                                  color: LightThemeColor.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReciptData.paymentStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              " مبلغ",
                              style: TextStyle(
                                  color: LightThemeColor.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReciptData.payablePrice.withPriceLabale,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text("یازگشت به صفحه اصلی"))
                ],
              );
            } else if (state is PaymentResiptError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is PaymentResiptLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception("state is not suported");
            }
          },
        ),
      ),
    );
  }
}
