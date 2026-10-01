import 'package:body_centre/core/db/database.dart';
import 'package:body_centre/core/db/providers.dart';
import 'package:body_centre/features/weight/widgets/body_composition_card.dart';
import 'package:body_centre/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('golden card composizione', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 400);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lastWeightEntryProvider.overrideWith(
            (ref) => WeightEntry(
              id: 1,
              entryDateTime: DateTime.now(),
              weightKg: 78,
              fatPct: 18,
              musclePct: 42,
              photoPath: null,
              note: null,
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('it'),
          home: Scaffold(
            body: Center(child: SizedBox(width: 380, child: BodyCompositionCard())),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await expectLater(
      find.byKey(const ValueKey('body-comp-card')),
      matchesGoldenFile('goldens/body_comp.png'),
    );
  });
}
