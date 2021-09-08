import 'package:factory_annotation/factory_annotation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'integration/redirected_constructor.dart';
import 'test_helpers/test_generated_output.dart';

void main() {
  const target = 'redirected_constructor';

  testOutput(target);

  test('handles redirected constructor', () async {
    final factory = RedirectedItemFactory();
    final object = factory.create(
      object: fromValue(
        const SomeConstantObject('hello world'),
      ),
    );

    expect(object.id, equals(RedirectedItemFactory.kId));
    expect(object.title, equals(RedirectedItemFactory.kTitle));
  });

  test(
    'handles default values in redirected constructor',
    () {
      final factory = RedirectedItemFactory();
      final object = factory.create(
        object: fromValue(
          const SomeConstantObject('hello world'),
        ),
      );

      expect(object.object, equals(ItemDeclaration.kConstantObjectDefault));
      expect(object.isPrimary, equals(ItemDeclaration.kIsPrimaryDefault));
    },
    skip: 'test is flaky while `analyzer` is below 2.0.0 version.',
  );
}
