import 'package:body_centre/app.dart';
import 'package:body_centre/core/db/database.dart';
import 'package:body_centre/core/db/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

UserProfile _testProfile() => UserProfile(
  id: 1,
  firstName: 'Test',
  lastName: 'User',
  birthDate: DateTime(2000, 6, 15),
  isMale: true,
  heightCm: 180,
  currentWeightKg: 78,
  goal: 'maintain',
  activityLevel: 'light',
  manualKcalTarget: null,
  createdAt: DateTime(2026, 1, 1),
);

void main() {
  // Niente pumpAndSettle: la Home ha animazioni in loop (chip età
  // biologica) che non si "assestano" mai.
  testWidgets('Con profilo presente si apre direttamente sulla Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileProvider.overrideWith((ref) => Stream.value(_testProfile())),
        ],
        child: const BodyCentreApp(),
      ),
    );
    // Pump scaglionati: consegna dello stream del profilo + fine delle
    // entrate staggered (i loro timer devono chiudersi prima del teardown).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.byKey(const ValueKey('weight-chart-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('calories-week-card')), findsOneWidget);
  });

  testWidgets('Senza profilo viene mostrato l\'onboarding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileProvider.overrideWith((ref) => Stream.value(null))],
        child: const BodyCentreApp(),
      ),
    );
    await tester.pumpAndSettle();

    // L'onboarding mostra il benvenuto (textContaining: il testo è
    // protetto da ZWSP anteposto, vedi text_guard.dart).
    expect(find.textContaining('Benvenuto in BodyCentre'), findsOneWidget);
    expect(find.textContaining('Chi sei?'), findsOneWidget);
  });
}
