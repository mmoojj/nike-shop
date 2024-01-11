import 'package:flutter/material.dart';

class BadgeCart extends StatelessWidget{
  final int value;

  const BadgeCart({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value > 0,
      child: Container(
        alignment: Alignment.center,
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Text(value.toString() , style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12
        ),),
      ),
    );
  }

}