import 'package:flutter/material.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/common/strings.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback ontap;
  const AppErrorWidget({
    super.key,
    required this.exception,
    required this.ontap
  });

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(exception.message),
          ElevatedButton(
              onPressed: ontap ,
              child: const Text(
                refreshBtnMessage,
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
