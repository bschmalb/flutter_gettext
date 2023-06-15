import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gettext/gettext/gettext.dart';
import 'package:flutter_gettext/parser/gettext_parser.dart';

class GettextLocalizations {
  final _gt = Gettext(
    onWarning: ((message) {
      if (kDebugMode) {
        final r = RegExp(r'^No translation was found for msgid "(.*)" in msgctxt "(.*)" and domain "(.*)"$');
        final matches = r.firstMatch(message);
        var msgid = matches!.group(1);
        // ignore: avoid_print
        print('\nmsgid "$msgid"\nmsgstr ""\n \n');
      }
    }),
  );

  GettextLocalizations.fromPO(String poContent) {
    _gt.addLocale(po.parse(poContent));
  }

  static GettextLocalizations of(BuildContext context) =>
      Localizations.of<GettextLocalizations>(context, GettextLocalizations)!;

  String t(
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
      // final num? count = nArgs != null ? nArgs.values.firstWhereOrNull((e) => e is num) : pArgs?[0];
      final num? count = nArgs?.values.whereType<num?>().firstOrNull ?? pArgs?.whereType<num?>().firstOrNull;

      if (count == null) {
        throw ArgumentError(
          'You must provide a count argument as a number. Either as a named argument or as a positional argument',
        );
      }

      message = _gt.ngettext(
        key,
        keyPlural,
        count.toInt(),
        domain: domain,
        msgctxt: msgctxt,
      );
    } else {
      message = _gt.gettext(
        key,
        domain: domain,
        msgctxt: msgctxt,
      );
    }

    if (nArgs != null) {
      for (final entry in nArgs.entries) {
        message = message.replaceAll('{${entry.key}}', entry.value.toString());
      }
    } else if (pArgs != null) {
      for (var i = 0; i < pArgs.length; i++) {
        message = message.replaceAll('{$i}', pArgs[i].toString());
      }
    }

    return message;
  }
}
