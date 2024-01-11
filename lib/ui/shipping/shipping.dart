import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/payment_web_view.dart';
import 'package:nike_shop/ui/receipt/payment_recipt.dart';
import 'package:nike_shop/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  StreamSubscription? streamSubscription;

  final TextEditingController firstNameController =
      TextEditingController(text: "محمد");

  final TextEditingController lastNameController =
      TextEditingController(text: "جلالی");

  final TextEditingController phoneNumberController =
      TextEditingController(text: "09131234567");

  final TextEditingController postalCodeController =
      TextEditingController(text: "1234567890");

  final TextEditingController addressController = TextEditingController(
      text: "asdas asdas dasadff asdasdff asddخیابان شهید مدرس");

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحویل گیرنده"),
        centerTitle: false,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          streamSubscription = bloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.exception.message)));
            } else if (event is ShippingSucess) {
              if (event.result.bankGetwayUrl.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentGatywayScreen(url: event.result.bankGetwayUrl),
                  ),
                );
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PaymentReciptScreen(orderId: event.result.orderId),
                ));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(label: Text("نام ")),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(label: Text("نام خانوادگی ")),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(label: Text("شماره تماس")),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(label: Text("کد پستی")),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(label: Text("آدرس ")),
              ),
              PriceInfo(
                  payablePrice: widget.payablePrice,
                  shippingCost: widget.shippingCost,
                  totalPrice: widget.totalPrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(
                                      createOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          phoneNumberController.text,
                                          postalCodeController.text,
                                          addressController.text,
                                          PaymentMethod.online),
                                    ),
                                  );
                                },
                                child: const Text("پرداخت اینترنتی")),
                            OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(
                                      createOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          phoneNumberController.text,
                                          postalCodeController.text,
                                          addressController.text,
                                          PaymentMethod.cashOnDelivery),
                                    ),
                                  );
                                },
                                child: const Text("پرداخت در محل"))
                          ],
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
