# Factory Repository

Factory is created to help define easy to use model factories with predefined field assignment behaviour.


![Factory title image](https://images2.imgbox.com/f9/33/4DBaGMQJ_o.png)

![Post object creation example](https://images2.imgbox.com/e4/56/ldRTzQbL_o.png)

![Required boilerplate](https://images2.imgbox.com/d6/0e/Zu9QxRV5_o.png)

## Usage

Mark target class with `Factory` annotation

```dart
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
```
