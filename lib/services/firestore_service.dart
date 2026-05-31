import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _items =>
      _db.collection('items');

  // ── Streams ──────────────────────────────────────────────
  Stream<List<ItemModel>> streamAllItems() {
    return _items
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ItemModel.fromFirestore).toList());
  }

  Stream<List<ItemModel>> streamLostItems() {
    return _items
        .where('type', isEqualTo: 'lost')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ItemModel.fromFirestore).toList());
  }

  Stream<List<ItemModel>> streamFoundItems() {
    return _items
        .where('type', isEqualTo: 'found')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ItemModel.fromFirestore).toList());
  }

  Stream<List<ItemModel>> streamMyItems(String uid) {
    return _items
        .where('postedByUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ItemModel.fromFirestore).toList());
  }

  // ── CRUD ─────────────────────────────────────────────────
  Future<String> addItem(ItemModel item) async {
    final ref = await _items.add(item.toFirestore());
    return ref.id;
  }

  Future<void> updateItem(ItemModel item) async {
    await _items.doc(item.id).update(item.toFirestore());
  }

  Future<void> updateStatus(String id, String status) async {
    await _items.doc(id).update({'status': status});
  }

  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }

  // ── Search ───────────────────────────────────────────────
  Future<List<ItemModel>> searchItems({
    String? query,
    String? type,
    String? category,
    String? location,
    String? status,
  }) async {
    Query<Map<String, dynamic>> q = _items.orderBy('createdAt', descending: true);
    if (type != null && type != 'all') q = q.where('type', isEqualTo: type);
    if (category != null) q = q.where('category', isEqualTo: category);
    if (status != null) q = q.where('status', isEqualTo: status);

    final snap = await q.get();
    var results = snap.docs.map(ItemModel.fromFirestore).toList();

    if (location != null && location.isNotEmpty) {
      results = results.where((i) =>
        i.location.toLowerCase().contains(location.toLowerCase())).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q2 = query.toLowerCase();
      results = results.where((i) =>
        i.title.toLowerCase().contains(q2) ||
        i.description.toLowerCase().contains(q2) ||
        i.location.toLowerCase().contains(q2) ||
        i.categoryLabel.toLowerCase().contains(q2)).toList();
    }
    return results;
  }
}
