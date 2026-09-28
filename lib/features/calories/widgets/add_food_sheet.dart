import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Pannelo di aggiunta cibo al diario: ricerca nel catalogo, dettaglio con
/// grammi/pasto e preview kcal, creazione cibi personalizzati.
Future<void> showAddFoodSheet(BuildContext context, {String? initialMeal}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddFoodSheet(initialMeal: initialMeal),
  );
}

class AddFoodSheet extends ConsumerStatefulWidget {
  const AddFoodSheet({super.key, this.initialMeal});

  final String? initialMeal;

  @override
  ConsumerState<AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends ConsumerState<AddFoodSheet> {
  final _search = TextEditingController();
  final _grams = TextEditingController();
  final _customName = TextEditingController();
  final _customKcal = TextEditingController();
  final _customP = TextEditingController();
  final _customC = TextEditingController();
  final _customF = TextEditingController();

  List<FoodItem> _results = [];
  FoodItem? _selected;
  bool _creating = false;
  late String _meal;

  @override
  void initState() {
    super.initState();
    _meal = widget.initialMeal ?? _defaultMeal();
    _searchAll();
  }

  static String _defaultMeal() {
    final h = DateTime.now().hour;
    if (h >= 6 && h < 11) return 'breakfast';
    if (h >= 11 && h < 15) return 'lunch';
    if (h >= 18 && h < 22) return 'dinner';
    return 'snack';
  }

  @override
  void dispose() {
    _search.dispose();
    _grams.dispose();
    _customName.dispose();
    _customKcal.dispose();
    _customP.dispose();
    _customC.dispose();
    _customF.dispose();
    super.dispose();
  }

  Future<void> _searchAll() async {
    final db = ref.read(databaseProvider);
    final results = await db.searchFoods('', limit: 40);
    if (mounted) setState(() => _results = results);
  }

  Future<void> _doSearch(String q) async {
    final db = ref.read(databaseProvider);
    final results = await db.searchFoods(q, limit: 40);
    if (mounted) setState(() => _results = results);
  }

  void _select(FoodItem food) {
    setState(() {
      _selected = food;
      _creating = false;
      final portion = food.portionGrams?.round();
      _grams.text = (portion == null || portion == 0) ? '100' : '$portion';
    });
  }

  Future<void> _addSelected() async {
    final food = _selected;
    if (food == null) return;
    final grams =
        double.tryParse(_grams.text.replaceAll(',', '.')) ?? food.portionGrams ?? 100;
    final factor = grams / 100;
    final db = ref.read(databaseProvider);
    await db.addMealEntry(
      MealEntriesCompanion.insert(
        entryDateTime: DateTime.now(),
        mealType: _meal,
        foodItemId: Value(food.id),
        foodName: food.name,
        grams: grams,
        kcal: food.kcalPer100g * factor,
        protein: food.proteinPer100g * factor,
        carbs: food.carbsPer100g * factor,
        fat: food.fatPer100g * factor,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _saveCustom() async {
    final name = _customName.text.trim();
    final k = double.tryParse(_customKcal.text.replaceAll(',', '.'));
    if (name.isEmpty || k == null) return;
    final db = ref.read(databaseProvider);
    final id = await db.insertCustomFood(
      FoodItemsCompanion.insert(
        name: name,
        kcalPer100g: k,
        proteinPer100g: double.tryParse(_customP.text.replaceAll(',', '.')) ?? 0,
        carbsPer100g: double.tryParse(_customC.text.replaceAll(',', '.')) ?? 0,
        fatPer100g: double.tryParse(_customF.text.replaceAll(',', '.')) ?? 0,
        isCustom: const Value(true),
      ),
    );
    _select(
      FoodItem(
        id: id,
        name: name,
        kcalPer100g: k,
        proteinPer100g: double.tryParse(_customP.text.replaceAll(',', '.')) ?? 0,
        carbsPer100g: double.tryParse(_customC.text.replaceAll(',', '.')) ?? 0,
        fatPer100g: double.tryParse(_customF.text.replaceAll(',', '.')) ?? 0,
        portionGrams: null,
        isCustom: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF7FBFA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: ClayPalette.shadow.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(child: _buildBody(l)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    if (_creating) return _buildCreateForm(l);
    if (_selected != null) return _buildDetail(l, _selected!);
    return _buildSearch(l);
  }

  Widget _buildSearch(AppLocalizations l) {
    return ListView(
      shrinkWrap: true,
      children: [
        _SheetField(
          controller: _search,
          hint: l.searchFood,
          prefix: Icons.search_rounded,
          onChanged: (q) => q.trim().isEmpty ? _searchAll() : _doSearch(q),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                guardFirstGlyph(
                  _search.text.trim().isEmpty ? l.searchAll : l.noResults,
                ),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ClayPalette.textSoft,
                ),
              ),
            ),
            ClayPressable(
              onTap: () => setState(() => _creating = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: ClayPalette.accent.withValues(alpha: 0.14),
                  border: Border.all(color: ClayPalette.accent, width: 1.4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, size: 15, color: ClayPalette.accent),
                    const SizedBox(width: 4),
                    Text(
                      guardFirstGlyph(l.createCustomFood),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: ClayPalette.accentDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final f in _results)
          _FoodRow(
            food: f,
            onTap: () => _select(f),
          ),
      ],
    );
  }

  Widget _buildDetail(AppLocalizations l, FoodItem food) {
    final grams = double.tryParse(_grams.text.replaceAll(',', '.')) ?? 100;
    final factor = grams / 100;

    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            ClayPressable(
              onTap: () => setState(() => _selected = null),
              child: const Icon(Icons.arrow_back_rounded, size: 22, color: ClayPalette.text),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                guardFirstGlyph(food.name),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: ClayPalette.text,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${formatKcal(food.kcalPer100g.round())} kcal · '
          '${food.proteinPer100g.toStringAsFixed(1)}P '
          '${food.carbsPer100g.toStringAsFixed(1)}C '
          '${food.fatPer100g.toStringAsFixed(1)}G '
          '${l.per100g}',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: ClayPalette.textSoft,
          ),
        ),
        const SizedBox(height: 14),
        _SheetField(
          controller: _grams,
          hint: l.gramsLabel,
          prefix: Icons.scale_rounded,
          digits: true,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        Text(guardFirstGlyph(l.mealLabel), style: _miniLabelStyle),
        const SizedBox(height: 7),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final (value, label) in [
              ('breakfast', l.mealBreakfast),
              ('lunch', l.mealLunch),
              ('dinner', l.mealDinner),
              ('snack', l.mealSnack),
            ])
              _MealChoice(
                label: label,
                selected: _meal == value,
                onTap: () => setState(() => _meal = value),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.65),
          ),
          child: Text(
            '${formatKcal((food.kcalPer100g * factor).round())} kcal · '
            '${(food.proteinPer100g * factor).toStringAsFixed(1)}P '
            '${(food.carbsPer100g * factor).toStringAsFixed(1)}C '
            '${(food.fatPer100g * factor).toStringAsFixed(1)}G',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: ClayPalette.accentDark,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ClayButton(
          icon: Icons.add_rounded,
          label: l.addToDiary,
          onTap: _addSelected,
        ),
      ],
    );
  }

  Widget _buildCreateForm(AppLocalizations l) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            ClayPressable(
              onTap: () => setState(() => _creating = false),
              child: const Icon(Icons.arrow_back_rounded, size: 22, color: ClayPalette.text),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                guardFirstGlyph(l.createCustomFood),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: ClayPalette.text,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SheetField(controller: _customName, hint: l.foodName, prefix: Icons.restaurant_rounded),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _SheetField(controller: _customKcal, hint: l.kcalField, prefix: Icons.local_fire_department_rounded, digits: true)),
            const SizedBox(width: 8),
            Expanded(child: _SheetField(controller: _customP, hint: 'P', prefix: Icons.egg_rounded, digits: true)),
            const SizedBox(width: 8),
            Expanded(child: _SheetField(controller: _customC, hint: 'C', prefix: Icons.bakery_dining_rounded, digits: true)),
            const SizedBox(width: 8),
            Expanded(child: _SheetField(controller: _customF, hint: 'G', prefix: Icons.water_drop_rounded, digits: true)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${l.saveFood} — valori ${l.per100g}',
          style: _miniLabelStyle,
        ),
        const SizedBox(height: 12),
        ClayButton(
          icon: Icons.check_rounded,
          label: l.saveFood,
          onTap: _saveCustom,
        ),
      ],
    );
  }
}

const _miniLabelStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 11,
  fontWeight: FontWeight.w800,
  color: ClayPalette.textSoft,
);

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.hint,
    required this.prefix,
    this.digits = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final bool digits;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType:
          digits ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: ClayPalette.text,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.75),
        isDense: true,
        prefixIcon: Icon(prefix, size: 19, color: ClayPalette.accentDark),
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          color: ClayPalette.textSoft,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: ClayPalette.shadow.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: ClayPalette.accent, width: 1.5),
        ),
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({required this.food, required this.onTap});

  final FoodItem food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withValues(alpha: 0.65),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                guardFirstGlyph(food.name),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: ClayPalette.text,
                ),
              ),
            ),
            Text(
              '${formatKcal(food.kcalPer100g.round())} kcal',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: ClayPalette.accentDark,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: ClayPalette.textSoft,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealChoice extends StatelessWidget {
  const _MealChoice({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient:
              selected
                  ? LinearGradient(
                    colors: [
                      Color.lerp(ClayPalette.accent, Colors.white, 0.35)!,
                      ClayPalette.accent,
                    ],
                  )
                  : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.6),
        ),
        child: Text(
          guardFirstGlyph(label),
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : ClayPalette.text,
          ),
        ),
      ),
    );
  }
}
