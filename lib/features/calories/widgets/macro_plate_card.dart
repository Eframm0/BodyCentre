import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card "il piatto": illustrazione centrale (pollo, pane, insalata, olio)
/// con linee di collegamento alle quattro barre dei macronutrienti.
/// Toccare il piatto apre l'aggiunta pasti.
class MacroPlateCard extends ConsumerWidget {
  const MacroPlateCard({
    super.key,
    required this.totals,
    required this.onPlateTap,
  });

  final DayTotals totals;
  final VoidCallback onPlateTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final kcalTarget = ref.watch(dailyKcalTargetProvider);
    final targets = MacroTargets.fromKcal(kcalTarget);

    final bars = [
      _MacroBar(
        label: l.macroProtein,
        color: const Color(0xFF8D5A3B),
        eaten: totals.protein,
        target: targets.protein,
      ),
      _MacroBar(
        label: l.macroCarbs,
        color: const Color(0xFFC98F4E),
        eaten: totals.carbs,
        target: targets.carbs,
      ),
      _MacroBar(
        label: l.macroFiber,
        color: const Color(0xFF5FA86F),
        eaten: totals.fiber,
        target: targets.fiber,
      ),
      _MacroBar(
        label: l.macroFat,
        color: const Color(0xFFE0A93E),
        eaten: totals.fat,
        target: targets.fat,
      ),
    ];

    return ClayCard(
      key: const ValueKey('macro-plate-card'),
      radius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // Riepilogo kcal del giorno (indentato: il primo elemento al
          // bordo sinistro subisce il taglio del renderer del device).
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
            children: [
              // Micro-nudge richiesto: icona leggermente più a destra
              // e in basso rispetto al testo.
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 2),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 20,
                  color: ClayPalette.accentDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  guardFirstGlyph(
                    l.kcalOfDay(
                      formatKcal(totals.kcal.round()),
                      formatKcal(kcalTarget),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: ClayPalette.text,
                  ),
                ),
              ),
            ],
          ),
          ),
          const SizedBox(height: 10),
          ClayProgress(
            fraction: totals.kcal / kcalTarget,
            height: 12,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Piatto illustrato (toccabile)
              Expanded(
                flex: 11,
                child: ClayPressable(
                  onTap: onPlateTap,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 0.92,
                        child: CustomPaint(
                          painter: _PlatePainter(),
                          size: Size.infinite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Indentata a destra: la T iniziale veniva parzialmente
                      // tagliata dal bug del bordo sinistro del device.
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          guardFirstGlyph(l.tapPlateToAdd),
                          textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: ClayPalette.textSoft,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Barre macro (l'ordine segue i cibi del piatto)
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final bar in bars) ...[
                      bar,
                      if (bar != bars.last) const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Barra di un macronutriente: lunghezza = consumato/obiettivo.
/// Oltre il 100% diventa scura (eccesso).
class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.color,
    required this.eaten,
    required this.target,
  });

  final String label;
  final Color color;
  final double eaten;
  final double target;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ratio = target <= 0 ? 0.0 : eaten / target;
    final over = ratio > 1.0;
    final barColor = over ? const Color(0xFF2A2A33) : color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                guardFirstGlyph(label),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: ClayPalette.text,
                ),
              ),
            ),
            Text(
              l.macroGrams(
                eaten <= 99 ? eaten.round().toString() : eaten.round().toString(),
                target.round().toString(),
              ),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: over ? const Color(0xFF2A2A33) : ClayPalette.textSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: ratio.clamp(0, 1)),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => LinearProgressIndicator(
            value: value,
            minHeight: 10.5,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: Colors.white.withValues(alpha: 0.6),
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}

