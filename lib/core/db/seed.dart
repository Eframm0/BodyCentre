import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;

import 'database.dart';

/// Importa il catalogo seed (tabelle CREA, ~200 alimenti generici) dal
/// JSON in assets/data/foods_it.json. Eseguito solo se il catalogo è vuoto.
Future<void> seedFoodsIfEmpty(AppDatabase db) async {
  if (await db.countFoods() > 0) return;

  final raw = await rootBundle.loadString('assets/data/foods_it.json');
  final List<dynamic> items = jsonDecode(raw) as List<dynamic>;

  await db.insertFoods([
    for (final item in items)
      FoodItemsCompanion.insert(
        name: item['n'] as String,
        kcalPer100g: (item['k'] as num).toDouble(),
        proteinPer100g: (item['p'] as num).toDouble(),
        carbsPer100g: (item['c'] as num).toDouble(),
        fatPer100g: (item['f'] as num).toDouble(),
        portionGrams:
            item['g'] == null ? const Value.absent() : Value((item['g'] as num).toDouble()),
        isCustom: const Value(false),
      ),
  ]);
}
