import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gettext/flutter_gettext.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _headerOnlyPo = 'msgid ""\nmsgstr ""\n"Language: de\\n"\n';

Widget _appForLocale(
  Locale locale,
  WidgetBuilder child, {
  OnWarning? onWarning = print,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [
      Locale('de'),
      Locale('de', 'AT'),
      Locale('en'),
      Locale('fi'),
    ],
    localizationsDelegates: [
      GettextLocalizationsDelegate(defaultLanguage: 'de', onWarning: onWarning),
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: Builder(builder: child),
  );
}

void main() {
  group('Issue #4 - load() must not hang for >= 50 KB .po files', () {
    test('a >= 50 KB catalog can be decoded without loadString', () {
      final localizations = GettextLocalizations.fromBytes(
        utf8.encode(_largePo()),
      );

      expect(
        localizations.translate('Welcome to my app'),
        'Tervetuloa sovellukseeni',
      );
    });
  });

  group(
    'Issue #5 - no *_null.po lookup when the locale has no country code',
    () {
      testWidgets('a country-less locale loads <lang>.po', (tester) async {
        final delegate = GettextLocalizationsDelegate(defaultLanguage: 'de');

        final localizations = await delegate.load(const Locale('de'));

        expect(localizations.translate('Hello'), 'Hallo');
      });

      testWidgets('a regional locale still prefers <lang>_<country>.po', (
        tester,
      ) async {
        final delegate = GettextLocalizationsDelegate(defaultLanguage: 'de');

        final localizations = await delegate.load(const Locale('de', 'AT'));

        // de_AT.po has the Austrian variant "Apfeli", de.po only has "Apfel".
        expect(
          localizations.translate(
            'There is {0} apple',
            keyPlural: 'There are {0} apples',
            pArgs: [1],
          ),
          'Es gibt 1 Apfeli',
        );
      });
    },
  );

  group('Issue #6 - shouldReload only when delegate config changed', () {
    test('equivalent delegates do not trigger a reload', () {
      final a = GettextLocalizationsDelegate(defaultLanguage: 'de');
      final b = GettextLocalizationsDelegate(defaultLanguage: 'de');

      expect(a.shouldReload(b), isFalse);
    });

    test('a changed defaultLanguage triggers a reload', () {
      final a = GettextLocalizationsDelegate(defaultLanguage: 'de');
      final b = GettextLocalizationsDelegate(defaultLanguage: 'en');

      expect(a.shouldReload(b), isTrue);
    });

    test('a changed onWarning sink triggers a reload', () {
      void warningA(String _) {}
      void warningB(String _) {}

      final a = GettextLocalizationsDelegate(
        defaultLanguage: 'de',
        onWarning: warningA,
      );
      final b = GettextLocalizationsDelegate(
        defaultLanguage: 'de',
        onWarning: warningB,
      );

      expect(a.shouldReload(b), isTrue);
    });
  });

  group('Issue #7 - configurable missing-translation warning sink', () {
    test('onWarning receives missing-translation warnings', () {
      final warnings = <String>[];
      final localizations = GettextLocalizations.fromPO(
        _headerOnlyPo,
        onWarning: warnings.add,
      );

      localizations.translate('Untranslated key');

      expect(warnings, isNotEmpty);
    });

    test('passing onWarning: null silences the warnings', () {
      final localizations = GettextLocalizations.fromPO(
        _headerOnlyPo,
        onWarning: null,
      );

      // Must not throw and must not write anywhere.
      expect(
        () => localizations.translate('Untranslated key'),
        returnsNormally,
      );
    });

    test('the delegate forwards onWarning to GettextLocalizations', () async {
      final warnings = <String>[];
      final delegate = GettextLocalizationsDelegate(
        defaultLanguage: 'de',
        onWarning: warnings.add,
      );

      final localizations = await delegate.load(const Locale('de'));
      localizations.translate('A key that is definitely not in de.po');

      expect(warnings, isNotEmpty);
    });
  });
}

String _largePo() {
  final buffer = StringBuffer()
    ..writeln('msgid ""')
    ..writeln('msgstr ""')
    ..writeln('"Content-Type: text/plain; charset=UTF-8\\n"')
    ..writeln('"Language: fi\\n"')
    ..writeln('"Plural-Forms: nplurals=2; plural=(n != 1);\\n"')
    ..writeln()
    ..writeln('msgid "Welcome to my app"')
    ..writeln('msgstr "Tervetuloa sovellukseeni"')
    ..writeln();

  var index = 0;
  while (utf8.encode(buffer.toString()).length < 50 * 1024) {
    buffer
      ..writeln('# Padding entry to keep this synthetic catalog over 50 KB.')
      ..writeln('msgid "padding entry number $index"')
      ..writeln('msgstr "taydennysmerkinta numero $index"')
      ..writeln();
    index++;
  }

  return buffer.toString();
}
