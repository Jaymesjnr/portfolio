import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'resume.dart';
import 'projects.dart'; // contains ProjectShowcaseScreen and/or import Project model
import 'about.dart';
import 'contact.dart';
import '../models/project.dart'; // recommended: move Project model here

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define your projects here (or load from JSON / service)
  final List<Project> projects = [
    Project(
      title: 'Kyvaro Website',
      shortDescription: 'Responsive marketing site built with React and Tailwind.',
      images: [
        'lib/assets/kyvaro-ss.PNG',
      ],
      tech: 'HTML · Tailwind · Vercel',
      liveUrl: 'https://kyvaro.com',
      repoUrl: 'https://kyvaro.com',
    ),
     Project(
      title: 'Fundsverse Website',
      shortDescription: ' Created a modern, lightweight website optimized for performance. Designed custom layouts with burnt orange used consistently for links and highlights, and responsive design.',
      images: [
        'lib/assets/fsv-ss.PNG',
      ],
      tech: 'HTML · Tailwind · Vercel',
      liveUrl: 'https://fundsverse.io',
      repoUrl: 'https://fundsverse.io',
    ),
     Project(
      title: 'Portfolio Web & App',
      shortDescription: 'Developed a mobile app and website to show my developer profile and portfolio. Built with Flutter for cross-platform compatibility and Firebase for authentication, database, and cloud functions.',
      images: [
        'lib/assets/profile-ss.PNG',
      ],
      tech: 'Flutter · Firebase ·HTML · Tailwind · Vercel',
      liveUrl: 'https://jaymesjnr.vercel.app',
      repoUrl: 'https://github.com/jaymesjnr/portfolio',
    ),
  ];

  // Build screens at runtime so we can pass `projects`
  List<Widget> get _screens => [
        const ResumeScreen(),
        ProjectShowcaseScreen(projects: projects),
        const AboutScreen(),
        const ContactScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.mutedColor,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Resume'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Contact'),
        ],
      ),
    );
  }
}