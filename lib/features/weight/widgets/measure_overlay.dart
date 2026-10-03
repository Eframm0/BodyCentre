import 'package:flutter/material.dart';

import 'measure_pill.dart';

/// Elemento disegnato sul corpo: centro + estremi della linea (0..1).
class OverlayItem {
  const OverlayItem({
    required this.id,
    required this.label,
    required this.cx,
    required this.cy,
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.cm,
  });

  final int id;
  final String label;
  final double cx;
  final double cy;
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;
  final double? cm;

  OverlayItem movedBy(double dx, double dy) => OverlayItem(
    id: id,
    label: label,
    cx: (cx + dx).clamp(0.02, 0.98),
    cy: (cy + dy).clamp(0.02, 0.98),
    x1: x1 == null ? null : (x1! + dx).clamp(0.0, 1.0),
    y1: y1 == null ? null : (y1! + dy).clamp(0.0, 1.0),
    x2: x2 == null ? null : (x2! + dx).clamp(0.0, 1.0),
    y2: y2 == null ? null : (y2! + dy).clamp(0.0, 1.0),
    cm: cm,
  );
}

/// Livello sovrapposto alla foto: per ogni misura una LINEA che attraversa
/// la parte del corpo e la pill del valore al centro.
///
/// Prestazioni: ogni pill ha un proprio ValueNotifier e il painter è
/// ridisegnato dai listenable — durante il drag NON c'è rebuild della
/// pagina, solo della pill toccata.
class MeasureOverlay extends StatefulWidget {
  const MeasureOverlay({
    super.key,
    required this.items,
    this.onMove,
    this.onLongPress,
    this.smallPills = false,
  });

  final List<OverlayItem> items;

  /// Chiamato a ogni movimento (già mutato nel notifier: qui solo per
  /// persistere la posizione nella mappa/database, senza setState!).
  final void Function(int id, OverlayItem moved)? onMove;
  final void Function(OverlayItem item)? onLongPress;
  final bool smallPills;

  @override
  State<MeasureOverlay> createState() => _MeasureOverlayState();
}

class _MeasureOverlayState extends State<MeasureOverlay> {
  final _notifiers = <int, ValueNotifier<OverlayItem>>{};

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant MeasureOverlay old) {
    super.didUpdateWidget(old);
    _sync();
  }

  @override
  void dispose() {
    for (final n in _notifiers.values) {
      n.dispose();
    }
    super.dispose();
  }

  void _sync() {
    for (final it in widget.items) {
      final existing = _notifiers[it.id];
      if (existing == null) {
        _notifiers[it.id] = ValueNotifier(it);
      } else {
        // Aggiorna i campi non-posizionali (es. cm) mantenendo il sync.
        existing.value = it;
      }
    }
    _notifiers.removeWhere(
      (id, _) => !widget.items.any((i) => i.id == id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final listenables = List<Listenable>.of(_notifiers.values);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Linee: ridisegnate dai listenable, senza rebuild del widget.
            CustomPaint(
              painter: _LinesPainter(
                notifiers: List.of(_notifiers.values),
                repaint: Listenable.merge(listenables),
              ),
              size: Size.infinite,
            ),
            for (final entry in _notifiers.entries)
              AnimatedBuilder(
                animation: entry.value,
                builder: (context, _) {
                  final it = entry.value.value;
                  return Positioned(
                    left: it.cx * w - 7,
                    top: it.cy * h - 7,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onLongPress:
                          widget.onLongPress == null
                              ? null
                              : () => widget.onLongPress!(it),
                      onPanUpdate:
                          widget.onMove == null
                              ? null
                              : (d) {
                                final cur = entry.value.value;
                                final moved = cur.movedBy(
                                  d.delta.dx / w,
                                  d.delta.dy / h,
                                );
                                // Solo il notifier cambia: nessun setState
                                // della pagina, nessun rebuild degli altri.
                                entry.value.value = moved;
                                widget.onMove!(moved.id, moved);
                              },
                      child: MeasurePill(
                        label: it.label,
                        cm: widget.smallPills ? null : it.cm,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

/// Disegna le linee nere con tacche agli estremi. Il repaint è guidato
/// dai ValueNotifier (nessun shouldRepaint su lista nuova).
class _LinesPainter extends CustomPainter {
  _LinesPainter({required this.notifiers, required Listenable repaint})
    : super(repaint: repaint);

  final List<ValueNotifier<OverlayItem>> notifiers;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xD9141414)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round;

    for (final n in notifiers) {
      final it = n.value;
      if (it.x1 == null ||
          it.y1 == null ||
          it.x2 == null ||
          it.y2 == null) {
        continue;
      }
      final p1 = Offset(it.x1! * size.width, it.y1! * size.height);
      final p2 = Offset(it.x2! * size.width, it.y2! * size.height);
      canvas.drawLine(p1, p2, paint);
      final dist = (p2 - p1).distance;
      if (dist == 0) continue;
      final dir = (p2 - p1) / dist;
      final perp = Offset(-dir.dy, dir.dx) * 6;
      canvas.drawLine(p1 - perp, p1 + perp, paint);
      canvas.drawLine(p2 - perp, p2 + perp, paint);
    }
  }

  @override
  bool shouldRepaint(_LinesPainter old) => false;
}
