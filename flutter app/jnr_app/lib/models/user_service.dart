import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> quickSetup() async {
    final uid = _auth.currentUser!.uid;
    final userDoc = _firestore.collection('users').doc(uid);

    final exists = (await userDoc.get()).exists;
    if (exists) return; // Already setup

    await userDoc.set({'createdAt': Timestamp.now()});
    await userDoc.collection('habits').add({
      'title': 'Drink Water',
      'timeOfDay': 'morning',
      'completedDates': [],
    });
    await userDoc.collection('habits').add({
      'title': 'Walk 10 mins',
      'timeOfDay': 'afternoon',
      'completedDates': [],
    });
    await userDoc.collection('habits').add({
      'title': 'Read 5 pages',
      'timeOfDay': 'night',
      'completedDates': [],
    });
  }
}
