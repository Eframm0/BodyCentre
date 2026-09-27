import 'package:body_centre/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // N.B. niente pumpAndSettle: la Home ha animazioni in loop (chip età
  // biologica) che non si "assestano" mai.
  testWidgets('L\'app si avvia sulla Home con i dati del profilo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BodyCentreApp()));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Mario Rossi'), findsOneWidget);
    expect(find.byKey(const ValueKey('weight-chart-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('calories-week-card')), findsOneWidget);
  });
}
