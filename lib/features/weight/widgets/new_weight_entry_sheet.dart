import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
import '../../../core/ml/pose_service.dart';
import 'add_point_dialog.dart';
import 'full_screen_measure_editor.dart';
import 'interactive_preview.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/photos.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Pannello "Nuova rilevazione": peso, composizione corporea, circonferenze
/// (predefinite + personalizzate) e foto da galleria o fotocamera.
Future<void> showNewWeightEntrySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const NewWeightEntrySheet(),
  );
}

class NewWeightEntrySheet extends ConsumerStatefulWidget {
  const NewWeightEntrySheet({super.key});

  @override
  ConsumerState<NewWeightEntrySheet> createState() =>
      _NewWeightEntrySheetState();
}

class _NewWeightEntrySheetState extends ConsumerState<NewWeightEntrySheet> {
  final _weight = TextEditingController();
  final _fat = TextEditingController();
  final _muscle = TextEditingController();
  final _customName = TextEditingController();
  final _customCm = TextEditingController();

  List<MeasurementPoint> _points = [];
  final Map<int, TextEditingController> _cmControllers = {};
  String? _photoRel;
  String? _photoAbs;
  String? _error;
  Map<String, MeasurePos> _posePositions = {};
  var _nextTempId = -1;
  bool _detecting = false;

  @override
  void initState() {
    super.initState();
    _initPoints();
  }

