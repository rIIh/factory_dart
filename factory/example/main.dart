// ignore_for_file: unused_local_variable

import 'package:factory_annotation/factory_annotation.dart';

part 'main.factory.dart';

class Item {
  final int left;
  final int right;

  const Item(this.left, this.right);
}

@Factory(Item)
class ItemFactory extends _$ItemFactory with FakerProviderMixin {
  ItemFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}

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
}
