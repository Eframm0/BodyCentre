import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card "Composizione corporea": un unico painter disegna il rettangolo
/// a bande (grasso sopra con adipociti, muscolo sotto con fibre), le linee
/// di collegamento E le barre con etichette — così gli indicatori sono
/// allineati per costruzione (come richiesto dal design utente).
class BodyCompositionCard extends ConsumerWidget {
  const BodyCompositionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final last = ref.watch(lastWeightEntryProvider);

    final fat = last?.fatPct;
    final muscle = last?.musclePct;

    return ClayCard(
      key: const ValueKey('body-comp-card'),
      color: ClayPalette.card,
      radius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.accessibility_new_rounded,
                  size: 20,
                  color: ClayPalette.accentDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guardFirstGlyph(l.bodyCompTitle),
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
          const SizedBox(height: 12),
          if (fat == null && muscle == null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                guardFirstGlyph(l.noBodyComp),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ClayPalette.textSoft,
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = w * 0.34;
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 650),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, _) => SizedBox(
                    width: w,
                    height: h,
                    child: CustomPaint(
                      painter: _TissuePainter(
                        t: t,
                        fatPct: fat ?? 0,
                        musclePct: muscle ?? 0,
                        fatLabel: l.fatPctLabel,
                        fatValue: fat == null ? null : l.pctValue(fat.toStringAsFixed(1)),
                        muscleLabel: l.musclePctLabel,
                        muscleValue:
                            muscle == null ? null : l.pctValue(muscle.toStringAsFixed(1)),
                      ),
                      size: Size.infinite,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Disegna tutto: rettangolo tessuti (grasso/adipociti sopra, muscolo/fibre
/// sotto), indicatori verso le barre e le barre stesse con etichette.
class _TissuePainter extends CustomPainter {
  _TissuePainter({
    required this.t,
    required this.fatPct,
    required this.musclePct,
    required this.fatLabel,
    required this.muscleLabel,
    this.fatValue,
    this.muscleValue,
  });

  /// 0..1: animazione di caricamento (riempimenti).
  final double t;
  final double fatPct;
  final double musclePct;
  final String fatLabel;
  final String muscleLabel;
  final String? fatValue;
  final String? muscleValue;

  static const _fatDark = Color(0xFFD9A93E);
  static const _muscleColor = Color(0xFFD25A4A);
  static const _muscleDark = Color(0xFFC64F3F);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ---- Blocco muscolare: ~2x piu' largo che alto, 3 bande ondulate ----
    // Centro il blocco nell'area a sinistra delle barre (barX0 = w*0.52).
    final mLeft = (w * 0.50 - w * 0.34) / 2;
    final mTop = h * 0.39;
    final mW = w * 0.34;
    final mH = h * 0.42;
    final mRect = Rect.fromLTWH(mLeft, mTop, mW, mH);
    final mR = mW * 0.10;

    canvas.drawRRect(
      RRect.fromRectAndRadius(mRect, Radius.circular(mR))
          .shift(const Offset(1.5, 2)),
      Paint()..color = const Color(0x224A6070),
    );

    final bands = 3;
    final bandH = mH / bands;
    // Le bande seguono separatori ondulati: le disegno come rettangoli
    // sfalsati che si sovrappongono leggermente.
    for (var b = 0; b < bands; b++) {
      final top = mRect.top + b * bandH;
      final color =
          b.isEven ? _muscleColor : _muscleDark;
      final path = Path()..moveTo(mLeft, top);
      // Separatore ondulato (tratteggio a onde) sul confine superiore.
      const segments = 9;
      for (var i = 0; i <= segments; i++) {
        final x = mLeft + mW * i / segments;
        final y = top + (i.isEven ? 0 : bandH * 0.14) - (b == 0 ? 0 : bandH * 0.07);
        path.lineTo(x, y);
      }
      path.lineTo(mLeft + mW, top + bandH + bandH * 0.14);
      path.lineTo(mLeft, top + bandH + bandH * 0.14);
      path.close();
      canvas.save();
      canvas.clipRRect(RRect.fromRectAndRadius(mRect, Radius.circular(mR)));
      canvas.drawPath(path, Paint()..color = color);
      // Trattini curvi delle fibre (archetti ripetuti in ogni banda).
      final hook =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round
            ..color = b.isEven ? _muscleDark : _muscleColor;
      final hookW = mW / 8;
      for (var hx = mLeft + hookW * 0.6; hx < mRect.right - hookW * 0.4; hx += hookW) {
        for (var hy = top + bandH * 0.28;
            hy < top + bandH * 0.92;
            hy += bandH * 0.42) {
          final arcRect = Rect.fromCenter(
            center: Offset(hx + hookW * 0.25, hy),
            width: hookW * 0.55,
            height: bandH * 0.34,
          );
          canvas.drawArc(arcRect, 3.14159, 3.14159, false, hook);
        }
      }
      canvas.restore();
    }
    // Contorno del blocco
    canvas.drawRRect(
      RRect.fromRectAndRadius(mRect, Radius.circular(mR)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = _muscleDark,
    );

    // ---- Grasso: nido d'ape fitto di adipociti sopra il muscolo ----
    // Cellette piccole SCHIACCATE l'una contro l'altra (impacchettamento
    // esagonale): la dimensione cresce comunque con la % di grasso.
    final cellScale = 0.55 + (fatPct / 100) * 0.9;
    final r = mW * 0.054 * cellScale;
    final dx = r * 1.86; // passo orizzontale: le celle si toccano
    final dy = r * 1.52; // passo verticale: file sovrapposte

    // Il nido d'ape copre TUTTA la larghezza del muscolo, file sfalsate.
    final baseCy = mTop - r * 0.80;
    final rowDefs = <double>[-3 * dy / 2, -dy, -dy / 2, 0.0];
    for (final (rowIdx, cyOff) in rowDefs.indexed) {
      final xOff = rowIdx.isOdd ? dx / 2 : 0.0;
      final startX = mLeft + r * 0.9 + xOff;
      for (var x = startX; x + r * 0.9 < mRect.right; x += dx) {
        _drawFatCell(canvas, Offset(x, baseCy + cyOff), r);
      }
    }

    // ---- Barre a destra ----
    final barX0 = w * 0.52;
    final barX1 = w - 4;
    const barH = 9.0;
    final center1 = h * 0.28;
    final center2 = h * 0.74;

    _drawBar(canvas, fatLabel, fatValue, center1, barX0, barX1, barH,
        _fatDark, fatPct / 50, t);
    _drawBar(canvas, muscleLabel, muscleValue, center2, barX0, barX1, barH,
        _muscleDark, musclePct / 60, t);

    // ---- Collegamenti A GOMITO (come nello schema utente) ----
    // Grasso: dall'ammasso sale, corre a destra e scende sulla barra.
    final fatFrom = Offset(mLeft + mW * 0.92, baseCy - 3 * dy / 2 - r * 0.5);
    final fatTo = Offset(barX0 - 6, center1 + 4 + barH / 2);
    _elbow(canvas, fatFrom, fatTo, -1, _fatDark);
    // Muscolo: dal bordo destro del blocco, orizzontale fino alla barra.
    final muscleFrom = Offset(mRect.right + 2, mRect.center.dy);
    final muscleTo = Offset(barX0 - 6, center2 + 4 + barH / 2);
    _elbow(canvas, muscleFrom, muscleTo, 1, _muscleDark);
  }

  /// Collegamento a gomito: parte orizzontale breve nella direzione
  /// [dir], poi verticale all'altezza dell'arrivo, poi orizzontale.
  void _elbow(Canvas canvas, Offset from, Offset to, int dir, Color color) {
    final midX = from.dx + (to.dx - from.dx) * (dir < 0 ? 0.35 : 0.72);
    final path =
        Path()
          ..moveTo(from.dx, from.dy)
          ..lineTo(midX, from.dy)
          ..lineTo(midX, to.dy)
          ..lineTo(to.dx, to.dy);
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..color = color.withValues(alpha: 0.8);
    canvas.drawPath(path, paint);
    canvas.drawCircle(from, 2.8, Paint()..color = color);
    canvas.drawCircle(to, 3.0, Paint()..color = color);
  }

  void _drawFatCell(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFEFD083));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = _fatDark,
    );
    canvas.drawCircle(
      c.translate(-r * 0.25, -r * 0.25),
      r * 0.40,
      Paint()..color = const Color(0xFFFAE9C0),
    );
  }

  void _drawBar(
    Canvas canvas,
    String label,
    String? value,
    double centerY,
    double x0,
    double x1,
    double barH,
    Color color,
    double ratio,
    double t,
  ) {
    _text(canvas, guardFirstGlyph(label), Offset(x0, centerY - 14), 11.5,
        FontWeight.w800, ClayPalette.text);
    if (value != null) {
      _text(canvas, value, Offset(x1, centerY - 14), 10.5, FontWeight.w700,
          ClayPalette.textSoft, alignLeft: false);
    }
    final track = Rect.fromLTWH(x0, centerY + 4, x1 - x0, barH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(track, Radius.circular(barH / 2)),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );
    final fillW = (x1 - x0) * ratio.clamp(0, 1) * t;
    if (fillW > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x0, centerY + 4, fillW, barH),
          Radius.circular(barH / 2),
        ),
        Paint()..color = color,
      );
    }
  }

  void _text(
    Canvas canvas,
    String s,
    Offset at,
    double size,
    FontWeight weight,
    Color color, {
    bool alignLeft = true,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: size,
          fontWeight: weight,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, alignLeft ? at : at - Offset(tp.width, 0));
  }

  @override
  bool shouldRepaint(_TissuePainter old) =>
      old.t != t || old.fatPct != fatPct || old.musclePct != musclePct;
}
