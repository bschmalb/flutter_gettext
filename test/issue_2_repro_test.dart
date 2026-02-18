import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gettext/gettext/gettext.dart';

void main() {
  group('Issue #2 Reproduction', () {
    test(
      'ngettext returns plural for count=0 when no translation found (English default)',
      () {
        final gt = Gettext();
        // Emulating default behavior where no catalog is invoked or key not found
        // English rules: 0 is plural (e.g., "0 apples")

        const msgid = 'one apple';
        const msgidPlural = 'many apples';

        expect(
          gt.ngettext(msgid, msgidPlural, 0),
          equals(msgidPlural),
          reason: '0 should be plural',
        );
        expect(
          gt.ngettext(msgid, msgidPlural, 1),
          equals(msgid),
          reason: '1 should be singular',
        );
        expect(
          gt.ngettext(msgid, msgidPlural, 2),
          equals(msgidPlural),
          reason: '2 should be plural',
        );
      },
    );
  });
}
