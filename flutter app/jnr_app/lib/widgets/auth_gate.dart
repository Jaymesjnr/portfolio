import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jnr_app/widgets/habit_tile.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/welcome_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> handleUser(User user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    // If it's the user's first time, create their doc and setup routines
    if (!snapshot.exists) {
      await docRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName ?? '',
        'onboarded': false,
      });

      // Call quickSetup to create default habits
      await HabitService().quickSetupRoutines();
      return const WelcomeScreen();
    }

    // If the user hasn't completed onboarding
    if (snapshot.data()?['onboarded'] == false) {
      return const WelcomeScreen();
    }

    // User is ready for the home screen
    return const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: handleUser(snapshot.data!),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return futureSnapshot.data!;
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}