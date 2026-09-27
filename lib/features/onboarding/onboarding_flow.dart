import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/db/providers.dart';
import '../../core/design/clay.dart';
import '../../core/design/palette.dart';
import '../../core/design/theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/text_guard.dart';
import '../../l10n/generated/app_localizations.dart';

/// Onboarding alla prima apertura: 3 step (identità, dati, obiettivo).
/// Al termine salva il profilo nel database e l'app entra nella shell.
class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _pageController = PageController();
  var _step = 0;

  // Campi
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  bool? _isMale;
  DateTime? _birthDate;
  String _goal = 'maintain';
  String _activity = 'light';
  String? _error;

  @override
  void dispose() {
    _pageController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  bool get _step2Valid =>
      _isMale != null &&
      _birthDate != null &&
      (double.tryParse(_height.text.replaceAll(',', '.')) ?? 0) >= 100 &&
      (double.tryParse(_weight.text.replaceAll(',', '.')) ?? 0) >= 30;

  void _next() {
    final l = AppLocalizations.of(context)!;
    if (_step == 0 &&
        (_firstName.text.trim().isEmpty || _lastName.text.trim().isEmpty)) {
      setState(() => _error = l.errNameRequired);
      return;
    }
    if (_step == 1 && !_step2Valid) {
      setState(() => _error = l.errDataRequired);
      return;
    }
    setState(() => _error = null);
    if (_step < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.saveProfile(
      UserProfilesCompanion.insert(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        birthDate: _birthDate!,
        isMale: _isMale!,
        heightCm: double.parse(_height.text.replaceAll(',', '.')).round(),
        currentWeightKg: double.parse(_weight.text.replaceAll(',', '.')),
        goal: _goal,
        activityLevel: _activity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ClayPalette.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            // Indicatore di avanzamento (3 pallini clay)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: i == _step ? 26 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color:
                          i <= _step
                              ? ClayPalette.accent
                              : Colors.white.withValues(alpha: 0.7),
                      boxShadow: [claySmallShadow],
                    ),
                  ),
                ],
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _Step1(
                    firstName: _firstName,
                    lastName: _lastName,
                    title: l.onbStep1Title,
                    welcomeTitle: l.onbWelcomeTitle,
                    welcomeSubtitle: l.onbWelcomeSubtitle,
                  ),
                  _Step2(
                    title: l.onbStep2Title,
                    isMale: _isMale,
                    birthDate: _birthDate,
                    height: _height,
                    weight: _weight,
                    onSexChanged: (v) => setState(() => _isMale = v),
                    onBirthDateChanged: (v) => setState(() => _birthDate = v),
                  ),
                  _Step3(
                    title: l.onbStep3Title,
                    goal: _goal,
                    activity: _activity,
                    isMale: _isMale,
                    birthDate: _birthDate,
                    heightText: _height.text,
                    weightText: _weight.text,
                    onGoalChanged: (v) => setState(() => _goal = v),
                    onActivityChanged: (v) => setState(() => _activity = v),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  guardFirstGlyph(_error!),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD25A4A),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    ClayButton(
                      icon: Icons.arrow_back_rounded,
                      label: l.buttonBack,
                      expanded: false,
                      onTap:
                          () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                          ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ClayButton(
                      icon:
                          _step == 2
                              ? Icons.play_arrow_rounded
                              : Icons.arrow_forward_rounded,
                      label: _step == 2 ? l.buttonStart : l.buttonContinue,
                      onTap: _next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const claySmallShadow = BoxShadow(
  color: ClayPalette.shadow,
  blurRadius: 5,
  offset: Offset(2, 2),
);

/// Titolo di step dentro la pagina.
class _StepTitle extends StatelessWidget {
  const _StepTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        guardFirstGlyph(text),
        style: baloo(size: 24),
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  const _Step1({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final String title;
  final String welcomeTitle;
  final String welcomeSubtitle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _StepScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            guardFirstGlyph(welcomeTitle),
            style: baloo(size: 28, color: ClayPalette.accentDark),
          ),
          const SizedBox(height: 4),
          Text(
            guardFirstGlyph(welcomeSubtitle),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: ClayPalette.textSoft,
            ),
          ),
          const SizedBox(height: 24),
          _StepTitle(title),
          ClayTextField(
            label: l.fieldFirstName,
            controller: firstName,
            autofocus: true,
          ),
          const SizedBox(height: 12),
          ClayTextField(label: l.fieldLastName, controller: lastName),
        ],
      ),
    );
  }
}

class _Step2 extends StatelessWidget {
  const _Step2({
    required this.title,
    required this.isMale,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.onSexChanged,
    required this.onBirthDateChanged,
  });

