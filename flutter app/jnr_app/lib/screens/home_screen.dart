import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jnr_app/widgets/habit_tile.dart';
import 'package:lottie/lottie.dart';
import '../models/habit.dart';
import 'journal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final HabitService habitService = HabitService();
  bool showConfetti = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String todayString = DateTime.now().toIso8601String().split('T').first;

  Future<void> _toggleHabitCompletion(Habit habit) async {
    final isCompletedToday = habit.completedDates.contains(todayString);

    final updatedDates = List<String>.from(habit.completedDates);
    if (isCompletedToday) {
      updatedDates.remove(todayString);
    } else {
      updatedDates.add(todayString);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .doc(habit.id)
        .update({'completedDates': updatedDates});

    _checkForCompletionCelebration();
  }

  void _checkForCompletionCelebration() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .get();

    final allCompleted = snapshot.docs.every((doc) {
      final data = doc.data();
      final completedDates = List<String>.from(data['completedDates'] ?? []);
      return completedDates.contains(todayString);
    });

    if (allCompleted && snapshot.docs.isNotEmpty) {
      // Trigger vibration
      HapticFeedback.mediumImpact();

      setState(() {
        showConfetti = true;
      });

      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        showConfetti = false;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _goToJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const JournalScreen()),
    );
  }

  Widget _buildHabitsByTime(String label, List<Habit> habits) {
    if (habits.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...habits.map((habit) {
          final completedToday = habit.completedDates.contains(todayString);
          return CheckboxListTile(
            title: Text(habit.title, style: const TextStyle(color: Colors.white)),
            value: completedToday,
            onChanged: (_) => _toggleHabitCompletion(habit),
            activeColor: Colors.orange,
            checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Greeting Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getGreeting(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: 'Aldrich',
                                color: Colors.white,
                              )),
                          const SizedBox(height: 4),
                          Text(user.email ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.book, color: Colors.white),
                      onPressed: _goToJournal,
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _logout,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Main Habit Tracker Section
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('habits')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final habits = snapshot.data!.docs
                          .map((doc) => Habit.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                          .toList();

                      final morning = habits.where((h) => h.timeOfDay == 'morning').toList();
                      final afternoon = habits.where((h) => h.timeOfDay == 'afternoon').toList();
                      final night = habits.where((h) => h.timeOfDay == 'night').toList();

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHabitsByTime("🌅 Morning", morning),
                            _buildHabitsByTime("☀️ Afternoon", afternoon),
                            _buildHabitsByTime("🌙 Night", night),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🎉 Confetti and Success Message
          if (showConfetti)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'lib/assets/confetti.json',
                    repeat: false,
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You've completed your daily habits!",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontFamily: 'Aldrich',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
