## 2.3.0

- fix: avoid `loadString` isolate decoding for large `.po` assets so widget tests do not hang.
- fix: skip `<lang>_null.po` asset lookups when a locale has no country code.
- fix: only reload gettext localizations when delegate configuration changes.
- feat: allow missing-translation warnings to be redirected or silenced.
- fix: clean up a PO compiler lint reported by `flutter analyze`.

## 2.2.0

- fix: use correct plural form for count=0 in default fallback (issue #2)
- build(android): upgrade gradle, agp, and kotlin for compatibility with latest flutter sdk

## 2.1.0

- feat: update flutter sdk (to >=3.8.1 <4.0.0) to fix intl >0.19.0 error

## 2.0.2

- feat: update flutter sdk (to >=3.0.6 <4.0.0) to fix intl error on newer flutter versions

## 2.0.1

- feat: disable error logging of missing translations in english, as the key is used as the translation
- fix: README.md example of translation function

## 2.0.0

- **BREAKING CHANGE**:
  - change name of translations function from `t` to `translate`
- Implement widget tests for translations

## 1.0.3

- Migrate plugin to a package to remove platform-agnostic code

## 1.0.2

- Add export of necessary classes and functions for usage in other modules
- Implement better linting
- Add example
- Add supported platforms to pubspec.yaml

## 1.0.1

- Remove collection dependency for better compatibility

## 1.0.0

- Initial release.
