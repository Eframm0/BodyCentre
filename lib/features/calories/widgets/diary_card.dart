import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Diario del giorno: voci raggruppate per pasto, con eliminazione.
class DiaryCard extends ConsumerWidget {
  const DiaryCard({super.key, required this.entries});

  final List<MealEntry> entries;

  static const _mealOrder = ['breakfast', 'lunch', 'dinner', 'snack'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);

    String mealName(String m) => switch (m) {
      'breakfast' => l.mealBreakfast,
      'lunch' => l.mealLunch,
      'dinner' => l.mealDinner,
      _ => l.mealSnack,
    };
    IconData mealIcon(String m) => switch (m) {
      'breakfast' => Icons.free_breakfast_rounded,
      'lunch' => Icons.restaurant_rounded,
      'dinner' => Icons.dinner_dining_rounded,
      _ => Icons.icecream_rounded,
    };

    final grouped = <String, List<MealEntry>>{};
    for (final e in entries) {
      grouped.putIfAbsent(e.mealType, () => []).add(e);
    }
    final meals =
        _mealOrder.where((m) => grouped.containsKey(m)).toList() +
            grouped.keys.where((m) => !_mealOrder.contains(m)).toList();

    return ClayCard(
      key: const ValueKey('diary-card'),
      radius: 28,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding sinistro: il primo elemento subiva il taglio del bordo
          // (stesso bug della legenda, vedi calories_week_card).
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              guardFirstGlyph(l.diaryTitle),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
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
              guardFirstGlyph(l.emptyDiary),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: ClayPalette.textSoft,
              ),
              ),
            )
          else
            for (final meal in meals) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                children: [
                  Icon(mealIcon(meal), size: 16, color: ClayPalette.accentDark),
                  const SizedBox(width: 6),
                  Text(
                    guardFirstGlyph(mealName(meal)),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: ClayPalette.accentDark,
                    ),
                  ),
                ],
                ),
              ),
              const SizedBox(height: 6),
              for (final e in grouped[meal]!) ...[
                _DiaryTile(
                  name: e.foodName,
                  grams: e.grams,
                  kcal: e.kcal,
                  onDelete: () => db.deleteMealEntry(e.id),
                ),
                if (e != grouped[meal]!.last) const SizedBox(height: 6),
              ],
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _DiaryTile extends StatelessWidget {
  const _DiaryTile({
    required this.name,
    required this.grams,
    required this.kcal,
    required this.onDelete,
  });

  final String name;
  final double grams;
  final double kcal;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.55),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: ClayPalette.text,
              ),
            ),
          ),
          Text(
            '${grams.round()} g',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: ClayPalette.textSoft,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${formatKcal(kcal.round())} kcal',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: ClayPalette.accentDark,
            ),
          ),
          const SizedBox(width: 6),
          ClayPressable(
            onTap: onDelete,
            pressedScale: 0.85,
            child: const Icon(
              Icons.close_rounded,
              size: 17,
              color: ClayPalette.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}
