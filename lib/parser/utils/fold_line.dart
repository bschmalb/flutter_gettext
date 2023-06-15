Iterable<String> foldLine(String str, [int maxLen = 76]) {
  final lines = <String>[];
  final len = str.length;
  String curLine = '';
  int pos = 0;

  if (len == 0) {
    return [""];
  }

  while (pos < len) {
    curLine = str.substring(pos);

    if (curLine.length > maxLen) {
      curLine = curLine.substring(0, maxLen);
    }

    // ensure that the line never ends with a partial escaping
    // make longer lines if needed
    while (curLine.endsWith(r'\') && pos + curLine.length < len) {
      curLine += str[pos + curLine.length];
    }

    // ensure that if possible, line breaks are done at reasonable places
    Match? match = RegExp(r".*?\\n").firstMatch(curLine);
    if (match != null) {
      // use everything before and including the first line break
      curLine = match[0]!;
    } else if (pos + curLine.length < len) {
      // if we're not at the end
      match = RegExp(r".*\s+").firstMatch(curLine);

      if (match != null && RegExp(r"[^\s]").hasMatch(match[0]!)) {
        // use everything before and including the last white space character (if anything)
        curLine = match[0]!;
      } else {
        match = RegExp(r'.*[\x21-\x2f0-9\x5b-\x60\x7b-\x7e]+').firstMatch(curLine);

        if (match != null && RegExp(r'[^\x21-\x2f0-9\x5b-\x60\x7b-\x7e]').hasMatch(match[0]!)) {
          // use everything before and including the last "special" character (if anything)
          curLine = match[0]!;
        }
      }
    }

    lines.add(curLine);
    pos += curLine.length;
  }

  return lines;
}
