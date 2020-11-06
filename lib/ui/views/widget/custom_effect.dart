import 'package:flutter/material.dart';

class CustomToolbarShape extends CustomPainter {
  final Color lineColor;

  const CustomToolbarShape({this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

//First oval
    Path path = Path();
    Rect pathGradientRect = new Rect.fromCircle(
      center: new Offset(size.width / 4, 0),
      radius: size.width / 1.4,
    );

    Gradient gradient = new LinearGradient(
      colors: <Color>[
        // Color.fromRGBO(225, 89, 89, 1).withOpacity(1),
        // Color.fromRGBO(255, 128, 16, 1).withOpacity(1),
        Colors.pink[700],
        Colors.pink[800],
      ],
      stops: [
        0.3,
        1.0,
      ],
    );

    path.lineTo(-size.width / 1.4, 0);
    path.quadraticBezierTo(
        size.width / 2, size.height * 2, size.width + size.width / 1.4, 0);

    paint.color = Colors.pink[800];
    paint.shader = gradient.createShader(pathGradientRect);
    paint.strokeWidth = 40;
    path.close();

    canvas.drawPath(path, paint);

//Second oval
    Rect secondOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 1.5),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Colors.pink[800],
        Colors.pink[700],

        // Color.fromRGBO(225, 255, 255, 1).withOpacity(0.1),
        // Color.fromRGBO(255, 206, 31, 1).withOpacity(0.2),
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    Paint secondOvalPaint = Paint()
      ..color = Colors.pink[800]
      ..color = Colors.pink[600]
      ..shader = gradient.createShader(secondOvalRect);

    canvas.drawOval(secondOvalRect, secondOvalPaint);

//Third oval
    Rect thirdOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 2.7),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        // Color.fromRGBO(225, 255, 255, 1).withOpacity(0.05),
        // Color.fromRGBO(255, 196, 21, 1).withOpacity(0.2),
        Colors.pink[800],
        Colors.pink[700],
      ],
      stops: [
        0.0,
        1.0,
      ],
    );
    Paint thirdOvalPaint = Paint()
      ..color = Colors.pink[800]
      ..shader = gradient.createShader(thirdOvalRect);

    canvas.drawOval(thirdOvalRect, thirdOvalPaint);

//Fourth oval
    Rect fourthOvalRect = new Rect.fromPoints(
      Offset(-size.width / 2.6, -size.width / 1.875),
      Offset(size.width / 1.15, size.height / 1.14),
    );

    gradient = new LinearGradient(
      colors: <Color>[
        Colors.pink[500].withOpacity(0.9),
        Colors.pink[600].withOpacity(0.8),
        // Colors.red.withOpacity(0.9),
        // Color.fromRGBO(255, 128, 16, 1).withOpacity(0.3),
      ],
      stops: [
        0.3,
        1.0,
      ],
    );
    Paint fourthOvalPaint = Paint()
      ..color = Colors.pink[900]
      ..shader = gradient.createShader(fourthOvalRect);

    canvas.drawOval(fourthOvalRect, fourthOvalPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
