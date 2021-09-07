import 'package:factory_annotation/factory_annotation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'integration/redirected_constructor.dart';

void main() {
  test('handles redirected constructor', () async {
    final factory = RedirectedItemFactory();
    final object = factory.create(
      object: fromValue(
        const SomeConstantObject('hello world'),
      ),
    );

    expect(object.id, equals(RedirectedItemFactory.kId));
    expect(object.title, equals(RedirectedItemFactory.kTitle));
    expect(object.object, equals(ItemDeclaration.kConstantObjectDefault));
    expect(object.isPrimary, equals(ItemDeclaration.kIsPrimaryDefault));
  });
}
