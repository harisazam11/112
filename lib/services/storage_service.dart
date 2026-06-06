import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class StorageService {
  static const _cloudName = 'dyijsshbr';
  static const _uploadPreset = 'campus_lost_found';

  Future<String> uploadItemImage(File file, String uid) async {
    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Image upload failed (${streamed.statusCode}). Please check your connection and try again.');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    final secureUrl = json['secure_url'] as String?;
    if (secureUrl == null) {
      throw Exception('Image upload failed: unexpected response from server.');
    }
    return secureUrl;
  }

  Future<void> deleteImage(String url) async {
    // Cloudinary unsigned upload presets do not support client-side deletion.
    // Manage uploaded images from the Cloudinary dashboard.
  }
}