  final String title;
  final bool? isMale;
  final DateTime? birthDate;
  final TextEditingController height;
  final TextEditingController weight;
  final ValueChanged<bool?> onSexChanged;
  final ValueChanged<DateTime?> onBirthDateChanged;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      locale: const Locale('it'),
    );
    if (picked != null) onBirthDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dateFmt = DateFormatYMD();

    return _StepScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle(title),
          Text(
            guardFirstGlyph(l.labelSex),
            style: _labelStyle,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Choice(
                label: l.sexMale,
                selected: isMale == true,
                onTap: () => onSexChanged(true),
              ),
              const SizedBox(width: 10),
              _Choice(
                label: l.sexFemale,
                selected: isMale == false,
                onTap: () => onSexChanged(false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(guardFirstGlyph(l.labelBirthDate), style: _labelStyle),
          const SizedBox(height: 8),
          _DatePickerTile(
            text:
                birthDate == null ? '—' : dateFmt.format(birthDate!),
            onTap: () => _pickDate(context),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClayTextField(
                  label: l.labelHeightCm,
                  controller: height,
                  digitsOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClayTextField(
                  label: l.labelWeightKg,
                  controller: weight,
                  digitsOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step3 extends StatelessWidget {
  const _Step3({
    required this.title,
    required this.goal,
    required this.activity,
    required this.isMale,
    required this.birthDate,
    required this.heightText,
    required this.weightText,
    required this.onGoalChanged,
    required this.onActivityChanged,
  });

  final String title;
  final String goal;
  final String activity;
  final bool? isMale;
  final DateTime? birthDate;
  final String heightText;
  final String weightText;
  final ValueChanged<String> onGoalChanged;
  final ValueChanged<String> onActivityChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final height = double.tryParse(heightText.replaceAll(',', '.'));
    final weight = double.tryParse(weightText.replaceAll(',', '.'));
    final preview =
        switch ((isMale, birthDate, height, weight)) {
          (final bool m, final DateTime b, final double h, final double w) =>
            Calories.dailyTarget(
              isMale: m,
              weightKg: w,
              heightCm: h.round(),
              ageYears: Calories.ageFromBirthDate(b),
              activityLevel: activity,
              goal: goal,
            ).round(),
          _ => null,
        };

    return _StepScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepTitle(title),
            Text(guardFirstGlyph(l.labelGoal), style: _labelStyle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Choice(
                  label: l.goalLoss,
                  selected: goal == 'loss',
                  onTap: () => onGoalChanged('loss'),
                ),
                _Choice(
                  label: l.goalMaintain,
                  selected: goal == 'maintain',
                  onTap: () => onGoalChanged('maintain'),
                ),
                _Choice(
                  label: l.goalGain,
                  selected: goal == 'gain',
                  onTap: () => onGoalChanged('gain'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(guardFirstGlyph(l.labelActivity), style: _labelStyle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (value, label) in [
                  ('sedentary', l.actSedentary),
                  ('light', l.actLight),
                  ('moderate', l.actModerate),
                  ('active', l.actActive),
                  ('veryActive', l.actVeryActive),
                ])
                  _Choice(
                    label: label,
                    selected: activity == value,
                    onTap: () => onActivityChanged(value),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (preview != null)
              ClayCard(
                color: ClayPalette.weight,
                radius: 20,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 20,
                      color: ClayPalette.accentDark,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        guardFirstGlyph(
                          l.kcalPreview(formatKcal(preview)),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: ClayPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 12.5,
  fontWeight: FontWeight.w800,
  color: ClayPalette.textSoft,
);

/// Corpo di ogni step: card clay scorrevole.
class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      child: ClayCard(
        radius: 30,
        padding: const EdgeInsets.all(22),
        child: child,
      ).animate().fadeIn(duration: 300.ms).slideY(
        begin: 0.05,
        end: 0,
        duration: 350.ms,
        curve: Curves.easeOutCubic,
      ),
    );
  }
}

/// Campo di testo clay.
class ClayTextField extends StatelessWidget {
  const ClayTextField({
    super.key,
    required this.label,
    this.controller,
    this.autofocus = false,
    this.digitsOnly = false,
  });

  final String label;
  final TextEditingController? controller;
  final bool autofocus;
  final bool digitsOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(guardFirstGlyph(label), style: _labelStyle),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          autofocus: autofocus,
          keyboardType:
              digitsOnly
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: ClayPalette.text,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.65),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: ClayPalette.shadow.withValues(alpha: 0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: ClayPalette.accent,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pillola selezionabile in stile clay.
class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient:
              selected
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(ClayPalette.accent, Colors.white, 0.35)!,
                      ClayPalette.accent,
                    ],
                  )
                  : null,
          color:
              selected ? null : Colors.white.withValues(alpha: 0.6),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: ClayPalette.accent.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(3, 4),
                    ),
                  ]
                  : [claySmallShadow],
        ),
        child: Text(
          guardFirstGlyph(label),
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : ClayPalette.text,
          ),
        ),
      ),
    );
  }
}

/// Riga data di nascita con picker.
class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.65),
          border: Border.all(
            color: ClayPalette.shadow.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              size: 20,
              color: ClayPalette.accentDark,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: ClayPalette.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formattatore data gg/mm/aaaa per la data di nascita.
class DateFormatYMD {
  String format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}
