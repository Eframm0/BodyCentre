import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/design/clay.dart';
import '../../core/design/palette.dart';
import 'nav_provider.dart';

/// Voce della nav rail: cerchio clay che si "accende" (gradiente accento
/// + glow) quando è la sezione attiva.
class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      pressedScale: 0.88,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: active ? Curves.easeOutBack : Curves.easeOut,
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              active
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(ClayPalette.accent, Colors.white, 0.4)!,
                      ClayPalette.accent,
                    ],
                  )
                  : null,
          boxShadow:
              active
                  ? [
                    BoxShadow(
                      color: ClayPalette.accent.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : const [],
        ),
        child: Icon(
          icon,
          size: 22,
          color: active ? Colors.white : ClayPalette.textSoft,
        ),
      ),
    );
  }
}

/// Nav rail verticale a destra (come da schema UI): pill clay con le
/// quattro sezioni principali. I tooltip mostrano il nome della sezione.
class ClayNavRail extends StatelessWidget {
  const ClayNavRail({
    super.key,
    required this.current,
    required this.onSelected,
    required this.labels,
  });

  final AppSectionLabelSet labels;
  final AppSection current;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      (AppSection.home, Icons.home_rounded),
      (AppSection.calories, Icons.local_fire_department_rounded),
      (AppSection.weight, Icons.water_drop_rounded),
      (AppSection.workout, Icons.fitness_center_rounded),
    ];

    // Pill flottante in "vetro clay": sfondo semitrasparente + blur del
    // contenuto che scorre sotto, così non ruba spazio al layout.
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
        child: ClayCard(
          radius: 999,
          color: Colors.white.withValues(alpha: 0.55),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, (section, icon)) in items.indexed) ...[
                if (i > 0) const SizedBox(height: 10),
                Tooltip(
                  message: labels.of(section),
                  child: _RailButton(
                    icon: icon,
                    active: section == current,
                    onTap: () => onSelected(section),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Nomi delle sezioni (i18n), passati dalla shell alla rail.
class AppSectionLabelSet {
  const AppSectionLabelSet({
    required this.home,
    required this.calories,
    required this.weight,
    required this.workout,
  });

  final String home;
  final String calories;
  final String weight;
  final String workout;

  String of(AppSection section) => switch (section) {
    AppSection.home => home,
    AppSection.calories => calories,
    AppSection.weight => weight,
    AppSection.workout => workout,
  };
}
