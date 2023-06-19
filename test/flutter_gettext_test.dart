import 'package:flutter/material.dart';
import 'package:flutter_gettext/flutter_gettext.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app = buildMaterialApp(
    'de',
    (context) {
      return Column(
        children: [
          Text(context.t('Welcome to my app')),
          Text(
            context.t(
              'There is {0} apple',
              keyPlural: 'There are {0} apples',
              pArgs: [1],
            ),
          ),
          Text(
            context.t(
              'There is {0} apple',
              keyPlural: 'There are {0} apples',
              pArgs: [2],
            ),
          ),
          Text(
            context.t(
              'You have {message_count} message',
              keyPlural: 'You have {message_count} messages',
              nArgs: {'message_count': 1},
            ),
          ),
          Text(
            context.t(
              'You have {message_count} message',
              keyPlural: 'You have {message_count} messages',
              nArgs: {'message_count': 2},
            ),
          ),
        ],
      );
    },
  );

  group('Translation test', () {
    testWidgets('Test localization for one locale "de" with singular', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      await tester.pumpAndSettle();

      // Perform your test assertions here
      expect(find.text('Willkommen in meiner App'), findsOneWidget);
      expect(find.text('Es gibt 1 Apfel'), findsOneWidget);
      expect(find.text('Es gibt 2 Äpfel'), findsOneWidget);
      expect(find.text('Du hast 1 Nachricht'), findsOneWidget);
      expect(find.text('Du hast 2 Nachrichten'), findsOneWidget);
    });
  });
}

Widget buildMaterialApp(String locale, WidgetBuilder child) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: const [
      Locale('de'),
      Locale('de_AT'),
      Locale('en'),
    ],
    localizationsDelegates: [
      GettextLocalizationsDelegate(defaultLanguage: 'de'),
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: Builder(
      builder: (context) {
        return child(context);
      },
    ),
  );
}
