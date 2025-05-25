import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';

class HabitService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('habits');
  }

  Stream<List<Habit>> getHabits() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return _habitRef(uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Habit.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addHabit(String title) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _habitRef(uid).add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
      'completedDates': [],
    });
  }

  Future<void> deleteHabit(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _habitRef(uid).doc(id).delete();
  }

  Future<void> toggleCompletion(Habit habit, String date) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final completed = [...habit.completedDates];
    if (completed.contains(date)) {
      completed.remove(date);
    } else {
      completed.add(date);
    }

    await _habitRef(uid).doc(habit.id).update({'completedDates': completed});
  }

  Future<void> quickSetupRoutines() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _firestore.collection('users').doc(uid);

    final habitsRef = userRef.collection('habits');

    final existing = await habitsRef.get();
    if (existing.docs.isNotEmpty) return; // Prevent duplicate setup

    await habitsRef.add({
      'title': 'Drink water',
      'timeOfDay': 'morning',
      'completedDates': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    await habitsRef.add({
      'title': 'Walk 10 mins',
      'timeOfDay': 'afternoon',
      'completedDates': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    await habitsRef.add({
      'title': 'Read 5 pages',
      'timeOfDay': 'night',
      'completedDates': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    await userRef.collection('settings').doc('notificationPreferences').set({
      'pushEnabled': false,
    });

    final today = DateTime.now().toIso8601String().split('T').first;
    await userRef.collection('journal').doc(today).set({
      'entry': '',
      'date': today,
    });
  }
}
