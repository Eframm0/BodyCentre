import 'package:flutter/material.dart';

/// Palette "Menta & Azzurro" — claymorphism, tema chiaro.
/// Scelta confermata dall'utente (vedi PROGETTAZIONE.md §10 e
/// anteprima_palette.html). Il tema scuro è rimandato a una fase successiva.
abstract final class ClayPalette {
  /// Sfondo app.
  static const bg = Color(0xFFE9F3F7);

  /// Card generiche (Home).
  static const card = Color(0xFFD6EEF5);

  /// Card sezione Calorie.
  static const calories = Color(0xFFFFF3D6);

  /// Card sezione Peso forma.
  static const weight = Color(0xFFD9F2E5);

  /// Card sezione Allenamento.
  static const workout = Color(0xFFDCE9FA);

  /// Colore accento principale.
  static const accent = Color(0xFF2FA8A0);

  /// Accento scuro (testo/icona su superfici chiare).
  static const accentDark = Color(0xFF1F7A74);

  /// Ambra per le calorie "assunte".
  static const amber = Color(0xFFF2A93B);

  /// Testo principale.
  static const text = Color(0xFF1F3A44);

  /// Testo secondario (60% testo).
  static const textSoft = Color(0x991F3A44);

  /// Ombra clay (grigio-blu al 20%).
  static const shadow = Color(0x334A6070);
}
