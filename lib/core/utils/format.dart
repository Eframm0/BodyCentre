import 'package:intl/intl.dart';

/// Formattatori numerici (locale italiana: virgola decimale, punto migliaia).
final NumberFormat _kgFmt = NumberFormat('#,##0.0', 'it');
final NumberFormat _intFmt = NumberFormat('#,##0', 'it');

/// 78.25 → "78,3"
String formatKg(double value) => _kgFmt.format(value);

/// 1850 → "1.850"
String formatKcal(num value) => _intFmt.format(value);

/// -1.3 → "−1,3" (segno matematico, sempre esplicito)
String formatDelta(double value) =>
    '${value < 0 ? '−' : '+'}${_kgFmt.format(value.abs())}';
