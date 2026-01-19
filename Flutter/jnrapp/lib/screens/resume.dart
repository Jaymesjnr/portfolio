import 'package:flutter/material.dart';
import 'package:jnrapp/screens/about.dart';
import 'package:jnrapp/screens/contact.dart';
import 'package:jnrapp/screens/projects.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({Key? key}) : super(key: key);

  // Replace these with your real content
  static const _name = 'James Jnr';
  static const _role = 'Flutter & Web developer • UI Enthusiast';
  static const _summary =
      'I design and build polished cross‑platform mobile apps and websites. I focus on performance, '
      'accessible UI, and shipping delightful user experiences that make products shine.';

  final List<Map<String, String>> _experience = const [
    {
      'role': 'Independent Developer',
      'company': 'Self-Employed',
      'period': '2022 — Present',
      'desc': 'Designed and developed two live business websites, establishing professional online presence and brand identity.'
    },
    {
      'role': 'Mobile Developer',
      'company': 'Kyvaro',
      'period': '2024 — Present',
      'desc': 'Contributed to the development of a budgeting mobile app, enhancing user experience and implementing new features using Flutter.'
    },
  ];

  final List<Map<String, String>> _education = const [
    {
      'degree': 'B.Sc. Computer Science',
      'school': 'Wellspring University',
      'period': '2020 — 2024'
    },
    {
      'degree': 'Computer Professional (GMCPN)',
      'school': 'CPN',
      'period': '2024'
    },
    {
      'degree': 'Responsive Web Design',
      'school': 'Mimo',
      'period': '2020 — 2024'
    },
    {
      'degree': 'C & C# Programming',
      'school': 'Programming Hub',
      'period': '2023'
    },
    {
      'degree': 'Flutter, Web Development, Cloud Computing',
      'school': 'Online courses',
      'period': '2023 — Present'
    }
  ];

  final List<Map<String, dynamic>> _skills = const [
    {'name': 'Flutter', 'level': 0.92},
    {'name': 'Dart', 'level': 0.9},
    {'name': 'JavaScript', 'level': 0.85},
    {'name': 'HTML & CSS', 'level': 0.88},
    {'name': 'Firebase & Backend', 'level': 0.8},
    {'name': 'UI/UX', 'level': 0.82},
    {'name': 'Testing & CI', 'level': 0.78},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download CV',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading CV...')),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 1100 : 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroCard(name: _name, role: _role, summary: _summary),
                    const SizedBox(height: 20),
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: _LeftColumn(experience: _experience, education: _education)),
                              const SizedBox(width: 20),
                              Expanded(flex: 4, child: _RightColumn(skills: _skills)),
                            ],
                          )
                        : Column(
                            children: [
                              _RightColumn(skills: _skills),
                              const SizedBox(height: 18),
                              _LeftColumn(experience: _experience, education: _education),
                            ],
                          ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ProjectShowcaseScreen(projects: [],)),),
                            icon: const Icon(Icons.work_outline),
                            label: const Text('View Projects'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const AboutScreen()),),
                            icon: const Icon(Icons.person_outline),
                            label: const Text('About'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ContactScreen()),),
                          icon: const Icon(Icons.mail_outline),
                          tooltip: 'Contact',
                        )
                      ],
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Text(
                        '© 2026 James Jnr. All rights reserved.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String name;
  final String role;
  final String summary;

  const _HeroCard({required this.name, required this.role, required this.summary});

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);

  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column( // <-- changed from Row to Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'resume-avatar',
            child: CircleAvatar(
              radius: 46,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              backgroundImage: AssetImage('lib/assets/dp.JPG'), 
            ),
          ),
          const SizedBox(height: 16), // vertical spacing now
          Text(
            name,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            role,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(summary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ContactScreen()),),
            icon: const Icon(Icons.send_outlined),
            label: const Text('Contact'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    ),
  );
}
}

class _LeftColumn extends StatelessWidget {
  final List<Map<String, String>> experience;
  final List<Map<String, String>> education;

  const _LeftColumn({required this.experience, required this.education});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 6),
      const _SectionTitle(title: 'Experience'),
      const SizedBox(height: 8),
      ...experience.map((e) => _ExperienceCard(data: e)).toList(),
      const SizedBox(height: 18),
      const _SectionTitle(title: 'Education'),
      const SizedBox(height: 8),
      ...education.map((ed) => _EducationTile(data: ed)).toList(),
    ]);
  }
}

class _RightColumn extends StatelessWidget {
  final List<Map<String, dynamic>> skills;

  const _RightColumn({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle(title: 'Skills'),
      const SizedBox(height: 12),
      ...skills.map((s) => _SkillRow(name: s['name'] as String, level: s['level'] as double)).toList(),
      const SizedBox(height: 18),
      const _SectionTitle(title: 'Highlights'),
      const SizedBox(height: 8),
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('• Built a polished portfolio app and website with simulated auth flow'),
            SizedBox(height: 6),
            Text('• Designed and developed a responsive website to establish online presence for Kyvaro. Integrated Vercel Hosting for reliable deployment. Applied UI/UX principles for intuitive navigation and engaging visuals. Impact: increased brand visibility and customer engagement.'),
          ]),
        ),
      ),
    ]);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Map<String, String> data;
  const _ExperienceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(width: 6, height: 60, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(6))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${data['role']} • ${data['company']}', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(data['desc'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
            ]),
          ),
          const SizedBox(width: 12),
          Text(data['period'] ?? '', style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}

class _EducationTile extends StatelessWidget {
  final Map<String, String> data;
  const _EducationTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(contentPadding: EdgeInsets.zero, title: Text('${data['degree']}', style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text('${data['school']}'), trailing: Text('${data['period']}', style: Theme.of(context).textTheme.bodySmall));
  }
}

class _SkillRow extends StatefulWidget {
  final String name;
  final double level;
  const _SkillRow({required this.name, required this.level});

  @override
  State<_SkillRow> createState() => _SkillRowState();
}

class _SkillRowState extends State<_SkillRow> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600)), Text('${(widget.level * 100).round()}%', style: Theme.of(context).textTheme.bodySmall)]),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return LinearProgressIndicator(value: _anim.value * widget.level, minHeight: 8, backgroundColor: Colors.grey.shade300, color: Theme.of(context).colorScheme.primary);
          },
        ),
      ]),
    );
  }
}
