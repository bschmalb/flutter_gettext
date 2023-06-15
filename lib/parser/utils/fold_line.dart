Iterable<String> foldLine(String str, [int maxLen = 76]) {
  final lines = <String>[];
  final len = str.length;
  StringBuffer curLineBuffer = StringBuffer();
  int pos = 0;

  if (len == 0) {
    return [''];
  }

  while (pos < len) {
    curLineBuffer = StringBuffer(str.substring(pos));

    if (curLineBuffer.length > maxLen) {
      curLineBuffer = StringBuffer(curLineBuffer.toString().substring(0, maxLen));
    }

    // ensure that the line never ends with a partial escaping
    // make longer lines if needed
    while (curLineBuffer.toString().endsWith(r'\') && pos + curLineBuffer.length < len) {
      curLineBuffer.write(str[pos + curLineBuffer.length]);
    }

    // ensure that if possible, line breaks are done at reasonable places
    Match? match = RegExp(r'.*?\\n').firstMatch(curLineBuffer.toString());
    if (match != null) {
      // use everything before and including the first line break
      curLineBuffer = StringBuffer(match[0]!);
    } else if (pos + curLineBuffer.length < len) {
      // if we're not at the end
      match = RegExp(r'.*\s+').firstMatch(curLineBuffer.toString());

      if (match != null && RegExp(r'\S').hasMatch(match[0]!)) {
        // use everything before and including the last white space character (if anything)
        curLineBuffer = StringBuffer(match[0]!);
      } else {
        match = RegExp(r'.*[\x21-\x2f0-9\x5b-\x60\x7b-\x7e]+').firstMatch(curLineBuffer.toString());

        if (match != null && RegExp(r'[^\x21-\x2f0-9\x5b-\x60\x7b-\x7e]').hasMatch(match[0]!)) {
          // use everything before and including the last "special" character (if anything)
          curLineBuffer = StringBuffer(match[0]!);
        }
      }
    }

    lines.add(curLineBuffer.toString());
    pos += curLineBuffer.length;
  }

  return lines;
}
