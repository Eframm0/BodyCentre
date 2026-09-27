/// Workaround per un bug di rendering verificato su alcuni device
/// (Xiaomi/HyperOS, Android 16): il primo glifo di un run di testo a
/// corpo piccolo viene talvolta non disegnato ("eso" invece di "Peso",
/// con qualsiasi font e con entrambi i motori Impeller/Skia).
///
/// Anteporre uno zero-width space (U+200B) "sacrifica" il glifo invisibile
/// e il testo reale viene renderizzato completo.
///
/// Applicarlo alle etichette di piccole dimensioni (≤ ~12px).
String guardFirstGlyph(String text) => '​$text';
