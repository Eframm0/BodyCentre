import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/ml/pose_service.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/photos.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'add_point_dialog.dart';
import 'measure_overlay.dart';

/// Misura mostrata sulla foto (con posizione della freccia).
class _ShownMeasure {
  const _ShownMeasure({
    required this.measurementId,
    required this.pointId,
    required this.pointKey,
    required this.label,
    required this.cm,
    required this.x,
    required this.y,
    this.x1,
    this.y1,
    this.x2,
    this.y2,
  });

  final int measurementId;
  final int pointId;
  final String pointKey;
  final String label;
  final double cm;
  final double x;
  final double y;
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;

  bool get isDefault =>
      pointKey == 'waist' ||
      pointKey == 'chest' ||
      pointKey == 'bicep_l' ||
      pointKey == 'bicep_r';
}

/// Card "Ultima foto e misure": foto con frecce trascinabili, rilevamento
/// automatico dei punti (ML Kit), tap per aggiungere punti, long-press
/// per eliminare, e modalità Confronto (prima/dopo) con i delta.
class PhotoMeasureCard extends ConsumerStatefulWidget {
  const PhotoMeasureCard({super.key});

  @override
  ConsumerState<PhotoMeasureCard> createState() => _PhotoMeasureCardState();
}

class _PhotoMeasureCardState extends ConsumerState<PhotoMeasureCard> {
  WeightEntry? _last;
  String? _lastAbs;
  List<_ShownMeasure> _measures = [];
  WeightEntry? _first;
  String? _firstAbs;
  List<(String, double, double)> _compareRows = [];
  List<OverlayItem> _firstOverlay = [];
  List<OverlayItem> _lastOverlay = [];
  var _compareMode = false;
  var _autoDetectRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  Future<void> _loadAll() async {
    final db = ref.read(databaseProvider);
    final last = await db.getLastWeightEntry();
    WeightEntry? first;
    if (last != null) {
      first = await db.getFirstEntryWithPhoto();
      if (first?.id == last.id) first = null;
    }
    if (!mounted) return;

    String? lastAbs;
    List<_ShownMeasure> measures = [];
    if (last != null) {
      if (last.photoPath != null) {
        lastAbs = await PhotoStorage.absolute(last.photoPath!);
      }
      final raw = await db.getMeasurements(last.id);
      measures = [
        for (final (m, p) in raw)
          _ShownMeasure(
            measurementId: m.id,
            pointId: p.id,
            pointKey: p.key,
            label: p.label,
            cm: m.valueCm,
            x: m.arrowX,
            y: m.arrowY,
            x1: m.arrowX1,
            y1: m.arrowY1,
            x2: m.arrowX2,
            y2: m.arrowY2,
          ),
      ];
    }

    String? firstAbs;
    List<(String, double, double)> compareRows = [];
    List<OverlayItem> firstOverlay = [];
    List<OverlayItem> lastOverlay = [];
    if (first != null && last != null && first.photoPath != null) {
      firstAbs = await PhotoStorage.absolute(first.photoPath!);
      final firstM = await db.getMeasurements(first.id);
      final lastM = await db.getMeasurements(last.id);
      final lastByLabel = {for (final (m, p) in lastM) p.label: m.valueCm};
      compareRows = [
        for (final (m, p) in firstM)
          if (lastByLabel.containsKey(p.label))
            (p.label, m.valueCm, lastByLabel[p.label]!),
      ];
      firstOverlay = [
        for (final (m, p) in firstM)
          OverlayItem(
            id: m.id,
            label: p.label,
            cx: m.arrowX,
            cy: m.arrowY,
            x1: m.arrowX1,
            y1: m.arrowY1,
            x2: m.arrowX2,
            y2: m.arrowY2,
            cm: m.valueCm,
          ),
      ];
      lastOverlay = [
        for (final (m, p) in lastM)
          OverlayItem(
            id: m.id,
            label: p.label,
            cx: m.arrowX,
            cy: m.arrowY,
            x1: m.arrowX1,
            y1: m.arrowY1,
            x2: m.arrowX2,
            y2: m.arrowY2,
            cm: m.valueCm,
          ),
      ];
    }

    if (!mounted) return;
    setState(() {
      _last = last;
      _lastAbs = lastAbs;
      _measures = measures;
      _first = first;
      _firstAbs = firstAbs;
      _compareRows = compareRows;
      _firstOverlay = firstOverlay;
      _lastOverlay = lastOverlay;
    });

    // Auto-rilevamento: se la foto esiste e le frecce sono ancora al
    // centro (mai posizionate), ML Kit le sistema e le persiste.
    if (lastAbs != null &&
        measures.isNotEmpty &&
        measures.every((m) => m.x == 0.5 && m.y == 0.5)) {
      _autoDetect(last!.id, lastAbs);
    }
  }

