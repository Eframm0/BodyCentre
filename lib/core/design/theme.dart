import 'package:flutter/material.dart';

import 'palette.dart';

/// Tema chiaro claymorphism dell'app.
///
/// Le superfici "clay" non passano dal ThemeData ma dai widget in clay.dart
/// (ClayCard & co.): il tema definisce sfondo, colori di base e tipografia
/// (Nunito per il corpo, Baloo2 per titoli e numeri — vedi [baloo]).
ThemeData buildTheme() {
  final base = ThemeData(brightness: Brightness.light, useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: ClayPalette.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ClayPalette.accent,
    ).copyWith(surface: ClayPalette.bg, onSurface: ClayPalette.text),
    textTheme: base.textTheme.apply(
      bodyColor: ClayPalette.text,
      displayColor: ClayPalette.text,
      fontFamily: 'Nunito',
    ),
    tooltipTheme: const TooltipThemeData(
      textStyle: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}

/// Stile testo display (Baloo2): titoli di sezione e numeri grandi.
TextStyle baloo({
  double size = 24,
  FontWeight weight = FontWeight.w700,
  Color color = ClayPalette.text,
  double height = 1.15,
}) => TextStyle(
  fontFamily: 'Baloo2',
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
);
