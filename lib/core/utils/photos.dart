import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Scelta e salvataggio delle foto delle rilevazioni peso.
abstract final class PhotoStorage {
  static final _picker = ImagePicker();

  /// Apre la galleria e salva la foto nella documents dir dell'app.
  /// Ritorna il percorso relativo salvato nel DB, o null se annullato.
  static Future<String?> pickFromGallery() async {
    final xfile = await _picker.pickImage(
      imageQuality: 82,
      maxWidth: 1600,
      source: ImageSource.gallery,
    );
    return _persist(xfile);
  }

  /// Apre la fotocamera e salva la foto.
  static Future<String?> pickFromCamera() async {
    final xfile = await _picker.pickImage(
      imageQuality: 82,
      maxWidth: 1600,
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    return _persist(xfile);
  }

  static Future<String?> _persist(XFile? xfile) async {
    if (xfile == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(dir.path, 'photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    final name = '${const Uuid().v4()}${p.extension(xfile.path)}';
    final dest = p.join(photosDir.path, name);
    await File(xfile.path).copy(dest);
    return p.relative(dest, from: dir.path);
  }

  /// Percorso assoluto di una foto salvata (per Image.file).
  static Future<String> absolute(String relativePath) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, relativePath);
  }

  /// Elimina una foto (se esiste) quando si cancella la rilevazione.
  static Future<void> delete(String? relativePath) async {
    if (relativePath == null) return;
    try {
      final abs = await absolute(relativePath);
      final f = File(abs);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // Foto già rimossa: ok.
    }
  }
}
