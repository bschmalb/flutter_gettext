import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gettext/flutter_gettext/gettext_localizations.dart';

class GettextLocalizationsDelegate extends LocalizationsDelegate<GettextLocalizations> {
  GettextLocalizationsDelegate({this.defaultLanguage = 'en'});

  final String defaultLanguage;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<GettextLocalizations> load(Locale locale) async {
    var poContent = '';
    try {
      poContent = await rootBundle.loadString('assets/i18n/${locale.languageCode}_${locale.countryCode}.po');
    } catch (e) {
      try {
        poContent = await rootBundle.loadString('assets/i18n/${locale.languageCode}.po');
      } catch (e) {
        try {
          poContent = await rootBundle.loadString('assets/i18n/$defaultLanguage.po');
        } catch (e) {
          // Ignore error, default strings will be used.
        }
      }
    }

    if (poContent == '') {
      poContent = 'msgid ""\nmsgstr ""\n"Language: $defaultLanguage\\n"\n';
    }

    return GettextLocalizations.fromPO(poContent);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<GettextLocalizations> old) => true;
}
