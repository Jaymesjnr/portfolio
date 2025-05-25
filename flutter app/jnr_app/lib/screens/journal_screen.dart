import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String today = DateTime.now().toIso8601String().split('T').first;

  Future<void> _saveJournal() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('journal')
        .doc(today)
        .set({'entry': _controller.text, 'date': today});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry saved!')),
    );
  }

  Future<void> _loadJournal() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('journal')
        .doc(today)
        .get();

    if (doc.exists) {
      _controller.text = doc['entry'] ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Journal',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Aldrich',
              fontSize: 18,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveJournal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          maxLines: null,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Write about today...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
