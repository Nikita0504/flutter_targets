import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Minutes extends StatelessWidget {
  int minutes;
   Minutes({required this.minutes});

  
  @override
  Widget build(BuildContext context) {
    return Text(
      minutes < 10 ? '0' + minutes.toString() : minutes.toString(),
       style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(fontSize: 16),
    );
  }
}