  Future<void> _autoDetect(int entryId, String absPath) async {
    if (_autoDetectRunning) return;
    _autoDetectRunning = true;
    final l = AppLocalizations.of(context)!;
    try {
      final pose = await PoseService.analyze(absPath);
      if (pose == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.poseNotFound)));
        }
        return;
      }
      final db = ref.read(databaseProvider);
      for (final m in _measures) {
        final pos = pose[m.pointKey];
        if (pos != null) {
          await db.updateMeasurementArrow(
            m.measurementId,
            pos.cx,
            pos.cy,
            x1: pos.x1,
            y1: pos.y1,
            x2: pos.x2,
            y2: pos.y2,
          );
        }
      }
      await _loadAll();
    } catch (_) {
      // Silente: l'utente può trascinare le frecce a mano.
    } finally {
      _autoDetectRunning = false;
    }
  }

  Future<void> _openAddPointDialog(double x, double y) async {
    final entry = _last;
    if (entry == null) return;
    final result = await showAddPointDialog(context);
    if (result == null || !mounted) return;
    final db = ref.read(databaseProvider);
    final pointId = await db.addCustomPoint(result.name);
    await db.addMeasurement(entry.id, pointId, result.cm, x, y);
    await _loadAll();
  }

  Future<void> _deleteMeasure(_ShownMeasure m) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFFF7FBFA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text(
              guardFirstGlyph(l.deleteMeasureConfirm),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: ClayPalette.text,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(guardFirstGlyph(l.cancel)),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD25A4A),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(guardFirstGlyph(l.delete)),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    final db = ref.read(databaseProvider);
    await db.deleteMeasurement(m.measurementId);
    await db.deletePointIfUnused(m.pointId);
    await _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Ricarica quando cambia l'ultima rilevazione.
    ref.listen(lastWeightEntryProvider, (_, _) => _loadAll());

    return ClayCard(
      key: const ValueKey('photo-measure-card'),
      color: ClayPalette.workout,
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
                  Icons.photo_camera_front_rounded,
                  size: 20,
                  color: ClayPalette.accentDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guardFirstGlyph(l.photoMeasuresTitle),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ClayPalette.text,
                    ),
                  ),
                ),
                if (_first != null)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    child: Row(
                      children: [
                        _ModeChip(
                          label: l.lastTab,
                          selected: !_compareMode,
                          onTap: () => setState(() => _compareMode = false),
                        ),
                        _ModeChip(
                          label: l.compareTab,
                          selected: _compareMode,
                          onTap: () => setState(() => _compareMode = true),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_last == null)
            _Hint(text: l.noPhotoYet)
          else if (_compareMode)
            _buildCompare(l)
          else
            _buildLast(l),
        ],
      ),
    );
  }

  Widget _buildLast(AppLocalizations l) {
    final items = [
      for (final m in _measures)
        OverlayItem(
          id: m.measurementId,
          label: m.label,
          cx: m.x,
          cy: m.y,
          x1: m.x1,
          y1: m.y1,
          x2: m.x2,
          y2: m.y2,
          cm: m.cm,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_lastAbs == null)
          _Hint(text: l.noPhotoYet)
        else
          Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) => _openAddPointDialogFromTap(details),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    File(_lastAbs!),
                    height: 270,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _Hint(text: l.noPhotoYet),
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MeasureOverlay(
                    items: items,
                    onMove: (id, moved) => _onOverlayMove(id, moved),
                    onLongPress: (item) {
                      final m = _measures.firstWhere(
                        (e) => e.measurementId == item.id,
                      );
                      _deleteMeasure(m);
                    },
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            guardFirstGlyph(l.dragHint),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: ClayPalette.textSoft,
            ),
          ),
        ),
      ],
    );
  }

  /// Converte il tap in coordinate 0..1 usando il rettangolo della foto.
  void _openAddPointDialogFromTap(TapUpDetails details) {
    final renderBox = context.findRenderObject();
    if (renderBox is! RenderBox) return;
    // Localizza rispetto alla card: la foto parte sotto il titolo; usiamo
    // il global position del tap rispetto al render box della card e
    // assumiamo la foto a tutta larghezza (lo è).
    final local = renderBox.globalToLocal(details.globalPosition);
    _openAddPointDialog(
      (local.dx / renderBox.size.width).clamp(0.02, 0.98),
      0.5,
    );
  }

  void _onOverlayMove(int id, OverlayItem moved) {
    setState(() {
      _measures = [
        for (final m in _measures)
          if (m.measurementId == id)
            _ShownMeasure(
              measurementId: m.measurementId,
              pointId: m.pointId,
              pointKey: m.pointKey,
              label: m.label,
              cm: m.cm,
              x: moved.cx,
              y: moved.cy,
              x1: moved.x1,
              y1: moved.y1,
              x2: moved.x2,
              y2: moved.y2,
            )
          else
            m,
      ];
    });
  }

  Widget _buildCompare(AppLocalizations l) {
    if (_firstAbs == null || _lastAbs == null) {
      return _Hint(text: l.compareEmpty);
    }
    String fmtDate(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.file(
                          File(_firstAbs!),
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: MeasureOverlay(
                            items: _firstOverlay,
                            smallPills: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fmtDate(_first!.entryDateTime),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.file(
                          File(_lastAbs!),
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: MeasureOverlay(
                            items: _lastOverlay,
                            smallPills: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fmtDate(_last!.entryDateTime),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final (label, before, after) in _compareRows)
          Padding(
            padding: const EdgeInsets.only(bottom: 7, left: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Colors.white.withValues(alpha: 0.6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      guardFirstGlyph(label),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: ClayPalette.text,
                      ),
                    ),
                  ),
                  Text(
                    '${before.toStringAsFixed(0)} → ${after.toStringAsFixed(0)} cm',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatDelta(after - before),
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color:
                          after - before <= 0
                              ? ClayPalette.accentDark
                              : const Color(0xFFD25A4A),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? ClayPalette.accent : Colors.transparent,
        ),
        child: Text(
          guardFirstGlyph(label),
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : ClayPalette.textSoft,
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        guardFirstGlyph(text),
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: ClayPalette.textSoft,
        ),
      ),
    );
  }
}
