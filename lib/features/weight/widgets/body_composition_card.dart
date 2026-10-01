import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card "Composizione corporea": barre proporzionali di % grasso (giallo)
/// e % muscolo (rosso) dell'ultima rilevazione.
class BodyCompositionCard extends ConsumerWidget {
  const BodyCompositionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final last = ref.watch(lastWeightEntryProvider);

    final fat = last?.fatPct;
    final muscle = last?.musclePct;

    return ClayCard(
      key: const ValueKey('body-comp-card'),
      color: ClayPalette.card,
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
                  Icons.accessibility_new_rounded,
                  size: 20,
                  color: ClayPalette.accentDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guardFirstGlyph(l.bodyCompTitle),
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
          if (fat == null && muscle == null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                guardFirstGlyph(l.noBodyComp),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ClayPalette.textSoft,
                ),
              ),
            )
          else ...[
            _CompBar(
              label: l.fatPctLabel,
              value: fat,
              color: const Color(0xFFE8B84B),
              max: 50,
            ),
            const SizedBox(height: 16),
            _CompBar(
              label: l.musclePctLabel,
              value: muscle,
              color: const Color(0xFFD25A4A),
              max: 60,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompBar extends StatelessWidget {
  const _CompBar({required this.label, required this.value, required this.color, required this.max});

  final String label;
  final double? value;
  final Color color;
  final double max;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final ratio = value == null ? 0.0 : (value! / max).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  guardFirstGlyph(label),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: ClayPalette.text,
                  ),
                ),
              ),
              Text(
                value == null ? '—' : l.pctValue(value!.toStringAsFixed(1)),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ClayPalette.textSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            builder:
                (context, v, _) => LinearProgressIndicator(
                  value: v,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(999),
                  backgroundColor: Colors.white.withValues(alpha: 0.6),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
          ),
        ],
      ),
    );
  }
}
