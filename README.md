List of ISO 3166-1 assigned country codes.


## Features
* [x] ISO 3166-1 alpha-2. alpha-3, and numeric country codes in enum-like class
* [x] Support for [user-assigned code elements](https://en.wikipedia.org/wiki/ISO_3166-1#Reserved_and_user-assigned_code_elements)
* [x] Parsing of country codes from string
* [x] Localized country names
* [x] Country dial codes


## Usage

```dart
import 'package:country_code/country_code.dart';

var code = CountryCode.tryParse("US");
if (code == CountryCode.US) {
  print(code.alpha2);
  print(code.alpha3);
  print(code.numeric);
  print(code.dialCode);
  print(code.localizedName);
}
```
[See more examples](https://github.com/bohdan1krokhmaliuk/dart.country/tree/master/example)


## Bugs and feature requests

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/bohdan1krokhmaliuk/dart.country/issues
