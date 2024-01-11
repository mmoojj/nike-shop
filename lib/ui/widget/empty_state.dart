import 'package:flutter/material.dart';
import 'package:nike_shop/common/extestion.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final Widget? callToAction;
  final Widget image;

  const EmptyView(
      {super.key,
      required this.message,
       this.callToAction,
      required this.image});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image,
          Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 32, top: 24, bottom: 16),
            child: Text(
              message,
              style: context.themedata.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          if ( callToAction !=null) callToAction!
        ],
      ),
    );
  }
}
