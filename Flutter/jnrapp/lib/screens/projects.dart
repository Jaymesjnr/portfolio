import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jnrapp/models/project.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectShowcaseScreen extends StatefulWidget {
  final List<Project> projects;

  const ProjectShowcaseScreen({Key? key, required this.projects}) : super(key: key);

  @override
  State<ProjectShowcaseScreen> createState() => _ProjectShowcaseScreenState();
}

class _ProjectShowcaseScreenState extends State<ProjectShowcaseScreen> {
  int _activeIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  Widget _buildImage(String src) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        src,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(src, fit: BoxFit.cover, errorBuilder: (c, e, s) {
            return Container(
              color: Colors.grey[900],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, color: Colors.white54, size: 48),
            );
          });
        },
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final projects = widget.projects;
  if (projects.isEmpty) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: Center(child: Text('No projects yet', style: theme.textTheme.bodyLarge)),
    );
  }

  final current = projects[_activeIndex];

  return Scaffold(
    // Prevent keyboard from resizing the layout unexpectedly; change to true if you want keyboard to push content.
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      centerTitle: true,
      elevation: 0,
    ),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // total usable height inside SafeArea
          final double totalHeight = constraints.maxHeight;

          // paddings used in the layout (top+bottom + gaps)
          const double verticalPadding = 12 + 24 + 12; // outer padding + gaps between sections
          // heights we want to reserve
          final double carouselHeight = (totalHeight * 0.32).clamp(160.0, 420.0);
          const double thumbnailsHeight = 64.0;
          // remaining height for details area
          final double detailsHeight = (totalHeight - carouselHeight - thumbnailsHeight - verticalPadding).clamp(120.0, double.infinity);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Carousel with explicit height
                SizedBox(
                  height: carouselHeight,
                  child: CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: current.images.length,
                    itemBuilder: (context, itemIndex, realIndex) {
                      final img = current.images[itemIndex];
                      return _buildImage(img);
                    },
                    options: CarouselOptions(
                      height: carouselHeight,
                      viewportFraction: 0.92,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Thumbnails row with fixed height
                SizedBox(
                  height: thumbnailsHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      final isActive = index == _activeIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _activeIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green[900] : Colors.grey[850],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isActive ? Colors.green : Colors.transparent),
                          ),
                          width: 200,
                          child: Row(
                            children: [
                              
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(p.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Details area with explicit height and internal scrolling
                SizedBox(
                  height: detailsHeight,
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(current.title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(current.shortDescription, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(label: Text(current.tech, style: const TextStyle(color: Colors.white))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: current.liveUrl.isNotEmpty ? () => _openUrl(current.liveUrl) : null,
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('View Live'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: current.repoUrl.isNotEmpty ? () => _openUrl(current.repoUrl) : null,
                                  icon: const Icon(Icons.code),
                                  label: const Text('View Code'),
                                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Optional extended content
                            Text('Role', style: theme.textTheme.titleSmall),
                            const SizedBox(height: 6),
                            Text('Lead developer — responsible for frontend, responsive layout, and deployment.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                            const SizedBox(height: 12),
                            Text('Highlights', style: theme.textTheme.titleSmall),
                            const SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('• Implemented responsive design and accessibility improvements', style: TextStyle(color: Colors.white70)),
                                Text('• Reduced load times by optimizing images and assets', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
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
}                     