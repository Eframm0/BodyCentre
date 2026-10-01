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
                final h = w * 0.40;
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

    // ---- Rettangolo tessuti (compatto, a sinistra) ----
    final rectW = w * 0.40;
    final rectH = h * 0.92;
    final rectLeft = 2.0;
    final rectTop = (h - rectH) / 2;
    final r = rectW * 0.16;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(rectLeft, rectTop, rectW, rectH),
      Radius.circular(r),
    );

    canvas.drawRRect(
      rect.shift(const Offset(1.5, 2)),
      Paint()..color = const Color(0x224A6070),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFF2C9A0));

    // Composizione relativa grasso/muscolo (min 15% per leggibilità).
    final total = fatPct + musclePct;
    final fatShare = total <= 0 ? 0.45 : (fatPct / total).clamp(0.15, 0.85);

    final skinPad = rectW * 0.075;
    final inner = Rect.fromLTWH(
      rect.left + skinPad,
      rect.top + skinPad,
      rect.width - skinPad * 2,
      rect.height - skinPad * 2,
    );
    final innerR = RRect.fromRectAndRadius(inner, Radius.circular(r * 0.7));

    canvas.save();
    canvas.clipRRect(innerR);
    canvas.drawRect(inner, Paint()..color = _muscleDark);

    // Grasso sopra: banda con adipociti.
    final fatBandH = inner.height * fatShare;
    final fatRect = Rect.fromLTWH(inner.left, inner.top, inner.width, fatBandH);
    canvas.drawRect(fatRect, Paint()..color = const Color(0xFFEFD083));
    final cellR = (fatBandH / 3.2).clamp(rectW * 0.055, rectW * 0.11);
    var row = 0;
    for (var cy = fatRect.top + cellR * 1.1;
        cy < fatRect.bottom - cellR * 0.5;
        cy += cellR * 2.0, row++) {
      final off = row.isEven ? 0.0 : cellR;
      for (var cx = fatRect.left + cellR * 1.1 + off;
          cx < fatRect.right - cellR * 0.5;
          cx += cellR * 2.0) {
        final c = Offset(cx, cy);
        canvas.drawCircle(c, cellR, Paint()..color = const Color(0xFFF6DC9B));
        canvas.drawCircle(
          c,
          cellR,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..color = _fatDark,
        );
        canvas.drawCircle(
          c.translate(-cellR * 0.25, -cellR * 0.25),
          cellR * 0.42,
          Paint()..color = const Color(0xFFFAE9C0),
        );
      }
    }

    // Muscolo sotto: fibre orizzontali.
    final mRect = Rect.fromLTWH(
      inner.left,
      inner.top + fatBandH,
      inner.width,
      inner.height - fatBandH,
    );
    final fiberH = (mRect.height / 3.1).clamp(rectW * 0.07, rectW * 0.14);
    var fy = mRect.top + fiberH * 0.3;
    var idx = 0;
    while (fy < mRect.bottom - fiberH * 0.3) {
      final capped = fy + fiberH > mRect.bottom;
      final fh = capped ? mRect.bottom - fy : fiberH;
      if (fh > fiberH * 0.35) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(mRect.left - 2, fy, mRect.width + 4, fh),
            Radius.circular(fh * 0.5),
          ),
          Paint()..color = idx.isEven ? _muscleColor : _muscleDark,
        );
        canvas.drawLine(
          Offset(mRect.left + 2, fy + fh * 0.30),
          Offset(mRect.right - 2, fy + fh * 0.30),
          Paint()
            ..strokeWidth = fh * 0.16
            ..strokeCap = StrokeCap.round
            ..color = const Color(0xFFE08A7E),
        );
      }
      fy += fiberH * 1.12;
      idx++;
    }
    canvas.restore();

    // Contorno pelle
    canvas.drawRRect(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = rectW * 0.045
        ..color = const Color(0xFFD8A25E),
    );

    // ---- Barre a destra (etichetta + valore + barra) ----
    final barX0 = w * 0.52;
    final barX1 = w - 4;
    const barH = 9.0;
    final center1 = h * 0.30;
    final center2 = h * 0.72;

    _drawBar(canvas, fatLabel, fatValue, center1, barX0, barX1, barH,
        _fatDark, fatPct / 50, t);
    _drawBar(canvas, muscleLabel, muscleValue, center2, barX0, barX1, barH,
        _muscleDark, musclePct / 60, t);

    // ---- Indicatori: banda -> barra, allineati per costruzione ----
    _connector(
      canvas,
      Offset(rect.right - rectW * 0.16, fatRect.center.dy),
      Offset(barX0 - 5, center1 + 4 + barH / 2),
      _fatDark,
    );
    _connector(
      canvas,
      Offset(rect.right - rectW * 0.16, mRect.center.dy),
      Offset(barX0 - 5, center2 + 4 + barH / 2),
      _muscleDark,
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

  void _connector(Canvas canvas, Offset from, Offset to, Color color) {
    final mid = Offset((from.dx + to.dx) / 2, from.dy);
    final path =
        Path()
          ..moveTo(from.dx, from.dy)
          ..quadraticBezierTo(mid.dx, from.dy, to.dx, to.dy);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..color = color.withValues(alpha: 0.8),
    );
    canvas.drawCircle(from, 2.8, Paint()..color = color);
    canvas.drawCircle(to, 3.0, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TissuePainter old) =>
      old.t != t || old.fatPct != fatPct || old.musclePct != musclePct;
}
