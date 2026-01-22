import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReflectionService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> _col() {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('entries');
  }

  /// Save reflection entry ke Firestore
  static Future<void> addEntry(Map<String, dynamic> entry) async {
    final now = DateTime.now();

    final data = {
      'emotionId': entry['emotionId'],
      'emotionName': entry['emotionName'],
      'prompt': entry['prompt'],
      'text': entry['text'],
      'createdAt': now.toIso8601String(),
      'createdAtTs': Timestamp.fromDate(now), // buat sorting cepat
    };

    await _col().add(data);
  }

  /// Stream semua entries (baru → lama)
  static Stream<List<Map<String, dynamic>>> streamEntries() {
    return _col()
        .orderBy('createdAtTs', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  /// Delete 1 entry
  static Future<void> deleteEntry(String id) async {
    await _col().doc(id).delete();
  }
}