  Future<void> _initPoints() async {
    final db = ref.read(databaseProvider);
    await db.ensureDefaultPoints();
    final points = await db.getAllPoints();
    if (mounted) {
      setState(() {
        _points = points;
        for (final p in points) {
          _cmControllers[p.id] = TextEditingController();
        }
      });
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    _fat.dispose();
    _muscle.dispose();
    _customName.dispose();
    _customCm.dispose();
    for (final c in _cmControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pick(bool camera) async {
    final l = AppLocalizations.of(context)!;
    // Guida allo scatto prima di aprire la fotocamera.
    if (camera && mounted) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => _ShotGuideDialog(onOk: () => Navigator.of(ctx).pop(true)),
      );
      if (ok != true) return;
    }
    final rel = camera
        ? await PhotoStorage.pickFromCamera()
        : await PhotoStorage.pickFromGallery();
    if (rel == null || !mounted) return;
    final abs = await PhotoStorage.absolute(rel);
    setState(() {
      _photoRel = rel;
      _photoAbs = abs;
      _posePositions = {};
      _detecting = true;
    });
    // Pose detection on-device: posiziona le frecce dei punti standard.
    var detected = false;
    try {
      final pose = await PoseService.analyze(abs);
      if (pose != null) {
        detected = true;
        if (mounted) {
          setState(() => _posePositions = pose);
        }
      }
    } catch (_) {
      // Rilevamento non disponibile: frecce in posizione centrale.
    }
    if (mounted) {
      setState(() => _detecting = false);
      if (!detected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.poseNotFound)),
        );
      }
    }
  }

  void _addCustomPoint() {
    final name = _customName.text.trim();
    final cm = double.tryParse(_customCm.text.replaceAll(',', '.'));
    if (name.isEmpty || cm == null) return;
    setState(() {
      // Punto PENDING locale (id negativo): salvato nel DB solo insieme
      // alla rilevazione. Così la X lo cancella davvero.
      final id = _nextTempId--;
      _points = [..._points, MeasurementPoint(id: id, key: 'custom:$name', label: name, isCustom: true)];
      _cmControllers[id] = TextEditingController(text: _customCm.text);
      _customName.clear();
      _customCm.clear();
    });
  }

  /// Punto personalizzato aggiunto toccando la foto (editor o anteprima).
  Future<void> _addPointFromPhoto(double x, double y) async {
    final result = await showAddPointDialog(context);
    if (result == null || !mounted) return;
    setState(() {
      // Pending locale: vedi _addCustomPoint.
      final id = _nextTempId--;
      _points = [
        ..._points,
        MeasurementPoint(
          id: id,
          key: 'custom:${result.name}',
          label: result.name,
          isCustom: true,
        ),
      ];
      _cmControllers[id] = TextEditingController(text: result.cm.toStringAsFixed(1));
      _posePositions['custom:${result.name}'] = MeasurePos(x, y, null, null, null, null);
    });
  }

  /// Rimuove un punto personalizzato: i pending (id < 0) spariscono e
  /// basta; quelli già nel DB vengono cancellati PERMANENTEMENTE (con
  /// tutte le loro misure passate).
  Future<void> _removeCustomPoint(MeasurementPoint p) async {
    if (p.id > 0) {
      final db = ref.read(databaseProvider);
      await db.deletePointCascade(p.id);
    }
    if (!mounted) return;
    setState(() {
      _points = _points.where((e) => e.id != p.id).toList();
      _posePositions.remove(p.key);
      _cmControllers.remove(p.id)?.dispose();
    });
  }

  /// Apre l'editor a tutto schermo per sistemare i punti comodi.
  Future<void> _openEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder:
            (ctx) => FullScreenMeasureEditor(
              absPath: _photoAbs!,
              positions: _posePositions,
              points: _points,
              cmOf: (id) => double.tryParse(
                (_cmControllers[id]?.text ?? '').replaceAll(',', '.'),
              ),
              onAddPoint: (x, y) => _addPointFromPhoto(x, y),
            ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final weight = double.tryParse(_weight.text.replaceAll(',', '.'));
    if (weight == null || weight < 25) {
      setState(() => _error = l.errWeightRequired);
      return;
    }
    final db = ref.read(databaseProvider);
    final fat = double.tryParse(_fat.text.replaceAll(',', '.'));
    final muscle = double.tryParse(_muscle.text.replaceAll(',', '.'));

    // I punti pending (id negativi) vengono creati ora nel DB.
    final realIds = <int, int>{};
    for (final p in _points.where((e) => e.id < 0)) {
      realIds[p.id] = await db.addCustomPoint(p.label);
    }

    final measures = <MeasureToSave>[];
    for (final p in _points) {
      final cm = double.tryParse(_cmControllers[p.id]!.text.replaceAll(',', '.'));
      if (cm != null && cm > 0) {
        final pos = _posePositions[p.key] ?? const MeasurePos(0.5, 0.5, null, null, null, null);
        measures.add(
          MeasureToSave(
            realIds[p.id] ?? p.id,
            cm,
            pos.cx,
            pos.cy,
            x1: pos.x1,
            y1: pos.y1,
            x2: pos.x2,
            y2: pos.y2,
          ),
        );
      }
    }

    await db.saveWeightEntry(
      WeightEntriesCompanion.insert(
        entryDateTime: DateTime.now(),
        weightKg: weight,
        fatPct: fat == null ? const Value.absent() : Value(fat),
        musclePct: muscle == null ? const Value.absent() : Value(muscle),
        photoPath: _photoRel == null ? const Value.absent() : Value(_photoRel!),
      ),
      measures,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF7FBFA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                width: 42,
                height: 4.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: ClayPalette.shadow.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                guardFirstGlyph(l.newMeasurement),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: ClayPalette.text,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _Field(controller: _weight, hint: l.fieldWeightKg, digits: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _Field(controller: _fat, hint: l.fieldFatPct, digits: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _Field(controller: _muscle, hint: l.fieldMusclePct, digits: true)),
                ],
              ),
              const SizedBox(height: 14),
              Text(guardFirstGlyph(l.circumferencesTitle), style: _mini),
              const SizedBox(height: 8),
              for (final p in _points)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          guardFirstGlyph(p.label),
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ClayPalette.text,
                          ),
                        ),
                      ),
                      if (p.isCustom)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ClayPressable(
                            onTap: () => _removeCustomPoint(p),
                            pressedScale: 0.85,
                            child: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Color(0xFFD25A4A),
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 2,
                        child: _Field(
                          controller: _cmControllers[p.id]!,
                          hint: 'cm',
                          digits: true,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: _Field(controller: _customName, hint: l.pointName)),
                  const SizedBox(width: 8),
                  Expanded(child: _Field(controller: _customCm, hint: 'cm', digits: true, dense: true)),
                  const SizedBox(width: 8),
                  ClayPressable(
                    onTap: _addCustomPoint,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: ClayPalette.accent.withValues(alpha: 0.14),
                        border: Border.all(color: ClayPalette.accent, width: 1.3),
                      ),
                      child: const Icon(Icons.add_rounded, size: 20, color: ClayPalette.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ClayButton(
                      icon: Icons.photo_library_rounded,
                      label: l.photoGallery,
                      onTap: () => _pick(false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClayButton(
                      icon: Icons.photo_camera_rounded,
                      label: l.photoCamera,
                      onTap: () => _pick(true),
                    ),
                  ),
                ],
              ),
              if (_detecting)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    guardFirstGlyph(l.detecting),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.accentDark,
                    ),
                  ),
                ),
              if (_photoAbs != null) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _openEditor,
                  child: InteractivePreview(
                    absPath: _photoAbs!,
                    positions: _posePositions,
                    points: _points,
                    cmOf: (id) => double.tryParse(
                      (_cmControllers[id]?.text ?? '').replaceAll(',', '.'),
                    ),
                    onTap: (_, _) {},
                  ),
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    guardFirstGlyph(_error!),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD25A4A),
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              ClayButton(icon: Icons.check_rounded, label: l.saveEntry, onTap: _save),
            ],
          ),
        ),
      ),
    );
  }
}

