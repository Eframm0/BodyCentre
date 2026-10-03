import 'dart:io';
import 'dart:math' as math show sqrt;
import 'dart:ui' as ui;

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Posizione di un punto di misura sulla foto (tutto 0..1):
/// centro + estremi della linea che attraversa la parte del corpo.
class MeasurePos {
  const MeasurePos(this.cx, this.cy, this.x1, this.y1, this.x2, this.y2);

  final double cx;
  final double cy;
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;
}

/// Analisi on-device della foto (ML Kit): ricava centro ed estremi delle
/// linee di misura per vita, petto e bicipiti.
class PoseService {
  static Future<Map<String, MeasurePos>?> analyze(String absPhotoPath) async {
    // Dimensioni dell'immagine per normalizzare i pixel di ML Kit.
    final bytes = await File(absPhotoPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final imgW = frame.image.width.toDouble();
    final imgH = frame.image.height.toDouble();
    frame.image.dispose();

    final detector = PoseDetector(options: PoseDetectorOptions());
    try {
      final poses = await detector.processImage(
        InputImage.fromFilePath(absPhotoPath),
      );
      final pose = poses.isEmpty ? null : poses.first;
      if (pose == null) return null;

      PoseLandmark? lm(PoseLandmarkType t) => pose.landmarks[t];
      final lShoulder = lm(PoseLandmarkType.leftShoulder);
      final rShoulder = lm(PoseLandmarkType.rightShoulder);
      final lElbow = lm(PoseLandmarkType.leftElbow);
      final rElbow = lm(PoseLandmarkType.rightElbow);
      final lHip = lm(PoseLandmarkType.leftHip);
      final rHip = lm(PoseLandmarkType.rightHip);

      if ((lShoulder == null || rShoulder == null) &&
          (lHip == null || rHip == null)) {
        return null;
      }

      double nx(double px) => (px / imgW).clamp(0.02, 0.98);
      double ny(double py) => (py / imgH).clamp(0.02, 0.98);

      final result = <String, MeasurePos>{};

      // Ampiezza spalle (per stimare la larghezza dei bicipiti).
      final shoulderSpan =
          (lShoulder != null && rShoulder != null)
              ? ((lShoulder.x - rShoulder.x).abs() / imgW)
              : 0.18;

      // Petto: linea da spalla a spalla (leggermente sotto).
      if (lShoulder != null && rShoulder != null) {
        final drop = (lShoulder.y - rShoulder.y).abs() + imgH * 0.035;
        result['chest'] = MeasurePos(
          nx((lShoulder.x + rShoulder.x) / 2),
          ny((lShoulder.y + rShoulder.y) / 2 + drop),
          nx(lShoulder.x),
          ny(lShoulder.y + drop),
          nx(rShoulder.x),
          ny(rShoulder.y + drop),
        );
      }

      // Vita: linea da fianco a fianco (leggermente sopra).
      if (lHip != null && rHip != null) {
        final lift = imgH * 0.015;
        result['waist'] = MeasurePos(
          nx((lHip.x + rHip.x) / 2),
          ny((lHip.y + rHip.y) / 2 - lift),
          nx(lHip.x),
          ny(lHip.y - lift),
          nx(rHip.x),
          ny(rHip.y - lift),
        );
      }

      // Bicipiti: segmento perpendicolare all'asse spalla-gomito.
      void bicep(String key, PoseLandmark? s, PoseLandmark? e) {
        if (s == null) return;
        final ex = (e ?? s).x;
        final ey = (e ?? s).y;
        // Direzione dell'arto e perpendicolare.
        var dx = ex - s.x;
        var dy = ey - s.y;
        final len = (dx * dx + dy * dy) == 0 ? 1.0 : math.sqrt(dx * dx + dy * dy);
        dx /= len;
        dy /= len;
        final half = shoulderSpan * 0.14 * imgW;
        final mx = (s.x + ex) / 2;
        final my = (s.y + ey) / 2;
        result[key] = MeasurePos(
          nx(mx),
          ny(my),
          nx(mx - dy * half),
          ny(my + dx * half),
          nx(mx + dy * half),
          ny(my - dx * half),
        );
      }

      bicep('bicep_l', lShoulder, lElbow);
      bicep('bicep_r', rShoulder, rElbow);

      return result.isEmpty ? null : result;
    } finally {
      await detector.close();
    }
  }
}
