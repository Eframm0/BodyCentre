import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/ml/pose_service.dart';
import 'measure_overlay.dart';

/// Anteprima foto interattiva del pannelo rilevazione: linee di misura e
/// pill trascinabili sui punti rilevati, tap sulla foto per aggiungerne.
class InteractivePreview extends StatelessWidget {
  const InteractivePreview({
    super.key,
    required this.absPath,
    required this.positions,
    required this.points,
    required this.cmOf,
    this.onMove,
    required this.onTap,
  });

  final String absPath;
  final Map<String, MeasurePos> positions;
  final List<MeasurementPoint> points;
  final double? Function(int pointId) cmOf;
  final void Function(String key, MeasurePos pos)? onMove;
  final void Function(double x, double y) onTap;

  @override
  Widget build(BuildContext context) {
    // Locale per la promotion dei null (i field non promuovono).
    final move = onMove;
    final items = [
      for (final p in points)
        if (positions.containsKey(p.key))
          OverlayItem(
            id: p.id,
            label: p.label,
            cx: positions[p.key]!.cx,
            cy: positions[p.key]!.cy,
            x1: positions[p.key]!.x1,
            y1: positions[p.key]!.y1,
            x2: positions[p.key]!.x2,
            y2: positions[p.key]!.y2,
            cm: cmOf(p.id),
          ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const h = 210.0;
        return SizedBox(
          height: h,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    final pos = details.localPosition;
                    onTap(
                      (pos.dx / w).clamp(0.02, 0.98),
                      (pos.dy / h).clamp(0.02, 0.98),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(absPath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MeasureOverlay(
                    items: items,
                    onMove:
                        move == null
                            ? null
                            : (id, moved) => move(
                              points.firstWhere((p) => p.id == id).key,
                              MeasurePos(
                                moved.cx,
                                moved.cy,
                                moved.x1,
                                moved.y1,
                                moved.x2,
                                moved.y2,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
