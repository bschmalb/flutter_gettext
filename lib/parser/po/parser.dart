import 'package:flutter_gettext/parser/utils/first_where_or_null.dart';

/// Parses a PO file into a Map.
class PoParser {
  final String data;

  PoParser(this.data);

  Map<String, dynamic> parse({String? charset}) {
    final nodes = data.split(RegExp(r'\r?\n')).map(Node.parse).fold(
      <Node>[],
      _combine,
    );

    final list = nodes.fold(
      <Map<String, dynamic>>[],
      (List<Map<String, dynamic>> result, node) {
        if (result.isEmpty || node is BlockEnd) {
          result.add(<String, dynamic>{});
        }

        final item = result.last;

        if (node is Comment) {
          if (item['comments'] == null) {
            item['comments'] = <String, String>{};
          }

          item['comments'][node.type] = node.text;
        }

        if (node is Token) {
          if (node.type == 'msgstr') {
            if (!item.containsKey(node.type)) {
              item[node.type] = <String>[];
            }

            (item[node.type] as List).add(node.text);
          } else {
            item[node.type] = node.text;
          }
        }

        return result;
      },
    );

    final headers = <String, String>{};

    final head = list.tryFind((item) => item['msgctxt'] == null);

    if (head != null && head['msgstr'] != null) {
      final String comments = (head['msgstr'] as List).join();
      headers.addEntries(
        comments.split('\n').where((line) => line.contains(': ')).map(
          (line) {
            final delim = line.indexOf(': ');
            final key = line.substring(0, delim).toLowerCase();
            return MapEntry(key, line.substring(delim + 2));
          },
        ),
      );
    }

    final translations = <String, Map<String, dynamic>>{};

    for (final item in list) {
      final ctx = item['msgctxt'] as String? ?? '';
      final id = item['msgid'] as String? ?? '';

      if (!translations.containsKey(ctx)) {
        translations[ctx] = <String, dynamic>{};
      }

      translations[ctx]![id] = item;
    }

    return {
      'charset': charset,
      'headers': headers,
      'translations': translations,
    };
  }

  List<Node> _combine(List<Node> nodes, Node node) {
    if (nodes.isEmpty || !nodes.last.combine(node)) {
      nodes.add(node);
    }

    return nodes;
  }
}

class Node {
  bool combine(Node other) => false;

  static Node parse(String line) {
    if (line == '') {
      return BlockEnd();
    }

    if (line[0] == '#') {
      return Comment(line.substring(1).trim());
    }

    if (line.startsWith('msg')) {
      return Token(line);
    }

    if (line.startsWith('"')) {
      return StrLine(line);
    }

    throw const FormatException();
  }
}

class Comment extends Node {
  late String text;
  late String type;

  Comment(this.text) {
    if (text.length >= 2 && text[1] == ' ') {
      switch (text[0]) {
        case ':':
          type = 'reference';
          text = text.substring(2);
          return;
        case '.':
          type = 'extracted';
          text = text.substring(2);
          return;
        case ',':
          type = 'flag';
          text = text.substring(2);
          return;
        case '|':
          type = 'previous';
          text = text.substring(2);
          return;
      }
    }

    type = 'translator';
  }

  @override
  bool combine(Node other) {
    if (other is Comment && other.type == type) {
      text += '\n${other.text}';
      return true;
    }

    return false;
  }
}

class Token extends Node {
  late String type;
  late String text;
  int index = 0;

  Token(String line) {
    final pos = line.indexOf(' ');
    type = line.substring(0, pos);

    if (type.contains('[')) {
      index = int.parse(type.substring(type.indexOf('[') + 1, type.indexOf(']')));
      type = type.substring(0, type.indexOf('['));
    }

    text = _unescape(line.substring(pos + 1).trim());
  }

  @override
  bool combine(Node other) {
    if (other is StrLine) {
      text += other.text;
      return true;
    }

    return false;
  }
}

class StrLine extends Node {
  final String text;

  StrLine(String text) : text = _unescape(text);
}

class BlockEnd extends Node {}

const escape = '"';

String _unescape(String text) {
  if (!text.startsWith(escape) && text.endsWith(escape)) {
    return text;
  }

  final newText = text.substring(1, text.length - 1);

  return newText.replaceAll(r'\n', '\n').replaceAll(r"\'", "'").replaceAll(r'\"', '"').replaceAll(r'\t', '\t');
}
