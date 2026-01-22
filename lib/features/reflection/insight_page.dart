import 'package:flutter/material.dart';
import 'package:lumiere/data/firestore/reflection_service.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

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
        title: const Text('Insight'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ReflectionService.streamEntries(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final entries = snap.data ?? [];
          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data untuk Insight.\nTulis refleksi dulu ya 🙂',
                textAlign: TextAlign.center,
                style: TextStyle(color: textSub),
              ),
            );
          }

          // hitung frekuensi emotion
          final Map<String, int> counts = {};
          for (final e in entries) {
            final name = (e['emotionName'] ?? 'Unknown').toString();
            counts[name] = (counts[name] ?? 0) + 1;
          }

          // urutkan
          final sorted = counts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final total = entries.length;
          final top = sorted.first;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your week in a glance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Total reflections: $total',
                      style: const TextStyle(color: textSub),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: brand.withOpacity(0.08),
                        border: Border.all(color: brand.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: brand),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Most frequent: ${top.key} (${top.value}x)',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: textMain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // list breakdown
              ...sorted.map((e) {
                final pct = (e.value / total);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            e.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: textMain,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${e.value}x',
                            style: const TextStyle(
                              color: textSub,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 10,
                          backgroundColor: const Color(0xFFE2E8F0),
                          color: brand,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
