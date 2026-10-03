import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/ml/pose_service.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'measure_overlay.dart';

/// Editor a tutto schermo delle posizioni dei punti di misura.
///
/// Prestazioni: la mappa delle posizioni è mutata PER RIFERIMENTO (il
/// pannelo chiamante non fa setState durante il drag), e la foto è un
/// widget istanza cache (identico a ogni build → Flutter salta il
/// rebuild del sottoalbero durante il drag).
class FullScreenMeasureEditor extends StatefulWidget {
  const FullScreenMeasureEditor({
    super.key,
    required this.absPath,
    required this.positions,
    required this.points,
    required this.cmOf,
    required this.onAddPoint,
  });

  final String absPath;

  /// Mappa condivisa con il pannelo: viene mutata direttamente.
  final Map<String, MeasurePos> positions;
  final List<MeasurementPoint> points;
  final double? Function(int pointId) cmOf;
  final Future<void> Function(double x, double y) onAddPoint;

  @override
  State<FullScreenMeasureEditor> createState() =>
      _FullScreenMeasureEditorState();
}

class _FullScreenMeasureEditorState extends State<FullScreenMeasureEditor> {
  late Size _imageSize = Size.zero;

  /// Foto come istanza fissa: durante il drag setState ricostruisce la
  /// pagina ma questo sottoalbero resta identico → zero rebuild/raster.
  late final Widget _photoLayer = RepaintBoundary(
    child: Image.file(File(widget.absPath), fit: BoxFit.fill),
  );

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  Future<void> _loadImageSize() async {
    final bytes = await File(widget.absPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    if (mounted) {
      setState(
        () => _imageSize = Size(
          frame.image.width.toDouble(),
          frame.image.height.toDouble(),
        ),
      );
    }
    frame.image.dispose();
  }

  Future<void> _addPoint(Offset local, Rect imageRect) async {
    final x = ((local.dx - imageRect.left) / imageRect.width).clamp(0.02, 0.98);
    final y = ((local.dy - imageRect.top) / imageRect.height).clamp(0.02, 0.98);
    await widget.onAddPoint(x, y);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final items = [
      for (final p in widget.points)
        if (widget.positions.containsKey(p.key))
          OverlayItem(
            id: p.id,
            label: p.label,
            cx: widget.positions[p.key]!.cx,
            cy: widget.positions[p.key]!.cy,
            x1: widget.positions[p.key]!.x1,
            y1: widget.positions[p.key]!.y1,
            x2: widget.positions[p.key]!.x2,
            y2: widget.positions[p.key]!.y2,
            cm: widget.cmOf(p.id),
          ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_imageSize != Size.zero)
              LayoutBuilder(
                builder: (context, constraints) {
                  final fitted = applyBoxFit(
                    BoxFit.contain,
                    _imageSize,
                    Size(constraints.maxWidth, constraints.maxHeight - 60),
                  );
                  final rect = Rect.fromLTWH(
                    (constraints.maxWidth - fitted.destination.width) / 2,
                    30,
                    fitted.destination.width,
                    fitted.destination.height,
                  );
                  return Stack(
                    children: [
                      Positioned.fromRect(
                        rect: rect,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (d) => _addPoint(d.localPosition, rect),
                          child: _photoLayer,
                        ),
                      ),
                      Positioned.fromRect(
                        rect: rect,
                        child: MeasureOverlay(
                          items: items,
                          onMove: (id, moved) {
                            final key = widget.points
                                .firstWhere((p) => p.id == id)
                                .key;
                            // Mutazione della mappa condivisa e basta: la
                            // pill si muove già via ValueNotifier, nessun
                            // rebuild di pagina durante il drag.
                            widget.positions[key] = MeasurePos(
                              moved.cx,
                              moved.cy,
                              moved.x1,
                              moved.y1,
                              moved.x2,
                              moved.y2,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    guardFirstGlyph(l.dragHint),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
