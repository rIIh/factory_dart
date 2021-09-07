import 'package:test/test.dart';

import 'integration/proof_of_concept.dart';

void main() {
  test('can create object', () {
    final factory = ItemFactory();
    final object = factory.create();

    expect(object, isA<Item>());
  });

  test('can create object with defined fields', () {
    final factory = ItemFactory();
    final object = factory.create(
      flag: fromValue(true),
      name: fromValue('test_name'),
      quantity: fromValue(10),
    );

    expect(object, isA<Item>());
    expect(object.name, equals('test_name'));
    expect(object.quantity, equals(10));
    expect(object.flag, isTrue);
  });

  test('can create list of objects', () {
    final factory = ItemFactory();
    final object = factory.create(
      flag: fromValue(true),
      name: fromValue('test_name'),
      quantity: fromValue(10),
    );

    expect(object, isA<Item>());
    expect(object.name, equals('test_name'));
    expect(object.quantity, equals(10));
    expect(object.flag, isTrue);
  });

  test('can access other props', () {
    const tName = 'Hello world';
    final factory = ItemFactory();
    final object = factory.create(
      name: fromValue(tName),
      quantity: (context, key) => context
          .read<ItemReadonlyBuilder, Item>(
            key.up(),
          )
          .getName()!
          .length,
    );

    expect(object.name, equals(tName));
    expect(object.quantity, equals(tName.length));
  });

  // TODO: add dependency graph building stage
  test('depends on order of properties', () {
    const tQuantity = 12;
    final factory = ItemFactory();
    expect(
      () => factory.create(
        quantity: fromValue(tQuantity),
        name: (context, key) => context
            .read<ItemReadonlyBuilder, Item>(
              key.up(),
            )
            .getQuantity()!
            .toString(),
      ),
      throwsA(isA<TypeError>()),
    );
  });

  test('can access upper builder', () {
    final factory = ItemFactory();
    final object = factory.create(
      quantity: fromValue(10),
      subItem: (context, key) => SubItemFactory(context, key).create(
        created: (context, key) => DateTime.fromMillisecondsSinceEpoch(
          context
              .read<ItemReadonlyBuilder, Item>(
                key.up().up(),
              )
              .getQuantity()!,
        ),
      ),
    );

    expect(object.subItem, isNotNull);
    expect(
      object.subItem!.created,
      equals(
        DateTime.fromMillisecondsSinceEpoch(10),
      ),
    );
  });
}
