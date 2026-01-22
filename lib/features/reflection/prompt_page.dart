import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lumiere/data/api/api_client.dart';
import 'package:lumiere/data/models/prompt_item.dart';
import 'package:lumiere/features/reflection/write_reflection_page.dart';

class PromptPage extends StatefulWidget {
  final String emotionId;
  final String emotionName;
  final Color emotionColor;
  final IconData emotionIcon;

  const PromptPage({
    super.key,
    required this.emotionId,
    required this.emotionName,
    required this.emotionColor,
    required this.emotionIcon,
  });

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  // ===== REST STATE =====
  bool _loading = true;
  String? _error;
  List<PromptItem> _apiPrompts = [];

  // ===== PROMPT VALUE =====
  late String _prompt;
  final _rand = Random();

  // ===== LOCAL FALLBACK =====
  final Map<String, List<String>> _promptBank = {
    'calm': [
      'Apa yang membuatmu merasa aman hari ini?',
      'Hal kecil apa yang ingin kamu pertahankan besok?',
      'Bagian mana dari hari ini yang paling kamu syukuri?',
    ],
    'happy': [
      'Apa yang membuatmu bahagia barusan?',
      'Siapa yang ingin kamu beri apresiasi hari ini?',
      'Bagaimana kamu bisa membagikan energi baik ini?',
    ],
    'sad': [
      'Hal apa yang paling berat kamu rasakan saat ini?',
      'Apa yang kamu butuhkan dari dirimu sendiri hari ini?',
      'Kalau kamu bicara ke teman, kamu ingin didengar seperti apa?',
    ],
    'anxious': [
      'Apa pemicu utama kecemasanmu saat ini?',
      'Apa 1 hal kecil yang bisa kamu kontrol sekarang?',
      'Jika ini terjadi lagi, bantuan apa yang kamu butuhkan?',
    ],
    'angry': [
      'Apa batasanmu yang mungkin terlanggar?',
      'Apa yang sebenarnya kamu butuhkan saat marah ini muncul?',
      'Apa cara aman untuk menyalurkan emosi ini?',
    ],
    'tired': [
      'Apa yang paling menguras energimu akhir-akhir ini?',
      'Apa yang bisa kamu tunda tanpa rasa bersalah?',
      'Istirahat bentuk apa yang paling kamu butuhkan?',
    ],
    'grateful': [
      'Sebutkan 3 hal kecil yang kamu syukuri hari ini.',
      'Siapa yang ingin kamu ucapkan terima kasih?',
      'Apa pelajaran baik yang kamu dapat minggu ini?',
    ],
    'overwhelmed': [
      'Kalau semua terasa banyak, apa yang paling mendesak?',
      'Apa 1 langkah kecil yang bisa kamu lakukan dalam 10 menit?',
      'Kalau kamu boleh minta bantuan, bantuan apa itu?',
    ],
  };

  @override
  void initState() {
    super.initState();
    _prompt = _pickPromptLocal(); // default dulu
    _loadPrompts(); // lalu coba ambil dari REST
  }

  Future<void> _loadPrompts() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final raw = await ApiClient.getList('/prompts');
      final list = raw
          .map((e) => PromptItem.fromJson(e as Map<String, dynamic>))
          .toList();

      _apiPrompts = list.where((p) => p.emotionId == widget.emotionId).toList();

      _prompt = _apiPrompts.isNotEmpty ? _pickPromptApi() : _pickPromptLocal();

      setState(() => _loading = false);
    } catch (e) {
      _prompt = _pickPromptLocal();
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String _pickPromptApi() {
    if (_apiPrompts.isEmpty) return _pickPromptLocal();
    final item = _apiPrompts[_rand.nextInt(_apiPrompts.length)];
    return item.text;
  }

  String _pickPromptLocal() {
    final list =
        _promptBank[widget.emotionId] ?? ['Apa yang kamu rasakan saat ini?'];
    return list[_rand.nextInt(list.length)];
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reflection Prompt'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'emotion-${widget.emotionId}',
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: widget.emotionColor.withOpacity(0.14),
                  border: Border.all(
                    color: widget.emotionColor.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.emotionIcon, color: widget.emotionColor),
                    const SizedBox(width: 8),
                    Text(
                      widget.emotionName,
                      style: const TextStyle(
                        color: textMain,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ indikator REST
            if (_loading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                'API gagal, pakai lokal: $_error',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],

            const SizedBox(height: 14),
            Text(
              'Take a slow breath.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textMain,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Answer this gently — no need to be perfect.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: textSub),
            ),
            const SizedBox(height: 14),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Container(
                key: ValueKey(_prompt),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  _prompt,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textMain,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _prompt = _apiPrompts.isNotEmpty
                            ? _pickPromptApi()
                            : _pickPromptLocal();
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Another'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WriteReflectionPage(
                            emotionId: widget.emotionId,
                            emotionName: widget.emotionName,
                            emotionColor: widget.emotionColor,
                            emotionIcon: widget.emotionIcon,
                            prompt: _prompt,
                          ),
                        ),
                      );

                      // ✅ penting: kirim balik ke Home
                      if (result != null && context.mounted) {
                        Navigator.pop(context, result);
                      }
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Write'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1B4B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
