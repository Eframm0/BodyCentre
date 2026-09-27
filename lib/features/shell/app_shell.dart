import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../calories/calories_page.dart';
import '../home/home_screen.dart';
import '../weight/weight_page.dart';
import '../workout/workout_page.dart';
import 'clay_nav_rail.dart';
import 'nav_provider.dart';

// (railVisibleProvider / appSectionProvider vengono da nav_provider.dart)

/// Guscio dell'app: contenuto a sinistra + nav rail verticale clay a destra
/// (come da schema UI). Il cambio sezione è animato con fade + micro-scale.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(appSectionProvider);
    final select = ref.read(appSectionProvider.notifier).select;
    final railVisible = ref.watch(railVisibleProvider);
    final rail = ref.read(railVisibleProvider.notifier);
    final l = AppLocalizations.of(context)!;

    final labels = AppSectionLabelSet(
      home: l.navHome,
      calories: l.navCalories,
      weight: l.navWeight,
      workout: l.navWorkout,
    );

    final pages = {
      AppSection.home: const HomeScreen(),
      AppSection.calories: const CaloriesPage(),
      AppSection.weight: const WeightPage(),
      AppSection.workout: const WorkoutPage(),
    };

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Contenuto a tutta larghezza: scorre sotto la nav rail flottante.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 340),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeIn,
                transitionBuilder:
                    (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.985, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOut),
                        ),
                        child: child,
                      ),
                    ),
                child: KeyedSubtree(
                  key: ValueKey(section),
                  child: pages[section]!,
                ),
              ),
            ),
            // Fascia di rilevamento sul lato destro (larga, solo swipe):
            // swipe verso sinistra riporta la rail, verso destra la nasconde.
            // Translucent: tap e scroll verticali passano al contenuto.
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (details) {
                  final v = details.primaryVelocity ?? 0;
                  if (v < -80) {
                    rail.show();
                  } else if (v > 80) {
                    rail.hide();
                  }
                },
                child: const SizedBox(width: 120),
              ),
            ),
            // Nav rail flottante: entra con leggero rimbalzo (easeOutBack),
            // esce accelerando (easeInCubic).
            AnimatedPositioned(
              duration:
                  railVisible
                      ? const Duration(milliseconds: 340)
                      : const Duration(milliseconds: 200),
              curve: railVisible ? Curves.easeOutBack : Curves.easeInCubic,
              top: 0,
              bottom: 0,
              right: railVisible ? 6 : -76,
              child: Center(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if ((details.primaryVelocity ?? 0) > 80) rail.hide();
                  },
                  child: ClayNavRail(
                    current: section,
                    onSelected: select,
                    labels: labels,
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
