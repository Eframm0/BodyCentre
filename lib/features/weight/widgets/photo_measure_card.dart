import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/photos.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card "Ultima foto e misure": foto dell'ultima rilevazione con l'elenco
/// delle circonferenze registrate. Le frecce in sovrimpressione arrivano
/// con ML Kit (Task 2 di M2).
class PhotoMeasureCard extends ConsumerStatefulWidget {
  const PhotoMeasureCard({super.key});

  @override
  ConsumerState<PhotoMeasureCard> createState() => _PhotoMeasureCardState();
}

class _PhotoMeasureCardState extends ConsumerState<PhotoMeasureCard> {
  String? _absPhoto;
  List<(WeightMeasurement, String)> _measures = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLast());
  }

  Future<void> _loadLast() async {
    final db = ref.read(databaseProvider);
    final last = await db.getLastWeightEntry();
    if (!mounted) return;
    if (last == null) {
      setState(() {
        _measures = [];
        _absPhoto = null;
      });
      return;
    }
    final measures = await db.getMeasurements(last.id);
    final abs =
        last.photoPath == null
            ? null
            : await PhotoStorage.absolute(last.photoPath!);
    if (!mounted) return;
    setState(() {
      _measures = measures;
      _absPhoto = abs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final last = ref.watch(lastWeightEntryProvider);
    // Ricarica quando cambia l'ultima rilevazione (nuovo inserimento).
    ref.listen(lastWeightEntryProvider, (_, _) => _loadLast());

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
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (last == null)
            _Placeholder(text: l.noPhotoYet)
          else ...[
            if (_absPhoto == null && last.photoPath == null)
              _Placeholder(text: l.noPhotoYet)
            else if (_absPhoto != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    File(_absPhoto!),
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, _, _) => _Placeholder(text: l.noPhotoYet),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (_measures.isEmpty)
              _Placeholder(text: l.noMeasures)
            else
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (m, label) in _measures)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.white.withValues(alpha: 0.6),
                          border: Border.all(
                            color: ClayPalette.accent,
                            width: 1.4,
                          ),
                        ),
                        child: Text(
                          '${guardFirstGlyph(label)} · ${m.valueCm.toStringAsFixed(0)} cm',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: ClayPalette.accentDark,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.text});

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
