import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/providers.dart';
import '../../core/design/clay.dart';
import '../../core/design/palette.dart';
import '../../core/utils/text_guard.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/add_food_sheet.dart';
import 'widgets/diary_card.dart';
import 'widgets/fire_card.dart';
import 'widgets/macro_plate_card.dart';

/// Sezione Calorie: piatto dei macronutrienti (toccabile per aggiungere
/// pasti), card del fuoco con le calorie bruciate e diario del giorno.
class CaloriesPage extends ConsumerWidget {
  const CaloriesPage({super.key});

  String _formatDay(AppLocalizations l, DateTime day, DateTime today) {
    if (day == today) return l.todayChip;
    final weekdays = l.weekdayNames.split(',');
    final months = l.monthNames.split(',');
    return '${weekdays[day.weekday - 1]} ${day.day} ${months[day.month - 1]}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final day = ref.watch(selectedDayProvider);
    final dayControl = ref.read(selectedDayProvider.notifier);
    final entriesAsync = ref.watch(dayEntriesProvider(day));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final entries = entriesAsync.value ?? [];
    final totals = DayTotals.fromEntries(entries);

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 6, 16, 24),
      children: [
        // Selettore data
        Row(
          children: [
            _DateArrow(
              icon: Icons.chevron_left_rounded,
              onTap: () => dayControl.shift(-1),
            ),
            Expanded(
              child: Center(
                child: Text(
                  guardFirstGlyph(_formatDay(l, day, today)),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: ClayPalette.text,
                  ),
                ),
              ),
            ),
            _DateArrow(
              icon: Icons.chevron_right_rounded,
              onTap: day.isBefore(today) ? () => dayControl.shift(1) : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        MacroPlateCard(
          totals: totals,
          onPlateTap: () => showAddFoodSheet(context),
        ),
        const SizedBox(height: 14),
        const FireCard(),
        const SizedBox(height: 14),
        DiaryCard(entries: entries),
      ],
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOutCubic);
  }
}

class _DateArrow extends StatelessWidget {
  const _DateArrow({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.6),
        ),
        child: Icon(
          icon,
          size: 22,
          color: onTap != null ? ClayPalette.accentDark : ClayPalette.textSoft.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
