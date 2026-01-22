import 'package:flutter/material.dart';

import 'package:lumiere/data/firestore/reflection_service.dart';

import 'package:lumiere/features/profile/profile_page.dart';
import 'package:lumiere/features/quotes/daily_light_page.dart';
import 'package:lumiere/features/reflection/insight_page.dart';
import 'package:lumiere/features/reflection/prompt_page.dart';
import 'package:lumiere/features/reflection/timeline_page.dart';

// ✅ static pages
import 'package:lumiere/features/static/about_page.dart';
import 'package:lumiere/features/static/info_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class EmotionItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const EmotionItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class _HomePageState extends State<HomePage> {
  final List<EmotionItem> _emotions = const [
    EmotionItem(
      id: 'calm',
      name: 'Calm',
      icon: Icons.waves_rounded,
      color: Color(0xFF60A5FA),
    ),
    EmotionItem(
      id: 'happy',
      name: 'Happy',
      icon: Icons.sentiment_very_satisfied_rounded,
      color: Color(0xFFFBBF24),
    ),
    EmotionItem(
      id: 'sad',
      name: 'Sad',
      icon: Icons.sentiment_dissatisfied_rounded,
      color: Color(0xFF38BDF8),
    ),
    EmotionItem(
      id: 'anxious',
      name: 'Anxious',
      icon: Icons.psychology_rounded,
      color: Color(0xFFA78BFA),
    ),
    EmotionItem(
      id: 'angry',
      name: 'Angry',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFFB7185),
    ),
    EmotionItem(
      id: 'tired',
      name: 'Tired',
      icon: Icons.bedtime_rounded,
      color: Color(0xFF94A3B8),
    ),
    EmotionItem(
      id: 'grateful',
      name: 'Grateful',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF34D399),
    ),
    EmotionItem(
      id: 'overwhelmed',
      name: 'Overwhelmed',
      icon: Icons.bubble_chart_rounded,
      color: Color(0xFF818CF8),
    ),
  ];

  EmotionItem? _selected;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);
    const brand = Color(0xFF1E1B4B);

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: -120,
              top: -160,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFA78BFA).withOpacity(0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFA78BFA), Color(0xFF60A5FA)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA78BFA).withOpacity(0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LUMIÈRE',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: brand,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Small reflections, brighter mind',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: textSub, height: 1.2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Actions
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TimelinePage(),
                              ),
                            ),
                            icon: const Icon(Icons.history_rounded),
                            color: brand,
                            tooltip: 'Timeline',
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InsightPage(),
                              ),
                            ),
                            icon: const Icon(Icons.insights_rounded),
                            color: brand,
                            tooltip: 'Insight',
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DailyLightPage(),
                              ),
                            ),
                            icon: const Icon(Icons.auto_awesome_rounded),
                            color: brand,
                            tooltip: 'Daily Light',
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InfoPage(),
                              ),
                            ),
                            icon: const Icon(Icons.info_outline_rounded),
                            color: brand,
                            tooltip: 'Info',
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutPage(),
                              ),
                            ),
                            icon: const Icon(Icons.article_rounded),
                            color: brand,
                            tooltip: 'About',
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            ),
                            icon: const Icon(Icons.account_circle_rounded),
                            color: brand,
                            tooltip: 'Profile',
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'Hi there 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: textMain,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'How are you feeling right now?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textSub,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Status card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (_selected?.color ?? const Color(0xFFA78BFA))
                                    .withOpacity(0.95),
                                (_selected?.color ?? const Color(0xFFA78BFA))
                                    .withOpacity(0.55),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selected == null
                                    ? 'Pick an emotion to continue'
                                    : 'Selected: ${_selected!.name}',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: textMain,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selected == null
                                    ? 'Choose one that feels closest to your current state.'
                                    : 'Great. Next we’ll show a short prompt.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: textSub, height: 1.25),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: (_selected?.color ?? const Color(0xFFA78BFA))
                                .withOpacity(0.12),
                            border: Border.all(
                              color:
                                  (_selected?.color ?? const Color(0xFFA78BFA))
                                      .withOpacity(0.25),
                            ),
                          ),
                          child: Text(
                            _selected == null ? 'Check-in' : _selected!.name,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color:
                                      _selected?.color ??
                                      const Color(0xFFA78BFA),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.05,
                          ),
                      itemCount: _emotions.length,
                      itemBuilder: (context, i) {
                        final e = _emotions[i];
                        final isSelected = _selected?.id == e.id;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? e.color.withOpacity(0.55)
                                  : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? e.color.withOpacity(0.18)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: isSelected ? 22 : 14,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => setState(() => _selected = e),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: e.color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              gradient: LinearGradient(
                                                colors: [
                                                  e.color.withOpacity(0.55),
                                                  e.color.withOpacity(0.05),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: e.color.withOpacity(0.12),
                                      ),
                                      child: Icon(
                                        e.icon,
                                        color: e.color,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      e.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: textMain,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.2,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isSelected ? 'Selected' : 'Tap to choose',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? e.color
                                                : textSub,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Continue button (save to Firestore)
            Positioned(
              left: 16,
              right: 16,
              bottom: 12 + bottomPadding,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                offset: _selected == null ? const Offset(0, 0.35) : Offset.zero,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: _selected == null ? 0.0 : 1.0,
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _selected == null
                          ? null
                          : () async {
                              final e = _selected!;
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PromptPage(
                                    emotionId: e.id,
                                    emotionName: e.name,
                                    emotionColor: e.color,
                                    emotionIcon: e.icon,
                                  ),
                                ),
                              );

                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                await ReflectionService.addEntry(result);

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved to Cloud ✅'),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Continue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brand,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
