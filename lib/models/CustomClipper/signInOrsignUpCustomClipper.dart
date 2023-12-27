import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Эта переменная определена для лучшего понимания, какое значение указать в методе quadraticBezierTo
    var controlPoint = Offset(size.width * 0.7, size.height * 0.9);
    var endPoint = Offset(0, size.height);
    Path path = Path()
      ..moveTo(size.width, 0)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx,
          endPoint.dy) //вершина p1
      ..lineTo(0, size.height) // Добавить отрезок p1p2

      ..lineTo(size.width, size.height)
      // Добавить отрезок p2p3
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
