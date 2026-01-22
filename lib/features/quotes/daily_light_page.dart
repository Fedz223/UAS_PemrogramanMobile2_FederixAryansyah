import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lumiere/data/api/api_client.dart';
import 'package:lumiere/data/models/quote_item.dart';

class DailyLightPage extends StatefulWidget {
  const DailyLightPage({super.key});

  @override
  State<DailyLightPage> createState() => _DailyLightPageState();
}

class _DailyLightPageState extends State<DailyLightPage> {
  final _rand = Random();

  // fallback lokal
  final List<Map<String, String>> _localQuotes = const [
    {"text": "Kamu tidak harus kuat setiap hari.", "author": "LUMIÈRE"},
    {"text": "Pelan-pelan juga tetap maju.", "author": "LUMIÈRE"},
    {"text": "Perasaanmu valid. Kamu boleh istirahat.", "author": "LUMIÈRE"},
    {"text": "Hari berat tidak berarti hidupmu buruk.", "author": "LUMIÈRE"},
  ];

  late Map<String, String> _currentLocal;

  // REST state
  bool _loading = true;
  String? _error;
  List<QuoteItem> _apiQuotes = [];
  QuoteItem? _currentApi;

  @override
  void initState() {
    super.initState();
    _currentLocal = _localQuotes[_rand.nextInt(_localQuotes.length)];
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final raw = await ApiClient.getList('/quotes');
      _apiQuotes = raw
          .map((e) => QuoteItem.fromJson(e as Map<String, dynamic>))
          .toList();

      if (_apiQuotes.isNotEmpty) {
        _currentApi = _apiQuotes[_rand.nextInt(_apiQuotes.length)];
      }

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _newLocalQuote() {
    setState(() {
      _currentLocal = _localQuotes[_rand.nextInt(_localQuotes.length)];
    });
  }

  void _newQuote() {
    setState(() {
      if (_apiQuotes.isNotEmpty) {
        _currentApi = _apiQuotes[_rand.nextInt(_apiQuotes.length)];
      } else {
        _newLocalQuote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const brand = Color(0xFF1E1B4B);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);

    final text = _currentApi?.text ?? _currentLocal["text"]!;
    final author = _currentApi?.author ?? _currentLocal["author"]!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('Daily Light'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          children: [
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                'API gagal, pakai lokal: $_error',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
            const SizedBox(height: 12),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  color: Colors.white,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Column(
                      key: ValueKey(text),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 46,
                          color: Color(0xFFA78BFA),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '"$text"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: textMain,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '— $author',
                          style: const TextStyle(
                            color: textSub,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _newQuote,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('New quote'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: brand,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: BorderSide(color: brand.withOpacity(0.25)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved (dummy) ✅')),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add_rounded),
                    label: const Text('Save'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
