import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
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
    final rel = camera
        ? await PhotoStorage.pickFromCamera()
        : await PhotoStorage.pickFromGallery();
    if (rel == null || !mounted) return;
    final abs = await PhotoStorage.absolute(rel);
    setState(() {
      _photoRel = rel;
      _photoAbs = abs;
    });
  }

  Future<void> _addCustomPoint() async {
    final name = _customName.text.trim();
    final cm = double.tryParse(_customCm.text.replaceAll(',', '.'));
    if (name.isEmpty || cm == null) return;
    final db = ref.read(databaseProvider);
    final id = await db.addCustomPoint(name);
    setState(() {
      _points = [..._points, MeasurementPoint(id: id, key: 'custom:$name', label: name, isCustom: true)];
      _cmControllers[id] = TextEditingController(text: _customCm.text);
      _customName.clear();
      _customCm.clear();
    });
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

    final measures = <(int, double, double, double, double)>[];
    for (final p in _points) {
      final cm = double.tryParse(_cmControllers[p.id]!.text.replaceAll(',', '.'));
      if (cm != null && cm > 0) {
        measures.add((p.id, cm, 0.5, 0.5, 0));
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
              if (_photoAbs != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(_photoAbs!),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
