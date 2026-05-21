import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gettext/flutter_gettext/gettext_localizations.dart';
import 'package:flutter_gettext/gettext/gettext.dart';

/// LocalizationsDelegate for GettextLocalizations
class GettextLocalizationsDelegate
    extends LocalizationsDelegate<GettextLocalizations> {
  GettextLocalizationsDelegate({
    this.defaultLanguage = 'en',
    this.onWarning = print,
  });

  final String defaultLanguage;

  /// Sink for missing-translation warnings, forwarded to [GettextLocalizations].
  /// Defaults to [print]. Pass `null` to silence the warnings.
  final OnWarning? onWarning;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<GettextLocalizations> load(Locale locale) async {
    ByteData? data;

    // Only try the regional `<lang>_<country>.po` asset when a country code
    // is actually present, otherwise the path becomes `<lang>_null.po`.
    final countryCode = locale.countryCode;
    if (countryCode != null && countryCode.isNotEmpty) {
      data = await _tryLoad(
        'assets/i18n/${locale.languageCode}_$countryCode.po',
      );
    }

    data ??= await _tryLoad('assets/i18n/${locale.languageCode}.po');
    data ??= await _tryLoad('assets/i18n/$defaultLanguage.po');

    // If no PO file was found, use default strings.
    if (data == null) {
      return GettextLocalizations.fromPO(
        'msgid ""\nmsgstr ""\n"Language: $defaultLanguage\\n"\n',
        onWarning: onWarning,
      );
    }

    return GettextLocalizations.fromBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      onWarning: onWarning,
    );
  }

  /// Loads a `.po` asset as raw bytes, returning `null` if it does not exist.
  ///
  /// Uses `rootBundle.load` rather than `rootBundle.loadString` so the UTF-8
  /// decode stays on the main isolate. `loadString` offloads assets >= 50 KB
  /// to a background isolate via `compute()`, whose result never settles under
  /// the faked clock in `flutter_test`, hanging widget tests.
  Future<ByteData?> _tryLoad(String key) async {
    try {
      return await rootBundle.load(key);
    } catch (_) {
      return null;
    }
  }

  @override
  bool shouldReload(covariant GettextLocalizationsDelegate old) =>
      defaultLanguage != old.defaultLanguage || onWarning != old.onWarning;
}