/// Illustrazione: piatto con pollo, pane, insalata e olio, e linee di
/// collegamento verso destra (verso le barre macro). Stile clay flat.
class _PlatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.44;
    final cy = h * 0.52;
    final plateR = w * 0.33;

    // Punti di arrivo dei collegamenti (bordo destro) in ordine:
    // proteine, carboidrati, fibra, grassi.
    final ends = [h * 0.12, h * 0.38, h * 0.63, h * 0.88];

    // Ombra morbida del piatto
    canvas.drawCircle(
      Offset(cx + plateR * 0.08, cy + plateR * 0.1),
      plateR,
      Paint()..color = const Color(0x224A6070),
    );
    // Piatto
    canvas.drawCircle(
      Offset(cx, cy),
      plateR,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      plateR * 0.72,
      Paint()..color = const Color(0xFFF3FAF8),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      plateR * 0.7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = const Color(0x332FA8A0),
    );

    // ---- Cibi attorno al piatto + collegamenti ----
    // Pollo (alto): proteine
    final chicken = Offset(cx, cy - plateR * 1.02);
    _drawChicken(canvas, chicken, w * 0.095);
    _connector(canvas, chicken.translate(w * 0.05, -w * 0.05), Offset(w - 3, ends[0]));

    // Pane (destra alto): carboidrati
    final bread = Offset(cx + plateR * 1.05, cy - plateR * 0.28);
    _drawBread(canvas, bread, w * 0.10);
    _connector(canvas, bread.translate(w * 0.06, 0), Offset(w - 3, ends[1]));

    // Insalata (destra basso): fibra
    final salad = Offset(cx + plateR * 1.02, cy + plateR * 0.5);
    _drawSalad(canvas, salad, w * 0.095);
    _connector(canvas, salad.translate(w * 0.06, 0), Offset(w - 3, ends[2]));

    // Olio (basso): grassi
    final oil = Offset(cx - plateR * 0.1, cy + plateR * 1.02);
    _drawOil(canvas, oil, w * 0.08);
    _connector(canvas, oil.translate(0, w * 0.05), Offset(w - 3, ends[3]));
  }

  void _connector(Canvas canvas, Offset from, Offset to) {
    final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
    final path =
        Path()
          ..moveTo(from.dx, from.dy)
          ..quadraticBezierTo(mid.dx + 14, from.dy, to.dx, to.dy);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = const Color(0x556B8A96),
    );
    canvas.drawCircle(to.translate(-1, 0), 2.4, Paint()..color = const Color(0x886B8A96));
  }

  void _drawChicken(Canvas canvas, Offset c, double r) {
    // Coscia di pollo: polpa marrone + osso bianco
    final meat =
        Path()
          ..addOval(Rect.fromCenter(center: c, width: r * 2.2, height: r * 1.8));
    canvas.drawPath(meat, Paint()..color = const Color(0xFFB5743F));
    // Riflesso
    canvas.drawCircle(
      c.translate(-r * 0.3, -r * 0.35),
      r * 0.28,
      Paint()..color = const Color(0xFFD19A66),
    );
    // Osso
    final bonePaint = Paint()..color = Colors.white;
    final boneStart = c.translate(r * 0.75, r * 0.55);
    canvas.drawLine(
      boneStart,
      boneStart.translate(r * 0.75, r * 0.55),
      bonePaint..strokeWidth = r * 0.28..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      boneStart.translate(r * 1.35, r * 0.35),
      r * 0.22,
      bonePaint,
    );
  }

  void _drawBread(Canvas canvas, Offset c, double r) {
    // Fetta di pane: quadrato arrotondato crosta + mollica
    final crust =
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: c, width: r * 2.0, height: r * 1.9),
              Radius.circular(r * 0.45),
            ),
          );
    canvas.drawPath(crust, Paint()..color = const Color(0xFFD8A25E));
    final crumb =
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: c.translate(-r * 0.06, -r * 0.04), width: r * 1.5, height: r * 1.4),
              Radius.circular(r * 0.3),
            ),
          );
    canvas.drawPath(crumb, Paint()..color = const Color(0xFFF6E3BF));
  }

  void _drawSalad(Canvas canvas, Offset c, double r) {
    // Insalata: ciuffi verdi sovrapposti
    final green1 = const Color(0xFF6FBF7E);
    final green2 = const Color(0xFF4E9E5F);
    canvas.drawCircle(c.translate(-r * 0.55, r * 0.1), r * 0.62, Paint()..color = green1);
    canvas.drawCircle(c.translate(r * 0.5, r * 0.15), r * 0.58, Paint()..color = green1);
    canvas.drawCircle(c.translate(0, -r * 0.3), r * 0.75, Paint()..color = green2);
    canvas.drawCircle(c.translate(-r * 0.1, -r * 0.5), r * 0.4, Paint()..color = const Color(0xFF8ED69B));
  }

  void _drawOil(Canvas canvas, Offset c, double r) {
    // Goccia d'olio ambrata
    final drop =
        Path()
          ..moveTo(c.dx, c.dy - r)
          ..quadraticBezierTo(c.dx + r * 0.95, c.dy + r * 0.1, c.dx, c.dy + r)
          ..quadraticBezierTo(c.dx - r * 0.95, c.dy + r * 0.1, c.dx, c.dy - r)
          ..close();
    canvas.drawPath(drop, Paint()..color = const Color(0xFFE8B84B));
    canvas.drawCircle(
      c.translate(-r * 0.25, r * 0.25),
      r * 0.22,
      Paint()..color = const Color(0xFFF5D98B),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
