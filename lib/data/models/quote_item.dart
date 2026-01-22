class QuoteItem {
  final String id;
  final String text;
  final String author;

  QuoteItem({required this.id, required this.text, required this.author});

  factory QuoteItem.fromJson(Map<String, dynamic> json) {
    return QuoteItem(
      id: json['id'].toString(),
      text: (json['text'] ?? '').toString(),
      author: (json['author'] ?? 'LUMIÈRE').toString(),
    );
  }
}
