import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/common/extestion.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text(
            "جزیات خرید",
            style: context.themedata.titleMedium,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1))
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("مبلغ کل خرید"),
                    PriceInfoTextView(totalPrice: totalPrice)
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" هزینه ارسال "),
                    Text(shippingCost.withPriceLabale)
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  مبلغ قایل پرداخت "),
                    PriceInfoTextView(totalPrice: payablePrice)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PriceInfoTextView extends StatelessWidget {
  const PriceInfoTextView({
    super.key,
    required this.totalPrice,
  });

  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: totalPrice.sepratedByComma,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontWeight: FontWeight.bold),
          children: const [
            TextSpan(
                text: ' تومان',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal))
          ]),
    );
  }
}
