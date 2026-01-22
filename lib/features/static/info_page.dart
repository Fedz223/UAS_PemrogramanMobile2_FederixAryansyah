import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);
    const brand = Color(0xFF1E1B4B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Info & Help'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [brand, Color(0xFF60A5FA)],
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
                    Icons.help_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Guide',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Panduan singkat agar kamu nyaman mulai.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          _tile(
            icon: Icons.waving_hand_rounded,
            title: 'Mulai dari check-in',
            subtitle:
                'Di Home, pilih emosi yang paling mendekati kondisimu saat ini. Tidak harus “tepat”. Yang penting jujur.',
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.edit_note_rounded,
            title: 'Tulis refleksi singkat',
            subtitle:
                'Jawab prompt dengan 2–5 kalimat dulu. Kalau masih berat, tulis satu kalimat saja juga boleh.',
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.history_rounded,
            title: 'Buka Timeline',
            subtitle:
                'Timeline adalah tempat melihat jejak refleksi kamu. Cocok untuk melihat perubahan kecil dari waktu ke waktu.',
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.insights_rounded,
            title: 'Cek Insight',
            subtitle:
                'Insight membantu kamu melihat pola (misal emosi yang sering muncul) supaya kamu lebih paham diri sendiri.',
          ),
          const SizedBox(height: 10),

          _tile(
            icon: Icons.auto_awesome_rounded,
            title: 'Daily Light',
            subtitle:
                'Kadang kamu cuma butuh satu kalimat yang menenangkan. Daily Light ada untuk itu.',
          ),

          const SizedBox(height: 14),

          // Safety / Support
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A gentle note',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lumière dibuat untuk refleksi dan dukungan ringan, bukan pengganti bantuan profesional.\n\n'
                  'Kalau kamu merasa tidak aman atau butuh bantuan segera, tolong hubungi orang terdekat atau layanan profesional.',
                  style: TextStyle(color: textSub, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const brand = Color(0xFF1E1B4B);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: brand.withOpacity(0.08),
            ),
            child: Icon(icon, color: brand),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
