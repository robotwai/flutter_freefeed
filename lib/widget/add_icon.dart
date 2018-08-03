import 'package:flutter/material.dart';
//绘制虚线暂时还不支持
class AddIconPainter extends CustomPainter{
  double length;
  AddIconPainter(this.length);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0.0, 0.0), Offset(length, 0.0), paint);
    canvas.drawLine(Offset(length, 0.0), Offset(length, length), paint);
    canvas.drawLine(Offset(length, length), Offset(0.0, length), paint);
    canvas.drawLine(Offset(0.0, length), Offset(0.0, 0.0), paint);
    canvas.drawLine(Offset(length/2, length/4), Offset(length/2, 3*length/4), paint);
    canvas.drawLine(Offset(length/4, length/2), Offset(3*length/4, length/2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }


}