import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700));
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.green[900],
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar / logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CircleAvatar(
                        radius: 46,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                        backgroundImage: AssetImage('lib/assets/dp.JPG'), 
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Name + role
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('James Jnr', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text('Flutter & Web developer · UI/UX enthusiast', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                            const SizedBox(height: 8),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              _chip('Flutter'),
                              _chip('React'),
                              _chip('Tailwind'),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Short bio
                  _sectionTitle('About me'),
                  const SizedBox(height: 8),
                  Text(
                    'I build practical, maintainable apps and websites that balance clean UX with reliable engineering. I enjoy solving product problems, shipping features quickly, and iterating based on real user feedback. Outside of code I work on small businesses and creative projects — design, philosophy, and creating solutions',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),

                  const SizedBox(height: 16),

                  // Experience / timeline (compact)
                  _sectionTitle('Experience'),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _timelineRow('2022–Present', 'Independent Developer · Web & Mobile Development'),
                      const SizedBox(height: 8),
                      _timelineRow('2024–Present', 'Mobile Engineer & UI/UX Designer · Kyvaro.'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Skills grid
                  _sectionTitle('Skills'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _skillPill('Dart · Flutter'),
                      _skillPill('JavaScript · React'),
                      _skillPill('HTML · CSS · Tailwind'),
                      _skillPill('Figma · UI/UX Prototyping'),
                      _skillPill('Accessibility'),
                      _skillPill('Performance'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Contact / links
                  _sectionTitle('Contact'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _openUrl('mailto:juniord3mon@outlook.com'),
                        icon: const Icon(Icons.mail),
                        label: const Text('Email'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _openUrl('https://github.com/jaymesjnr'),
                        icon: const Icon(Icons.code),
                        label: const Text('GitHub'),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white12)),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Footer note
                  Center(
                    child: Text(
                      'Designed & built by James Jnr',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // small helpers
  Widget _timelineRow(String date, String role) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 92, child: Text(date, style: const TextStyle(color: Colors.white70, fontSize: 13))),
        Expanded(child: Text(role, style: const TextStyle(color: Colors.white))),
      ],
    );
  }

  Widget _skillPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70)),
    );
  }
}