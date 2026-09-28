import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/db/providers.dart';
import 'core/design/palette.dart';
import 'core/design/theme.dart';
import 'core/utils/text_guard.dart';
import 'features/onboarding/onboarding_flow.dart';
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
      home: const ProfileGate(),
    );
  }
}

/// Instrada tra onboarding (nessun profilo) e shell dell'app.
class ProfileGate extends ConsumerWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(appInitProvider);
    final profileAsync = ref.watch(profileProvider);

    return init.when(
      loading: () => const _Splash(),
      error: (_, _) => const _Splash(),
      data: (_) =>
          profileAsync.when(
            loading: () => const _Splash(),
            error: (_, _) => const _Splash(),
            data: (profile) =>
                profile == null ? const OnboardingFlow() : const AppShell(),
          ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClayPalette.bg,
      body: Center(
        child: Text(
          guardFirstGlyph('BodyCentre'),
          style: baloo(size: 34, color: ClayPalette.accentDark),
        ),
      ),
    );
  }
}
