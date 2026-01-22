class PromptItem {
  final String id;
  final String emotionId;
  final String text;

  PromptItem({required this.id, required this.emotionId, required this.text});

  factory PromptItem.fromJson(Map<String, dynamic> json) {
    return PromptItem(
      id: json['id'].toString(),
      emotionId: (json['emotionId'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
    );
  }
}
