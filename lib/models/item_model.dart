import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String type; // 'lost' | 'found'
  final String title;
  final String category;
  final String categoryLabel;
  final String description;
  final String location;
  final String date;
  final String? imageUrl;
  final String postedBy;
  final String postedByUid;
  final String semester;
  final String contact;
  final String email;
  final String status; // Active | Claimed | Returned | Closed
  final bool privacy;
  final DateTime createdAt;

  const ItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.category,
    required this.categoryLabel,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.postedBy,
    required this.postedByUid,
    required this.semester,
    required this.contact,
    required this.email,
    required this.status,
    this.privacy = false,
    required this.createdAt,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      type: d['type'] ?? 'lost',
      title: d['title'] ?? '',
      category: d['category'] ?? 'oth',
      categoryLabel: d['categoryLabel'] ?? 'Other',
      description: d['description'] ?? '',
      location: d['location'] ?? '',
      date: d['date'] ?? 'Today',
      imageUrl: d['imageUrl'],
      postedBy: d['postedBy'] ?? '',
      postedByUid: d['postedByUid'] ?? '',
      semester: d['semester'] ?? '',
      contact: d['contact'] ?? '',
      email: d['email'] ?? '',
      status: d['status'] ?? 'Active',
      privacy: d['privacy'] ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'type': type,
    'title': title,
    'category': category,
    'categoryLabel': categoryLabel,
    'description': description,
    'location': location,
    'date': date,
    'imageUrl': imageUrl,
    'postedBy': postedBy,
    'postedByUid': postedByUid,
    'semester': semester,
    'contact': contact,
    'email': email,
    'status': status,
    'privacy': privacy,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  ItemModel copyWith({
    String? id, String? type, String? title, String? category,
    String? categoryLabel, String? description, String? location,
    String? date, String? imageUrl, String? postedBy, String? postedByUid,
    String? semester, String? contact, String? email, String? status,
    bool? privacy, DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      category: category ?? this.category,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      postedBy: postedBy ?? this.postedBy,
      postedByUid: postedByUid ?? this.postedByUid,
      semester: semester ?? this.semester,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      status: status ?? this.status,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isLost => type == 'lost';
  bool get isFound => type == 'found';
  bool get isActive => status == 'Active';
}
