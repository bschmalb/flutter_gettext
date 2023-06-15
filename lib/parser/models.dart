class Table {
  Map<String, String> headers = {};
  Map<String, Map<String, dynamic>> translations = {};
  String charset = "";
  String contentType = 'utf-8';

  Table(Map table) {
    assert(table["headers"] is Map && table["headers"].values.every((value) => value is String));
    assert(table['translations'] is Map && table['translations'].values.every((value) => value is Map));

    headers = Map.castFrom(table["headers"]);
    translations = Map.castFrom(table['translations']);

    _handleCharset(table);
  }

  Table.fromCharset({this.charset = 'utf-8'});

  // Handles header values, replaces or adds (if needed) a charset property
  void _handleCharset(Map table) {
    final List<String> parts = (headers['content-type'] ?? 'text/plain').split(';');
    final String contentType = parts.first;
    parts.removeAt(0);
    // Support only utf-8 encoding
    const String charset = 'utf-8';

    final Iterable params = parts.map((part) {
      final List<String> parts = part.split('=');
      final String key = parts.first.trim();

      if (key.toLowerCase() == 'charset') {
        return 'charset=$charset';
      }

      return part;
    });

    this.charset = charset;
    headers['content-type'] = '$contentType; ${params.join('; ')}';
  }

  void addString(String msgid, String msgstr) {
    final Map translation = {};
    String msgctxt, msgidPlural;

    final ids = msgid.split('\u0004');
    if (ids.length > 1) {
      msgctxt = ids.first;
      ids.removeAt(0);
      translation['msgctxt'] = msgctxt;
    } else {
      msgctxt = '';
    }
    msgid = ids.join('\u0004');

    final parts = msgid.split('\u0000');
    msgid = parts.first;
    parts.removeAt(0);

    translation['msgid'] = msgid;
    msgidPlural = parts.join('\u0000');

    if (msgidPlural.isNotEmpty) {
      translation['msgid_plural'] = msgidPlural;
    }

    translation['msgstr'] = msgstr.split('\u0000');

    if (!translations.containsKey(msgctxt)) {
      translations[msgctxt] = {};
    }

    translations[msgctxt]![msgid] = translation;
  }

  Map<String, dynamic> get toMap {
    return {
      'charset': charset,
      'headers': headers,
      'translations': translations,
    };
  }
}
