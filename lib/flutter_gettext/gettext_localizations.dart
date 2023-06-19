import 'package:flutter/material.dart';
import 'package:flutter_gettext/gettext/gettext.dart';
import 'package:flutter_gettext/parser/gettext_parser.dart';

/// A class that holds the translations
class GettextLocalizations {
  final _gt = Gettext(onWarning: print);

  /// Write the translations from a PO file to the Gettext instance
  GettextLocalizations.fromPO(String poContent) {
    _gt.addLocale(po.parse(poContent));
  }

  /// Getter for localizations of context
  static GettextLocalizations of(BuildContext context) =>
      Localizations.of<GettextLocalizations>(context, GettextLocalizations)!;

  /// Returns the translation of a string
  /// ```dart
  /// context.t('Hello world');
  ///
  /// // You can also use named arguments:
  /// context.t('Hello {name}', nArgs: {'name': 'world'});
  ///
  /// // Or positional arguments:
  /// context.t('Hello {0}', pArgs: ['world']);
  ///
  /// // If you want to use plural forms, you can use the `keyPlural` argument:
  /// context.t('One thing', keyPlural: 'Many things', nArgs: {'count': 2});
  /// // or
  /// context.t('One thing', keyPlural: 'Many things', pArgs: [2]);
  /// ```
  ///
  /// @param key        String to be translated
  /// @param keyPlural  String to be translated when count is plural
  /// @param pArgs      Positional arguments
  /// @param nArgs      Named arguments
  /// @param domain     A gettext domain name
  /// @param msgctxt    Translation context
  /// @returns Translation or the original string if no translation was found
  ///
  /// @throws ArgumentError if both pArgs and nArgs are provided
  /// @throws ArgumentError if keyPlural is provided but no count argument is provided
  String translate(
    String key, {
    String? keyPlural,
    List<Object>? pArgs,
    Map<String, Object>? nArgs,
    String? domain,
    String msgctxt = '',
  }) {
    assert(
      pArgs == null || nArgs == null,
      'You can only use one of pArgs (position arguments) or nArgs (named arguments)',
    );
    late String message;

    if (keyPlural != null) {
      /// return pluralised translation
      final num? count = nArgs?.values.whereType<num?>().firstOrNull ?? pArgs?.whereType<num?>().firstOrNull;

      if (count == null) {
        throw ArgumentError('You must provide a count argument either as a named argument or as a positional argument');
      }

      message = _gt.ngettext(key, keyPlural, count.toInt(), domain: domain, msgctxt: msgctxt);
    } else {
      /// return singular translation
      message = _gt.gettext(key, domain: domain, msgctxt: msgctxt);
    }

    if (nArgs != null) {
      /// Replace named arguments
      for (final entry in nArgs.entries) {
        message = message.replaceAll('{${entry.key}}', entry.value.toString());
      }
    } else if (pArgs != null) {
      /// Replace positional arguments
      for (var i = 0; i < pArgs.length; i++) {
        message = message.replaceAll('{$i}', pArgs[i].toString());
      }
    }

    return message;
  }
}
