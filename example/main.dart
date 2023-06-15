import 'package:flutter/material.dart';
import 'package:flutter_gettext/flutter_gettext/context_ext.dart';
import 'package:flutter_gettext/flutter_gettext/gettext_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('de'),
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
      ],
      localizationsDelegates: [
        GettextLocalizationsDelegate(defaultLanguage: 'de'),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                nArgs: {'message_count': 3},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
