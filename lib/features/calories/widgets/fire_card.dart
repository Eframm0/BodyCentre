import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card "calorie bruciate": fiamma animata la cui altezza e intensità
/// crescono con le kcal bruciate; dopo l'animazione si rivelano le
/// specifiche (passi, allenamenti).
class FireCard extends ConsumerStatefulWidget {
  const FireCard({super.key});

  @override
  ConsumerState<FireCard> createState() => _FireCardState();
}

class _FireCardState extends ConsumerState<FireCard>
    with TickerProviderStateMixin {
  late final AnimationController _flame =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
        ..repeat(reverse: true);

  /// Comparse delle specifiche dopo l'animazione iniziale della fiamma:
  /// timeline unica (2000 ms) in cui il reveal occupa l'ultimo 25%, così
  /// non servono timer pendenti.
  late final AnimationController _reveal =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
        ..forward();

  @override
  void dispose() {
    _flame.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final burned = ref.watch(burnedKcalProvider);
    // Intensità 0..1: 0 kcal = fiammella minima, 800+ kcal = fiamma piena.
    final intensity = (burned / 800).clamp(0.0, 1.0);

    return ClayCard(
      key: const ValueKey('fire-card'),
      color: ClayPalette.calories,
      radius: 28,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            // Indentato: primo elemento al bordo sinistro (taglio device).
            padding: const EdgeInsets.only(left: 10),
            child: Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 20,
                color: ClayPalette.accentDark,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  guardFirstGlyph(l.burnedTitle),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: ClayPalette.text,
                  ),
                ),
              ),
              Text(
                l.burnedKcal(formatKcal(burned)),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: ClayPalette.textSoft,
                ),
              ),
            ],
          ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _flame,
              builder: (context, _) => CustomPaint(
                painter: _FlamePainter(
                  progress: _flame.value,
                  intensity: intensity,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          // Specifiche: compaiono dopo la prima animazione della fiamma
          // (ultimo 25% della timeline del controller _reveal).
          FadeTransition(
            opacity: CurvedAnimation(
              parent: _reveal,
              curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
            ),
            child: Column(
              children: [
                _BurnedRow(
                  icon: Icons.directions_walk_rounded,
                  label: l.burnedSteps,
                  kcal: 0,
                ),
                const SizedBox(height: 6),
                _BurnedRow(
                  icon: Icons.fitness_center_rounded,
                  label: l.burnedWorkout,
                  kcal: 0,
                ),
                const SizedBox(height: 10),
                Text(
                  guardFirstGlyph(l.burnedHint),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: ClayPalette.textSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BurnedRow extends StatelessWidget {
  const _BurnedRow({required this.icon, required this.label, required this.kcal});

  final IconData icon;
  final String label;
  final int kcal;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.55),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ClayPalette.accentDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              guardFirstGlyph(label),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: ClayPalette.text,
              ),
            ),
          ),
          Text(
            l.burnedKcal(formatKcal(kcal)),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: ClayPalette.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fiamma: altezza e colore dipendono dall'intensità; il progress fa
/// "sfarfallare" la punta.
class _FlamePainter extends CustomPainter {
  _FlamePainter({required this.progress, required this.intensity});

  final double progress;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final baseY = size.height * 0.92;
    // Altezza: da fiammella (28%) a fiamma piena (95%).
    final flick = math.sin(progress * math.pi * 2) * 0.05;
    final hFactor = 0.28 + 0.67 * intensity + flick;
    final flameH = size.height * hFactor;
    // Larghezza: da 30% a 65% dell'altezza.
    final flameW = size.width * (0.16 + 0.16 * intensity);

    final path = Path();
    path.moveTo(cx, baseY - flameH);
    path.quadraticBezierTo(
      cx + flameW * 0.7,
      baseY - flameH * 0.55,
      cx + flameW,
      baseY - flameH * 0.28,
    );
    path.quadraticBezierTo(cx + flameW * 1.05, baseY, cx, baseY);
    path.quadraticBezierTo(cx - flameW * 1.05, baseY, cx - flameW, baseY - flameH * 0.28);
    path.quadraticBezierTo(
      cx - flameW * 0.7,
      baseY - flameH * 0.55,
      cx,
      baseY - flameH,
    );

    // Colore: ambra spenta -> arancio vivo con l'intensità.
    final color = Color.lerp(const Color(0xFFE8B84B), const Color(0xFFF2622A), intensity)!;

    // Glow
    canvas.drawCircle(
      Offset(cx, baseY - flameH * 0.45),
      flameW * 1.7,
      Paint()..color = color.withValues(alpha: 0.16 + 0.12 * intensity),
    );
    canvas.drawPath(path, Paint()..color = color);

    // Nucleo interno più chiaro
    canvas.drawPath(
      Path()
        ..moveTo(cx, baseY - flameH * 0.62)
        ..quadraticBezierTo(
          cx + flameW * 0.34,
          baseY - flameH * 0.32,
          cx,
          baseY - flameH * 0.05,
        )
        ..quadraticBezierTo(
          cx - flameW * 0.34,
          baseY - flameH * 0.32,
          cx,
          baseY - flameH * 0.62,
        ),
      Paint()..color = const Color(0xFFFFD98A).withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_FlamePainter old) =>
      old.progress != progress || old.intensity != intensity;
}
