// Copyright (c) 2019, Denis Portnov. All rights reserved.
// Released under MIT License that can be found in the LICENSE file.

import 'package:country_code/country_code.dart';
import 'package:test/test.dart';
import 'gold.dart';

void main() {
  group('ISO-assigned', () {
    test('Generated values are correct', () {
      final lines = isoGold.split('\n');
      for (int i = 0; i < lines.length; i++) {
        final fields = lines[i].split('\t');
        final c = CountryCode.values[i];

        expect(c.alpha2, fields[0]);
        expect(c.alpha3, fields[1]);
        expect(c.numeric, int.parse(fields[2]));
        expect(c.isUserAssigned, isFalse);

        expect(identical(CountryCode.values[c.index], c), isTrue);
      }
    });

    test('Generated values are statically accesible', () {
      final lines = isoGold.split('\n');
      for (int i = 0; i < lines.length; i++) {
        final fields = lines[i].split('\t');
        final n = int.parse(fields[2]);
        final c = CountryCode.values[i];

        expect(identical(CountryCode.parse(fields[1]), c), isTrue);
        expect(identical(CountryCode.ofAlpha(fields[0]), c), isTrue);
        expect(identical(CountryCode.ofAlpha(fields[1]), c), isTrue);
        expect(identical(CountryCode.ofNumeric(n), c), isTrue);
      }
    });

    test('Can be printed', () {
      expect(CountryCode.RU.toString(), 'CountryCode.RU');
    });
  });

  group('User-assigned', () {
    tearDown(() {
      CountryCode.unassignAll();
    });

    test('Can create user-assigned country code', () {
      const String a2 = 'QP';
      const String a3 = 'QPX';
      const int n = 910;

      final c = CountryCode.user(alpha2: a2, alpha3: a3, numeric: n);

      expect(c.alpha2, a2);
      expect(c.alpha3, a3);
      expect(c.numeric, n);
      expect(c.isUserAssigned, isTrue);

      // not statically accessible
      expect(() => CountryCode.ofAlpha(a2), throwsArgumentError);
    });

    test('Can not create user-assigned country with out of range code', () {
      const codesA2 = <String>['QL', 'ZA'];
      for (var code in codesA2) {
        expect(() => CountryCode.user(alpha2: code), throwsArgumentError);
      }

      const codesA3 = <String>['QLA', 'ZAA'];
      for (var code in codesA3) {
        expect(() => CountryCode.user(alpha3: code), throwsArgumentError);
      }

      const codesN = <int>[0, 899, 1000];
      for (var code in codesN) {
        expect(() => CountryCode.user(numeric: code), throwsArgumentError);
      }
    });

    test('Can be assigned with Alpha-2 only', () {
      const String a2 = 'QP';

      final int index = CountryCode.assign(alpha2: a2);
      final c = CountryCode.values[index];

      expect(c.alpha2, a2);
      expect(c.alpha3, '');
      expect(c.numeric, 0);
      expect(c.isUserAssigned, isTrue);
    });

    test('Can be assigned with Alpha-3 only', () {
      const String a3 = 'XXZ';

      final int index = CountryCode.assign(alpha3: a3);
      final c = CountryCode.values[index];

      expect(c.alpha2, '');
      expect(c.alpha3, a3);
      expect(c.numeric, 0);
      expect(c.isUserAssigned, isTrue);
    });

    test('Can be assigned with numeric only', () {
      const int n = 999;

      final int index = CountryCode.assign(numeric: n);
      final c = CountryCode.values[index];

      expect(c.alpha2, '');
      expect(c.alpha3, '');
      expect(c.numeric, n);
      expect(c.isUserAssigned, isTrue);
    });

    test('Can not assign same user code more than once', () {
      CountryCode.assign(alpha2: 'XA', alpha3: 'XAA', numeric: 900);
      expect(() => CountryCode.assign(alpha2: 'XA'), throwsStateError);
    });

    test('Can be checked for equality', () {
      final c1 = CountryCode.user(alpha2: 'ZZ');
      final c2 = CountryCode.user(alpha2: 'ZZ');

      expect(identical(c1, c2), isFalse);
      expect(c1, equals(c2));
    });

    test('Can be printed', () {
      expect(CountryCode.user(alpha2: 'ZZ').toString(), 'CountryCode.ZZ');
      expect(CountryCode.user(alpha3: 'ZZZ').toString(), 'CountryCode.ZZZ');
      expect(CountryCode.user(numeric: 999).toString(), 'CountryCode.999');
    });
  });
}
