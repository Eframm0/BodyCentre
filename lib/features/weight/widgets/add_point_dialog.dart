import 'package:flutter/material.dart';

import '../../../core/design/palette.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Dialog di creazione di un nuovo punto di misura (nome + cm).
/// Ritorna nome e centimetri, o null se annullato.
Future<({String name, double cm})?> showAddPointDialog(BuildContext context) {
  final l = AppLocalizations.of(context)!;
  final nameCtl = TextEditingController();
  final cmCtl = TextEditingController();

  return showDialog<({String name, double cm})?>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: const Color(0xFFF7FBFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              guardFirstGlyph(l.addPointTitle),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: ClayPalette.text,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nameCtl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l.pointLabelField,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cmCtl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: l.pointCmField,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ClayPalette.textSoft,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(guardFirstGlyph(l.cancel)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final cm = double.tryParse(cmCtl.text.replaceAll(',', '.'));
                      final name = nameCtl.text.trim();
                      if (name.isEmpty || cm == null) return;
                      Navigator.of(ctx).pop((name: name, cm: cm));
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: ClayPalette.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(guardFirstGlyph(l.addPointSave)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
