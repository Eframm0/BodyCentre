import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/providers.dart';
import '../../core/design/clay.dart';
import '../../core/design/palette.dart';
import '../../core/utils/format.dart';
import '../../core/utils/photos.dart';
import '../../core/utils/text_guard.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/body_composition_card.dart';
import 'widgets/new_weight_entry_sheet.dart';
import 'widgets/photo_measure_card.dart';
import 'widgets/trend_measures_card.dart';
import 'widgets/weight_trend_card.dart';

/// Sezione Peso forma: composizione corporea, ultima foto con misure,
/// grafico dell'andamento e storico delle rilevazioni.
class WeightPage extends ConsumerWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final entries = ref.watch(weightEntriesProvider).value ?? [];
    final db = ref.watch(databaseProvider);

    String formatDate(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 6, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  guardFirstGlyph(l.navWeight),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: ClayPalette.text,
                  ),
                ),
              ),
            ),
            ClayButton(
              icon: Icons.add_rounded,
              label: l.newMeasurement,
              expanded: false,
              onTap: () => showNewWeightEntrySheet(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const BodyCompositionCard(),
        const SizedBox(height: 14),
        const PhotoMeasureCard(),
        const SizedBox(height: 14),
        const TrendMeasuresCard(),
        const SizedBox(height: 14),
        WeightTrendCard(entries: entries),
        const SizedBox(height: 14),
        // Storico
        ClayCard(
          key: const ValueKey('weight-history-card'),
          radius: 28,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  guardFirstGlyph(l.weightHistoryTitle),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: ClayPalette.text,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    guardFirstGlyph(l.noEntries),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                )
              else
                for (final (i, e) in entries.indexed.take(10)) ...[
                  _HistoryTile(
                    date: formatDate(e.entryDateTime),
                    weight: e.weightKg,
                    delta:
                        i + 1 < entries.length
                            ? e.weightKg - entries[i + 1].weightKg
                            : null,
                    hasPhoto: e.photoPath != null,
                    onDelete: () async {
                      await db.deleteWeightEntry(e.id);
                      await PhotoStorage.delete(e.photoPath);
                    },
                  ),
                  if (i < entries.length - 1 && i < 9)
                    const SizedBox(height: 8),
                ],
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOutCubic);
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.date,
    required this.weight,
    required this.delta,
    required this.hasPhoto,
    required this.onDelete,
  });

  final String date;
  final double weight;
  final double? delta;
  final bool hasPhoto;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.55),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              date,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ClayPalette.text,
              ),
            ),
          ),
          if (hasPhoto) ...[
            const Icon(Icons.photo_rounded, size: 15, color: ClayPalette.accentDark),
            const SizedBox(width: 6),
          ],
          Text(
            '${formatKg(weight)} kg',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: ClayPalette.accentDark,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(width: 6),
            Text(
              formatDelta(delta!),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: delta! <= 0 ? ClayPalette.accentDark : const Color(0xFFD25A4A),
              ),
            ),
          ],
          const SizedBox(width: 6),
          ClayPressable(
            onTap: onDelete,
            pressedScale: 0.85,
            child: const Icon(Icons.close_rounded, size: 17, color: ClayPalette.textSoft),
          ),
        ],
      ),
    );
  }
}
