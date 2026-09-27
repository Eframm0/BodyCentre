import 'package:body_centre/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('L\'app si avvia e mostra la shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BodyCentreApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
