import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const brand = Color(0xFF1E1B4B);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('About Lumière'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [brand, Color(0xFFA78BFA)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LUMIÈRE',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Small reflections, brighter mind',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          _card(
            title: 'What is Lumière?',
            child: const Text(
              'Lumière adalah ruang refleksi yang ringan dan aman untuk membantu kamu mengenali perasaan, merapikan pikiran, dan membangun kebiasaan kecil yang menenangkan.\n\n'
              'Nama “Lumière” berarti “cahaya” — idenya sederhana: sedikit terang setiap hari bisa membuat pikiran terasa lebih lega.',
              style: TextStyle(color: textSub, height: 1.4),
            ),
          ),

          const SizedBox(height: 12),

          _card(
            title: 'How it helps',
            child: const Column(
              children: [
                _Bullet(
                  title: 'Emotional check-in',
                  text: 'Pilih emosi yang paling mendekati kondisimu saat ini.',
                ),
                _Bullet(
                  title: 'Guided reflection',
                  text:
                      'Ada prompt singkat supaya refleksi kamu nggak bingung mulai dari mana.',
                ),
                _Bullet(
                  title: 'Timeline',
                  text: 'Lihat jejak refleksi kamu agar terasa progresnya.',
                ),
                _Bullet(
                  title: 'Insight',
                  text:
                      'Dapatkan ringkasan pola emosi dari refleksi kamu (pelan-pelan).',
                ),
                _Bullet(
                  title: 'Daily Light',
                  text:
                      'Quote singkat sebagai “pengingat kecil” yang menenangkan.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _card(
            title: 'Tone & principle',
            child: const Text(
              'Lumière tidak menghakimi. Tidak ada “kamu harus begini”.\n\n'
              'Kamu cukup jujur, pelan-pelan, dan konsisten. Kalau suatu hari kamu tidak baik-baik saja, itu valid.',
              style: TextStyle(color: textSub, height: 1.4),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: brand.withOpacity(0.08),
                  ),
                  child: const Icon(Icons.favorite_rounded, color: brand),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'A gentle reminder: kamu nggak sendirian. Satu langkah kecil pun tetap langkah.',
                    style: TextStyle(
                      color: textMain,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    const textMain = Color(0xFF0F172A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String title;
  final String text;
  const _Bullet({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF1E1B4B);
    const textSub = Color(0xFF64748B);
    const textMain = Color(0xFF0F172A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 18, color: brand),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(color: textSub, height: 1.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
