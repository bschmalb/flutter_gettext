import 'package:flutter_gettext/parser/utils/upper_case_words.dart';

/// Joins a header object of key value pairs into a header string
String generateHeader(Map<String, dynamic> headers) {
  final lines = [];

  for (final key in headers.keys) {
    if (key.isNotEmpty) {
      lines.add('${upperCaseWords(key)}: ${(headers[key] ?? '').trim()}');
    }
  }

  return '${lines.join('\n')}${lines.isNotEmpty ? '\n' : ''}';
}
