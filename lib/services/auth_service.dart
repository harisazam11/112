import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(), password: password,
    );
    return _fetchUser(cred.user!.uid);
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String department,
    required String semester,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(), password: password,
    );
    await cred.user!.updateDisplayName(name.trim());

    final user = UserModel(
      uid: cred.user!.uid,
      name: name.trim(),
      email: email.trim(),
      department: department,
      semester: semester,
      phone: phone.trim(),
      joinedAt: DateTime.now(),
    );
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
    return user;
  }

  Future<void> signOut() => _auth.signOut();

  Future<UserModel?> _fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _fetchUser(user.uid);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).update(data);

  /// Back-fills the denormalized poster fields on every item the user created.
  Future<void> updatePosterInfo(String uid, String name, String semester) async {
    final snap = await _db
        .collection('items')
        .where('postedByUid', isEqualTo: uid)
        .get();
    if (snap.docs.isEmpty) return;
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'postedBy': name, 'semester': semester});
    }
    await batch.commit();
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());
}
