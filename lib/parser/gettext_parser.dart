library gettext_parser;

import 'dart:convert';

import 'package:flutter_gettext/parser/po/compiler.dart';
import 'package:flutter_gettext/parser/po/parser.dart';

const po = _Po();

class _Po {
  const _Po();

  /// Parse po [data] file with encoding
  Map<String, dynamic> parseBytes(List<int> data, {Encoding encoding = utf8}) {
    final parser = PoParser(encoding.decode(data));
    return parser.parse(charset: encoding.name);
  }

  /// Parse po file string
  Map<String, dynamic> parse(String text) {
    final parser = PoParser(text);
    return parser.parse(charset: utf8.name);
  }

  /// Converts [table] to a PO object
  String compile(Map table) {
    final compiler = PoCompiler(table);
    return compiler.compile();
  }
}
