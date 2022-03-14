import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'integration/generic_class.dart';

void main() {
  test('can create generic instances', () {
    final kValue = 'test string';
    final kOtherValue = 'other string';
    late GenericClass<String> value;

    value = GenericClassFactory<String>(kValue).create();
    expect(value.value, kValue);

    value = GenericClassFactory<String>()
        .create(value: (context, key) => kOtherValue);
    expect(value.value, kOtherValue);
  });
}
