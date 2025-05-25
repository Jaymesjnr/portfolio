import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jnr_app/widgets/habit_tile.dart';
import '../screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> markOnboarded(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Setup all default routines, habits, settings, journal
    await HabitService().quickSetupRoutines();

    // Update the onboarded flag
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'onboarded': true,
    });

    // Navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Trackr',
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Let’s build healthy habits together.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => markOnboarded(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
