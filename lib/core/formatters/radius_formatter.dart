import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RadiusInputFormatter extends TextInputFormatter {
  final double min;
  final double max;

  RadiusInputFormatter({this.min = 50, this.max = 1000});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? value = double.tryParse(newValue.text);
    if (value == null || value < min || value > max) {
      return oldValue; // Keep the old value if the new one is invalid
    }

    return newValue; // Accept valid value
  }
}
