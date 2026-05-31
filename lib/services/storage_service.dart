import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const _uuid = Uuid();

  Future<String> uploadItemImage(File file, String uid) async {
    final ext = file.path.split('.').last;
    final name = '${_uuid.v4()}.$ext';
    final ref = _storage.ref().child('items/$uid/$name');
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }
}
