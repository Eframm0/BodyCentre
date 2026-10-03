import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card "Trend circonferenze" (prototipo): per ogni punto di misura la
/// serie storica in cm come sparkline, con ultimo valore e delta.
class TrendMeasuresCard extends ConsumerStatefulWidget {
  const TrendMeasuresCard({super.key});

  @override
  ConsumerState<TrendMeasuresCard> createState() => _TrendMeasuresCardState();
}

class _TrendMeasuresCardState extends ConsumerState<TrendMeasuresCard> {
  List<MeasureSeries> _series = [];
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final series = await db.getMeasurementSeries();
    if (!mounted) return;
    setState(() {
      _series = series;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Ricarica quando cambia l'ultima rilevazione.
    ref.listen(lastWeightEntryProvider, (_, _) => _load());

    return ClayCard(
      key: const ValueKey('trend-measures-card'),
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
                  Icons.query_stats_rounded,
                  size: 20,
                  color: ClayPalette.accentDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guardFirstGlyph(l.trendMeasuresTitle),
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
          if (!_loaded)
            const SizedBox(height: 4)
          else if (_series.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                guardFirstGlyph(l.noMeasures),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ClayPalette.textSoft,
                ),
              ),
            )
          else
            for (final s in _series)
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: _TrendRow(series: s),
              ),
        ],
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({required this.series});

  final MeasureSeries series;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final values = series.values;
    final last = values.last.$2;
    final first = values.first.$2;
    final delta = values.length > 1 ? last - first : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.55),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              guardFirstGlyph(series.label),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ClayPalette.text,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 26,
              child: CustomPaint(
                painter: _SparkPainter(values: [for (final v in values) v.$2]),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l.cmValue(last.toStringAsFixed(0)),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: ClayPalette.accentDark,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(width: 6),
            Text(
              formatDelta(delta),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color:
                    delta <= 0
                        ? ClayPalette.accentDark
                        : const Color(0xFFD25A4A),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Sparkline minima della serie (tinta teal, area leggera).
class _SparkPainter extends CustomPainter {
  _SparkPainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    if (values.length == 1) {
      // Un solo dato: puntino al centro.
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        2.6,
        Paint()..color = ClayPalette.accent,
      );
      return;
    }
    var minV = values.reduce((a, b) => a < b ? a : b);
    var maxV = values.reduce((a, b) => a > b ? a : b);
    if (maxV - minV < 0.01) {
      minV -= 1;
      maxV += 1;
    }
    final w = size.width;
    final h = size.height - 4;
    Offset point(int i) => Offset(
      i / (values.length - 1) * w,
      h - (values[i] - minV) / (maxV - minV) * h + 2,
    );

    // Area sotto la curva.
    final area =
        Path()
          ..moveTo(point(0).dx, point(0).dy)
          ..lineTo(point(0).dx, size.height)
          ..lineTo(point(values.length - 1).dx, size.height)
          ..close();
    canvas.drawPath(
      area,
      Paint()..color = ClayPalette.accent.withValues(alpha: 0.10),
    );

    // Linea spezzata (più leggibile su poche misure).
    final seg =
        Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < values.length; i++) {
      seg.lineTo(point(i).dx, point(i).dy);
    }
    canvas.drawPath(
      seg,
      Paint()
        ..color = ClayPalette.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // Ultimo punto evidenziato.
    final lastPoint = point(values.length - 1);
    canvas.drawCircle(
      lastPoint,
      3.2,
      Paint()..color = ClayPalette.accent,
    );
    canvas.drawCircle(
      lastPoint,
      3.2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(_SparkPainter old) => old.values != values;
}
