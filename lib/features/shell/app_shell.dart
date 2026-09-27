import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../calories/calories_page.dart';
import '../home/home_screen.dart';
import '../weight/weight_page.dart';
import '../workout/workout_page.dart';
import 'clay_nav_rail.dart';
import 'nav_provider.dart';

/// Guscio dell'app: contenuto a sinistra + nav rail verticale clay a destra
/// (come da schema UI). Il cambio sezione è animato con fade + micro-scale.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(appSectionProvider);
    final select = ref.read(appSectionProvider.notifier).select;
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
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
              const SizedBox(width: 12),
              ClayNavRail(
                current: section,
                onSelected: select,
                labels: labels,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
