# Flutter gettext

This package provides a simple way to translate your flutter application using gettext.

It is inspired/based on [gettext](https://pub.dev/packages/gettext) and [gettext_parser](https://pub.dev/packages/gettext_parser) and [gettext_i18n](https://pub.dev/packages/gettext_i18n) but **doesn't** depend on these packages.

## Features

- [x] Positional arguments
- [x] Named arguments
- [x] Plurals
- [x] Contexts
- [x] Comments

## Usage

Add this package, and flutter_localizations, to pubspec.yaml:

```shell
flutter pub add flutter_gettext
flutter pub add flutter_localizations --sdk=flutter
```

In `pubspec.yaml`, add `assets/i18n/` as an asset folder:

```yaml
flutter:
  assets:
    - assets/i18n/
```

Place your translation files in that folder:
```shell
$ ls assets/i18n/
en.po
de.po
de_AT.po
```

In your application file, declare supported locales, and initialize translations:

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        ...
        home: const HomePage(),
        supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('fr', 'CH'),
        ],
        localizationsDelegates: [
            GettextLocalizationsDelegate(defaultLanguage: 'en'),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
        ],
    );
  }
}
```

In files where you want to translate a string :

```dart
import 'package:gettext_i18n/gettext_i18n.dart';

Text(context.t('There is {0} apple', keyPlural: 'There are {0} apples', pArgs: [1]));
// output: There is 1 apple
// output(de): Es gibt 1 Apfel
Text(context.t('There is {0} apple', keyPlural: 'There are {0} apples', pArgs: [2]));
// output: There are 2 apples
// output(de): Es gibt 2 Äpfel

Text(
  context.t(
    'You have {message_count} message',
    keyPlural: 'You have {message_count} messages',
    nArgs: {'message_count': 1},
  ),
);
// output: You have 1 message
// output(de): Du hast 1 Nachricht

Text(
  context.t(
    'You have {message_count} message',
    keyPlural: 'You have {message_count} messages',
    nArgs: {'message_count': 3},
  ),
);
// output: You have 3 messages
// output(de): Du hast 3 Nachrichten
```

## po files structure
```po
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"
"Plural-Forms: nplurals=2; plural=(n != 1);\n"
"language: en\n"

msgid "Hello"
msgstr "Hello"

# Comments are ignored
msgid "Welcome to my app"
msgstr "Welcome to my app"

# Named argument implementation
msgid "You have {message_count} message"
msgid_plural "You have {message_count} messages"
msgstr[0] "You have {message_count} message"
msgstr[1] "You have {message_count} messages"

# Positional argument implementation
msgid "There is {0} apple"
msgid_plural "There are {0} apples"
msgstr[0] "There is {0} apple"
msgstr[1] "There are {0} apples"
```

## Additional information

`.po` files can be edited by hand, but it's preferable to use an editor or an online service to manage them.