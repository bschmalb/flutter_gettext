import 'package:flutter/material.dart';
import 'package:flutter_gettext/flutter_gettext/gettext_localizations.dart';

/// Extension for BuildContext to get translations.
extension ContextExt on BuildContext {
  String translate(
    String key, {
    String? keyPlural,
    List<Object>? pArgs,
    Map<String, Object>? nArgs,
    String? domain,
    String msgctxt = '',
  }) {
    return GettextLocalizations.of(this).translate(
      key,
      keyPlural: keyPlural,
      pArgs: pArgs,
      nArgs: nArgs,
      domain: domain,
      msgctxt: msgctxt,
    );
  }
}
