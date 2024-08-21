import 'package:flutter/material.dart';

class CustomTabIndicator2 extends Decoration {
  final Color backgroundColor;
  final Color textColor;
  final double lineHeight;
  final EdgeInsetsGeometry padding;

  CustomTabIndicator2({
    required this.backgroundColor,
    required this.textColor,
    this.lineHeight = 2.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomUnderlinePainter(backgroundColor, textColor, lineHeight, padding);
  }
}

class _CustomUnderlinePainter extends BoxPainter {
  final Paint _paint;
  final Color textColor;
  final double lineHeight;
  final EdgeInsetsGeometry padding;

  _CustomUnderlinePainter(
    Color backgroundColor,
    this.textColor,
    this.lineHeight,
    this.padding,
  ) : _paint = Paint()
      ..color = backgroundColor
      ..isAntiAlias = true
      ..strokeWidth = lineHeight;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double height = configuration.size!.height;
    final double yOffset = height - _paint.strokeWidth;

    // Assuming the text style is applied directly
    final TextStyle textStyle = TextStyle(
      color: textColor,
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

    final Rect rect = Rect.fromPoints(start, end).inflate(padding.horizontal);
    canvas.drawRect(rect, _paint);
  }
}