import 'package:flutter/material.dart';

import 'gettext_localizations.dart';

extension ContextExt on BuildContext {
  String t(
    String key, {
    String? keyPlural,
    List<Object>? pArgs,
    Map<String, Object>? nArgs,
    String? domain,
    String msgctxt = '',
  }) {
    return GettextLocalizations.of(this).t(
      key,
      keyPlural: keyPlural,
      pArgs: pArgs,
      nArgs: nArgs,
      domain: domain,
      msgctxt: msgctxt,
    );
  }
}
