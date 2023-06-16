class Table {
  Map<String, String> headers = {};
  Map<String, Map<String, dynamic>> translations = {};
  String charset = '';
  String contentType = 'utf-8';

  Table(Map<String, dynamic> table)
      : assert(table['headers'] is Map && (table['headers'] as Map).values.every((value) => value is String)),
        assert(table['translations'] is Map && (table['translations'] as Map).values.every((value) => value is Map)) {
    headers = Map.castFrom(table['headers'] as Map);
    translations = Map.castFrom(table['translations'] as Map);

    _handleCharset(table);
  }

  Table.fromCharset({this.charset = 'utf-8'});

  // Handles header values, replaces or adds (if needed) a charset property
  void _handleCharset(Map<String, dynamic> table) {
    final List<String> parts = (headers['content-type'] ?? 'text/plain').split(';');
    final String contentType = parts.first;
    parts.removeAt(0);
    // Support only utf-8 encoding
    const String charset = 'utf-8';

    final Iterable<String> params = parts.map((part) {
      final List<String> parts = part.split('=');
      final String key = parts.first.trim();

      if (key.toLowerCase() == 'charset') return 'charset=$charset';

      return part;
    });

    this.charset = charset;
    headers['content-type'] = '$contentType; ${params.join('; ')}';
  }

  Map<String, dynamic> get toMap {
    return {
      'charset': charset,
      'headers': headers,
      'translations': translations,
    };
  }
}
