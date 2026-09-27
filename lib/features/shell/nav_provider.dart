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
