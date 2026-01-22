import 'package:flutter/material.dart';

class WriteReflectionPage extends StatefulWidget {
  final String emotionId;
  final String emotionName;
  final Color emotionColor;
  final IconData emotionIcon;
  final String prompt;

  const WriteReflectionPage({
    super.key,
    required this.emotionId,
    required this.emotionName,
    required this.emotionColor,
    required this.emotionIcon,
    required this.prompt,
  });

  @override
  State<WriteReflectionPage> createState() => _WriteReflectionPageState();
}

class _WriteReflectionPageState extends State<WriteReflectionPage> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis refleksi dulu ya 🙂')),
      );
      return;
    }

    setState(() => _saving = true);

    // Simulasi save (nanti diganti Firestore)
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _saving = false);

    // Balik ke Home dengan hasil
    Navigator.pop(context, {
      'emotionId': widget.emotionId,
      'emotionName': widget.emotionName,
      'prompt': widget.prompt,
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF5F3FF);
    const textMain = Color(0xFF0F172A);
    const textSub = Color(0xFF64748B);

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Write Reflection'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emotion chip (Hero biar nyambung tetap keren)
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

                const SizedBox(height: 14),

                // Prompt card kecil
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    widget.prompt,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textMain,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Your reflection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textMain,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tulis bebas. Tidak perlu panjang.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: textSub),
                ),
                const SizedBox(height: 10),

                // Text area card
                Expanded(
                  child: Container(
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
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Contoh: Aku merasa cemas karena tugas menumpuk, tapi aku bisa mulai dari 1 hal kecil...',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 90), // ruang untuk tombol sticky
              ],
            ),
          ),

          // Sticky Save Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 12 + bottomPadding,
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(_saving ? 'Saving...' : 'Save Reflection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1B4B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
