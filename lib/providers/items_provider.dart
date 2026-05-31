import 'dart:io';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../core/app_constants.dart';

class ItemsProvider extends ChangeNotifier {
  final FirestoreService _fs = FirestoreService();
  final StorageService _ss = StorageService();

  List<ItemModel> _all = [];
  bool _loading = false;
  String? _error;

  List<ItemModel> get all => _all;
  List<ItemModel> get lost => _all.where((i) => i.isLost).toList();
  List<ItemModel> get found => _all.where((i) => i.isFound).toList();
  bool get loading => _loading;
  String? get error => _error;

  int get activeLostCount => _all.where((i) => i.isLost && i.isActive).length;
  int get activeFoundCount => _all.where((i) => i.isFound && i.isActive).length;
  int get returnedCount => _all.where((i) => i.status == 'Returned').length;

  void listenToItems() {
    _fs.streamAllItems().listen((items) {
      _all = items;
      notifyListeners();
    });
  }

  List<ItemModel> myItems(String uid) =>
      _all.where((i) => i.postedByUid == uid).toList();

  Future<bool> addItem({
    required String type,
    required String title,
    required String category,
    required String description,
    required String location,
    required String date,
    required String contact,
    required String email,
    String? pickup,
    File? imageFile,
    required UserModel user,
  }) async {
    _loading = true; notifyListeners();
    try {
      final cat = AppConstants.categories.firstWhere(
        (c) => c['key'] == category,
        orElse: () => {'key': 'oth', 'label': 'Other'},
      );

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _ss.uploadItemImage(imageFile, user.uid);
      }

      final item = ItemModel(
        id: '',
        type: type,
        title: title.trim(),
        category: category,
        categoryLabel: cat['label'] ?? 'Other',
        description: description.trim(),
        location: location,
        date: date,
        imageUrl: imageUrl,
        postedBy: user.name,
        postedByUid: user.uid,
        semester: user.semester,
        contact: contact.trim(),
        email: email.trim(),
        status: 'Active',
        privacy: category == 'id',
        createdAt: DateTime.now(),
      );
      await _fs.addItem(item);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<bool> updateItem(ItemModel item, {File? newImageFile}) async {
    _loading = true; notifyListeners();
    try {
      String? imageUrl = item.imageUrl;
      if (newImageFile != null) {
        if (imageUrl != null) await _ss.deleteImage(imageUrl);
        imageUrl = await _ss.uploadItemImage(newImageFile, item.postedByUid);
      }
      await _fs.updateItem(item.copyWith(imageUrl: imageUrl));
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<bool> updateStatus(String id, String status) async {
    try {
      await _fs.updateStatus(id, status);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> deleteItem(ItemModel item) async {
    try {
      if (item.imageUrl != null) await _ss.deleteImage(item.imageUrl!);
      await _fs.deleteItem(item.id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  List<ItemModel> search({
    String query = '',
    String type = 'all',
    List<String> categories = const [],
    String? location,
    String? status,
  }) {
    return _all.where((i) {
      if (type != 'all' && i.type != type) return false;
      if (categories.isNotEmpty && !categories.contains(i.category)) return false;
      if (location != null && location.isNotEmpty &&
          !i.location.toLowerCase().contains(location.toLowerCase())) return false;
      if (status != null && i.status != status) return false;
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        return i.title.toLowerCase().contains(q) ||
            i.description.toLowerCase().contains(q) ||
            i.location.toLowerCase().contains(q) ||
            i.categoryLabel.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }
}
