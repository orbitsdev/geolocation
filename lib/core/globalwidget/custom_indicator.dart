import 'package:flutter/material.dart';

class CustomUnderlineTabIndicator extends Decoration {
  final Color color;
  final double lineHeight;

  CustomUnderlineTabIndicator({required this.color, this.lineHeight = 2.0});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomUnderlinePainter(color, lineHeight);
  }
}

class _CustomUnderlinePainter extends BoxPainter {
  final Paint _paint;
  final double lineHeight;

  _CustomUnderlinePainter(Color color, this.lineHeight)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true
          ..strokeWidth = lineHeight;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double height = configuration.size!.height;
    final double yOffset = height - _paint.strokeWidth;

    // Assuming the text style is applied directly
    final TextStyle textStyle = TextStyle(
      color: _paint.color,
      fontSize: 14.0, // Default text size; should match the Tab's text size
      fontWeight: FontWeight.normal, // Default font weight
    );

    final String? labelText = configuration.toString();
    if (labelText == null) {
      return;
    }

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: configuration.size!.width);

    final double width = textPainter.width;
    final double xOffset = (configuration.size!.width - width) / 2;
    final Offset start = offset + Offset(xOffset, yOffset);
    final Offset end = start + Offset(width, 0);

    canvas.drawLine(start, end, _paint);
  }
}
