import 'package:flutter/material.dart';

import '../../../core/design/palette.dart';
import '../../../core/utils/text_guard.dart';

/// Pill di misura sulla foto (etichetta + cm opzionali), trascinabile.
/// Condivisa tra pannelo rilevazione e card foto.
class MeasurePill extends StatelessWidget {
  const MeasurePill({super.key, required this.label, this.cm});

  final String label;
  final double? cm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ClayPalette.accent, width: 1.3),
        boxShadow: const [
          BoxShadow(color: ClayPalette.shadow, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ClayPalette.accent,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            cm == null
                ? guardFirstGlyph(label)
                : '${guardFirstGlyph(label)} · ${cm!.toStringAsFixed(0)} cm',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: ClayPalette.accentDark,
            ),
          ),
        ],
      ),
    );
  }
}
