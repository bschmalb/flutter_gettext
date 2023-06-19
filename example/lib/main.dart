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
        GettextLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.translate(
                    'There is {0} apple',
                    keyPlural: 'There are {0} apples',
                    pArgs: [1],
                  ),
                ),
                Text(
                  context.translate(
                    'There is {0} apple',
                    keyPlural: 'There are {0} apples',
                    pArgs: [2],
                  ),
                ),
                Text(
                  context.translate(
                    'You have {message_count} message',
                    keyPlural: 'You have {message_count} messages',
                    nArgs: {'message_count': 1},
                  ),
                ),
                Text(
                  context.translate(
                    'You have {message_count} message',
                    keyPlural: 'You have {message_count} messages',
                    nArgs: {'message_count': 3},
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
