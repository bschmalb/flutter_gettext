import 'package:flutter_gettext/gettext/plurals.dart';

typedef OnWarning = Function(String message);

/// Class for translating strings using gettext textdomains.
class Gettext {
  final Map<String, Catalog> catalogs = {};
  final OnWarning? onWarning;

  Gettext({this.onWarning});

  int Function(int) _pluralsFunc = (n) => 0;
  String _locale = '';
  final String domain = 'messages';

  /// Returns current locale
  String get locale => _locale;

  /// Set current locale
  set locale(String value) {
    _locale = value;

    final plural = plurals[getLanguageCode(_locale)];
    if (plural != null) _pluralsFunc = plural.pluralsFunc;
  }

  /// Adds new locale to gettext
  ///
  /// ```dart
  /// final translations = {
  ///   "myContext": {
  ///      "hello": {
  ///          "msgstr": ["hola"]
  ///      }
  ///   }
  /// }
  ///
  /// final locale = {
  ///   "headers": {
  ///     "language": "es"
  ///   },
  ///   "translations": translations
  /// }
  ///
  /// gt.addLocale(locale, domain: 'messages');
  /// ```
  ///
  /// Params:
  /// [locale] A locale string
  /// [domain] A domain name
  void addLocale(Map<String, dynamic> data, {String domain = 'messages'}) {
    assert(data['headers'] is Map<String, String>);
    assert(data['translations'] is Map<String, dynamic>);
    addTranslations(
      data['headers']['language'] as String,
      data['translations'] as Map<String, dynamic>,
      domain: domain,
    );
  }

  /// Stores a set of translations in the set of gettext catalogs.
  ///
  /// ```dart
  /// final translations = {
  ///   "myContext": {
  ///      "hello": {
  ///          "msgstr": ["hola"]
  ///      }
  ///   }
  /// }
  ///
  /// gt.addTranslations('es-ES', translations, domain: 'messages')
  /// ```
  ///
  /// Params:
  /// [locale] A locale string
  /// [domain] A domain name
  /// [translations] An object of gettext-parser JSON shape
  void addTranslations(
    String locale,
    Map<String, dynamic> translations, {
    String domain = 'messages',
  }) {
    final catalog = catalogs[locale] ?? Catalog({});
    catalog.addTranslations(domain, Translations.fromJson(translations));

    setCatalog(locale, catalog);

    if (_locale.isEmpty) this.locale = locale;
  }

  /// Load ready to use [catalog] for the [locale]
  void setCatalog(String locale, Catalog catalog) {
    catalogs[locale] = catalog;
  }

  /// Translates a string using the default textdomain
  ///
  /// ```dart
  /// gt.gettext('Some text')
  /// ```
  ///
  /// @param  msgid  String to be translated
  /// @returns Translation or the original string if no translation was found
  String gettext(
    String msgid, {
    String? domain,
    String msgctxt = '',
  }) {
    final translation = _getTranslation(domain ?? this.domain, msgctxt, msgid);

    if (translation == null || translation.msgstr[0].isEmpty) {
      _warn('No translation was found for '
          'msgid "$msgid" in msgctxt "$msgctxt" and domain "$domain"');
      return msgid;
    }

    return translation.msgstr[0];
  }

  /// Translates a plural string using the default textdomain
  ///
  /// ```dart:
  ///     gt.ngettext('One thing', 'Many things', numberOfThings)
  /// ```
  ///
  /// @param  msgid        String to be translated when count is not plural
  /// @param  msgidPlural  String to be translated when count is plural
  /// @param  count        Number count for the plural
  /// @returns Translation or the original string if no translation was found
  String ngettext(
    String msgid,
    String msgidPlural,
    int count, {
    String? domain,
    String msgctxt = '',
  }) {
    final translation = _getTranslation(domain ?? this.domain, msgctxt, msgid);

    final index = _pluralsFunc(count);

    if (translation == null || translation.msgstr.length <= index || translation.msgstr[index].isEmpty) {
      _warn('No translation was found for '
          'msgid "$msgid" in msgctxt "$msgctxt" and domain "$domain"');
      return (count > 1) ? msgidPlural : msgid;
    }

    return translation.msgstr[index];
  }

  /// Retrieves translation object from the domain and context
  ///
  /// @private
  /// @param domain   A gettext domain name
  /// @param msgctxt  Translation context
  /// @param msgid    String to be translated
  /// @returns Translation object or null if not found
  Translation? _getTranslation(String domain, String msgctxt, String msgid) {
    return catalogs[_locale]?.getTranslation(domain, msgctxt, msgid);
  }

  /// Returns the language code part of a locale
  ///
  /// ```dart
  /// Gettext.getLanguageCode('sv-SE'); // -> "sv"
  /// ```
  ///
  /// @param locale A case-insensitive locale string
  /// @returns A language code
  static String getLanguageCode(String locale) {
    return locale.split(RegExp(r'[\-_]'))[0].toLowerCase();
  }

  void _warn(String message) => onWarning?.call(message);
}

/// Represents locale translations catalog
class Catalog {
  Map<String, Translations> domains;

  Catalog(this.domains);

  /// Get translation by message id, context and domain
  Translation? getTranslation(String domain, String msgctxt, String msgid) {
    return domains[domain]?.getTranslation(msgctxt, msgid);
  }

  /// Add translations in some domain
  void addTranslations(String domain, Translations translations) {
    domains[domain] = translations;
  }
}

/// Represents translation domain
class Translations {
  final Map<String, Map<String, Translation>> contexts;

  const Translations(this.contexts);

  /// Factory to get translations from generic json structure
  ///
  /// ```dart
  /// final translations = Translations.fromJson({
  ///    "myContext": {
  ///        "hello": {
  ///           "msgstr": ["hola"]
  ///        }
  ///    }
  /// })
  /// ```
  factory Translations.fromJson(Map<String, dynamic> contexts) {
    return Translations(
      contexts.map((key, value) {
        final values = <String, Translation>{};

        if (value is Map<String, dynamic>) {
          value.forEach((msgid, json) {
            if (json is Map && json['msgstr'] is List) {
              values[msgid] = Translation(
                (json['msgstr'] as List).map((row) => row.toString()).cast<String>().toList(),
                comments: json['comments'] as Map<String, dynamic>?,
              );
            }
          });
        }

        return MapEntry<String, Map<String, Translation>>(key, values);
      }),
    );
  }

  /// Get translation by message id and context
  Translation? getTranslation(String msgctxt, String msgid) {
    return contexts[msgctxt]?[msgid];
  }
}

/// Data class that represents a translation entry
class Translation {
  final List<String> msgstr;
  final Map<String, dynamic>? comments;

  const Translation(this.msgstr, {this.comments});
}
