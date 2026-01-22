import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://696bb2f4624d7ddccaa1d5e5.mockapi.io';

  static Future<List<dynamic>> getList(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body);
    if (data is! List) throw Exception('Response bukan List');
    return data;
  }
}
