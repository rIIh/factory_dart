import 'package:sandbox/entity/item.dart';
import 'package:test/test.dart';

import '../factories/item_factory.dart';

void main() {
  Item item;

  // Create item with random [left] and [right] parameters
  // provided by [FakerProvider].
  item = ItemFactory()
      .create(); // creates Item(left: {random value}, right: {random value})

  // Provide explicit value of [left] parameter to constructor.
  item = ItemFactory().create(
    left: fromValue(10),
  ); // creates Item(left: 10, right: {random value})

  // Depend on [left] parameter when building [right] parameter.
  //
  // For now order of variables is crucial.
  // First parameters in constructor initialized earlier
  // of any further parameters.
  //
  // If we try to depend on [right] when instantiating [left] it will be null.
  item = ItemFactory().create(
    left: fromValue(10),
    right: (context, key) =>
        context.read<ItemReadonlyBuilder, Item>(key.up()).getLeft()! + 10,
  ); // creates Item(left: 10, right: 10 + 10)

  try {
    item = ItemFactory().create(
      left: (context, key) =>
          context.read<ItemReadonlyBuilder, Item>(key.up()).getRight()!,
      right: fromValue(10),
    ); // not creates item because left trying
    // to initialize before right initialized.
  } on Object {
    print('failed to create item');
  }

  // useless check, just to justify analyzer
  expect(item, isNotNull);
}
