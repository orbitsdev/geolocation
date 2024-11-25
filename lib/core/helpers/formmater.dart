
import 'package:intl/intl.dart';

/// Formats a number into a currency-like format with commas
String formatNumber(num? value) {
  if (value == null) {
    return '0.00';
  }
  final formatter = NumberFormat('#,##0');
  return formatter.format(value);
}
