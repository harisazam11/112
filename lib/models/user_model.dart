import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  final String semester;
  final String phone;
  final String role; // 'student' | 'admin'
  final DateTime joinedAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    required this.semester,
    required this.phone,
    this.role = 'student',
    required this.joinedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: d['name'] ?? '',
      email: d['email'] ?? '',
      department: d['department'] ?? '',
      semester: d['semester'] ?? '',
      phone: d['phone'] ?? '',
      role: d['role'] ?? 'student',
      joinedAt: (d['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'department': department,
    'semester': semester,
    'phone': phone,
    'role': role,
    'joinedAt': Timestamp.fromDate(joinedAt),
  };

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  bool get isAdmin => role == 'admin';
}
