import 'package:flutter/material.dart';

import 'core/design/theme.dart';
import 'features/shell/app_shell.dart';
import 'l10n/generated/app_localizations.dart';

class BodyCentreApp extends StatelessWidget {
  const BodyCentreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BodyCentre',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      // v1: solo italiano; le altre lingue si aggiungono con nuovi file .arb.
      locale: const Locale('it'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const AppShell(),
    );
  }
}
