import 'package:flutter/material.dart';
import 'package:lumiere/data/firestore/reflection_service.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Timeline'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ReflectionService.streamEntries(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snap.error}'),
              ),
            );
          }

          final entries = snap.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inbox_rounded, size: 44, color: textSub),
                    const SizedBox(height: 10),
                    const Text(
                      'Belum ada refleksi.',
                      style: TextStyle(
                        color: textMain,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tulis refleksi pertamamu dari halaman prompt.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textSub),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Kembali'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1B4B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final e = entries[i];
              final id = (e['id'] ?? '').toString();

              final emotionName = (e['emotionName'] ?? 'Unknown').toString();
              final prompt = (e['prompt'] ?? '').toString();
              final text = (e['text'] ?? '').toString();
              final createdAt = (e['createdAt'] ?? '').toString();

              return Container(
                padding: const EdgeInsets.all(14),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: const Color(0xFFA78BFA).withOpacity(0.12),
                            border: Border.all(
                              color: const Color(0xFFA78BFA).withOpacity(0.25),
                            ),
                          ),
                          child: Text(
                            emotionName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          createdAt.length >= 16
                              ? createdAt.substring(0, 16)
                              : createdAt,
                          style: const TextStyle(
                            color: textSub,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          tooltip: "Delete",
                          onPressed: () async {
                            await ReflectionService.deleteEntry(id);
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prompt,
                      style: const TextStyle(
                        color: textMain,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      text,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF334155),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
