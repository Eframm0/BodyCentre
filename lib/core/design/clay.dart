import 'package:flutter/material.dart';

import 'palette.dart';

/// Widget di base dello stile claymorphism: superficie "plastilina" con
/// angoli molto arrotondati, gradiente chiaro→colore, doppia ombra morbida
/// (basso-destra) e luce interna in alto-sinistra.
class ClayCard extends StatelessWidget {
  const ClayCard({
    super.key,
    this.color,
    this.radius = 26,
    this.padding,
    this.child,
    this.pressed = false,
  });

  /// Colore base della superficie (default: [ClayPalette.card]).
  final Color? color;

  /// Raggio degli angoli.
  final double radius;

  final EdgeInsetsGeometry? padding;

  final Widget? child;

  /// Se true comprime le ombre (stato "premuto" per i bottoni clay).
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    final base = color ?? ClayPalette.card;
    final r = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: r,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(base, Colors.white, 0.45)!, base],
        ),
        boxShadow: pressed ? _pressedShadows() : _shadows(),
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Stack(
          children: [
            // Luce interna in alto a sinistra (ombra "inset" simulata).
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: r,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.center,
                      stops: const [0, 0.4],
                      colors: [
                        Colors.white.withValues(alpha: pressed ? 0.12 : 0.28),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ?child,
          ],
        ),
      ),
    );
  }
}

List<BoxShadow> _shadows() => [
  BoxShadow(color: ClayPalette.shadow, blurRadius: 22, offset: const Offset(9, 9)),
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.85),
    blurRadius: 18,
    offset: const Offset(-7, -7),
  ),
];

List<BoxShadow> _pressedShadows() => [
  BoxShadow(
    color: ClayPalette.shadow.withValues(alpha: 0.15),
    blurRadius: 8,
    offset: const Offset(3, 3),
  ),
];

/// Rende qualsiasi figlio "premibile": scala al tap-down e rimbalzo al
/// rilascio. È la base per bottoni e tile clay.
class ClayPressable extends StatefulWidget {
  const ClayPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.94,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Fattore di scala quando premuto.
  final double pressedScale;

  @override
  State<ClayPressable> createState() => _ClayPressableState();
}

class _ClayPressableState extends State<ClayPressable> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 130),
        curve: _pressed ? Curves.easeOut : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}

/// Pill informativa (es. "Età: 23") in stile clay.
class ClayChip extends StatelessWidget {
  const ClayChip({super.key, this.text, this.child, this.accent = false});

  final String? text;
  final Widget? child;

  /// Variante accento (fondo pieno, testo bianco).
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final content =
        text != null
            ? Text(
              text!,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accent ? Colors.white : ClayPalette.text,
              ),
            )
            : child!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: accent ? null : Colors.white.withValues(alpha: 0.55),
        gradient:
            accent
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(ClayPalette.accent, Colors.white, 0.35)!,
                    ClayPalette.accent,
                  ],
                )
                : null,
        boxShadow:
            accent
                ? [
                  BoxShadow(
                    color: ClayPalette.accent.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(3, 4),
                  ),
                ]
                : [
                  BoxShadow(
                    color: ClayPalette.shadow.withValues(alpha: 0.5),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
      ),
      child: content,
    );
  }
}

/// Bottoni azione clay (gradiente accento, testo bianco).
class ClayButton extends StatelessWidget {
  const ClayButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.expanded = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// Se true occupa tutta la larghezza disponibile.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ClayPressable(
      onTap: onTap,
      child: ClayCard(
        color: ClayPalette.accent,
        radius: 20,
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 19),
            const SizedBox(width: 8),
            // FittedBox: su schermi stretti (o con lingue dalle parole lunghe)
            // il testo si riduce invece di traboccare.
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra di avanzamento clay con animazione implicita.
class ClayProgress extends StatelessWidget {
  const ClayProgress({super.key, required this.fraction, this.height = 10});

  /// 0..1
  final double fraction;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.6),
        boxShadow: [
          BoxShadow(
            color: ClayPalette.shadow.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fraction.clamp(0, 1)),
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOutCubic,
          builder:
              (context, value, _) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(ClayPalette.accent, Colors.white, 0.4)!,
                        ClayPalette.accent,
                      ],
                    ),
                  ),
                ),
                ),
        ),
      ),
    );
  }
}