const _mini = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 11,
  fontWeight: FontWeight.w800,
  color: ClayPalette.textSoft,
);

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.digits = false,
    this.dense = false,
  });

  final TextEditingController controller;
  final String hint;
  final bool digits;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType:
          digits
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: ClayPalette.text,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.75),
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          color: ClayPalette.textSoft.withValues(alpha: 0.8),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: dense ? 9 : 11,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ClayPalette.shadow.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ClayPalette.accent, width: 1.5),
        ),
      ),
    );
  }
}


/// Guida mostrata prima di aprire la fotocamera: silhouette di
/// riferimento con braccia aperte + consigli per una detection precisa.
class _ShotGuideDialog extends StatelessWidget {
  const _ShotGuideDialog({required this.onOk});

  final VoidCallback onOk;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: const Color(0xFFF7FBFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              guardFirstGlyph(l.shotGuideTitle),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: ClayPalette.text,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 110,
              height: 150,
              child: CustomPaint(
                painter: _GuideSilhouettePainter(),
                size: Size.infinite,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              guardFirstGlyph(l.shotGuideBody),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: ClayPalette.textSoft,
              ),
            ),
            const SizedBox(height: 16),
            ClayButton(icon: Icons.photo_camera_rounded, label: l.shotGuideOk, onTap: onOk),
          ],
        ),
      ),
    );
  }
}

/// Silhouette piatta con braccia leggermente aperte (riferimento scatto).
class _GuideSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = ClayPalette.accent.withValues(alpha: 0.45);
    final outline =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = ClayPalette.accentDark;
    final w = size.width;

    void shape(Path path) {
      canvas.drawPath(path, fill);
      canvas.drawPath(path, outline);
    }

    shape(
      Path()
        ..addOval(
          Rect.fromCenter(center: Offset(w / 2, w * 0.14), width: w * 0.20, height: w * 0.24),
        ),
    );
    shape(
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(w / 2, w * 0.50), width: w * 0.34, height: w * 0.58),
            Radius.circular(w * 0.10),
          ),
        ),
    );
    for (final side in [-1.0, 1.0]) {
      shape(
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(w / 2 + side * w * 0.29, w * 0.50),
                width: w * 0.12,
                height: w * 0.52,
              ),
              Radius.circular(w * 0.06),
            ),
          ),
      );
    }
    for (final side in [-1.0, 1.0]) {
      shape(
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(w / 2 + side * w * 0.12, w * 1.02),
                width: w * 0.13,
                height: w * 0.72,
              ),
              Radius.circular(w * 0.065),
            ),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
