import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Seconds extends StatelessWidget {
  int seconds;
   Seconds({required this.seconds});

  
  @override
  Widget build(BuildContext context) {
    return Text(
      seconds  < 10 ? '0' + seconds.toString() : seconds.toString(),
       style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 16),
    );
  }
}