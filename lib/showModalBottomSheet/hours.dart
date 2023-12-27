import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Hours extends StatelessWidget {
  int hours;
   Hours({required this.hours});

  
  @override
  Widget build(BuildContext context) {
    return Text(
      hours < 10 ? '0' + hours.toString() : hours.toString(),
       style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 16),
    );
  }
}