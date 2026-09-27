import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sezioni principali dell'app, nell'ordine della nav rail.
enum AppSection { home, calories, weight, workout }

/// Sezione attiva nella shell.
final appSectionProvider =
    NotifierProvider<AppSectionNotifier, AppSection>(AppSectionNotifier.new);

class AppSectionNotifier extends Notifier<AppSection> {
  @override
  AppSection build() => AppSection.home;

  void select(AppSection section) => state = section;
}

/// Visibilità della nav rail flottante (a scomparsa con swipe).
final railVisibleProvider =
    NotifierProvider<RailVisibleNotifier, bool>(RailVisibleNotifier.new);

class RailVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void hide() => state = false;

  void show() => state = true;
}
