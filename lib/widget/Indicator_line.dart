import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';

class IndicatorLine extends CustomPainter {

  int indicator;

  int sum;
  double length;


  IndicatorLine(this.indicator, this.sum, this.length);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = new Paint()
      ..color = Color(CLS.DIVIDER)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    var paint2 = new Paint()
      ..color = Color(CLS.INDICATOR)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    canvas.drawLine(Offset(0.0, 0.0), Offset(length, 0.0), paint1);

    var left = (indicator - 1) * length / sum;
    var right = (indicator) * length / sum;
    canvas.drawLine(Offset(left, 0.0), Offset(right, 0.0), paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


}