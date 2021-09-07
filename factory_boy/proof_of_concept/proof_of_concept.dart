import 'package:factory_boy/factory_boy.dart';
import 'package:faker/faker.dart';

import 'models.dart';

@Factory(Item)
class ItemFactory extends _$ItemFactory {
  ItemFactory([FactoryContext? context, ContextKey key = const ContextKey()])
      : super(context, key);

  @override
  String getName(FactoryContext context, ContextKey key) =>
      Faker().person.name();

  @override
  int getQuantity(FactoryContext context, ContextKey key) =>
      Faker().randomGenerator.integer(10);

  @override
  SubItem getSubItem(FactoryContext context, ContextKey key) =>
      SubItemFactory(context, key).create();
}

@Factory(SubItem)
class SubItemFactory extends _$SubItemFactory {
  SubItemFactory([FactoryContext? context, ContextKey key = const ContextKey()])
      : super(context, key);

  @override
  DateTime getCreated(FactoryContext context, ContextKey key) =>
      Faker().date.dateTime();
}

// Expected generated code below

abstract class _$ItemFactory {
  final bool isRoot;
  final FactoryContext context;
  final ContextKey key;

  _$ItemFactory([
    FactoryContext? context,
    this.key = const ContextKey(),
  ])  : isRoot = context == null,
        context = context ?? FactoryContext();

  String getName(FactoryContext context, ContextKey key);
  int getQuantity(FactoryContext context, ContextKey key);
  bool getFlag(FactoryContext context, ContextKey key) => false;
  SubItem getSubItem(FactoryContext context, ContextKey key);

  Item create({
    ValueBuilder<String>? name,
    ValueBuilder<int>? quantity,
    ValueBuilder<bool?>? flag,
  }) {
    final builder = _ItemBuilder();
    context.add(builder.toReadOnly(), key);

    builder.name = (name ?? getName)(context, key + 'name');
    builder.quantity = (quantity ?? getQuantity)(context, key + 'quantity');
    builder.flag = (flag ?? getFlag)(context, key + 'flag');

    final object = builder.build();
    context.clear();
    return object;
  }

  List<Item> batch(
    int length, {
    ValueBuilder<String>? name,
    ValueBuilder<int>? quantity,
    ValueBuilder<bool?>? flag,
  }) =>
      List.generate(
        length,
        (index) => create(
          name: name,
          quantity: quantity,
          flag: flag,
        ),
      );
}

class ItemReadonlyBuilder extends ObjectReadonlyBuilder<Item> {
  final ValueGetter<String?> getName;
  final ValueGetter<int?> getQuantity;
  final ValueGetter<bool?> getFlag;

  const ItemReadonlyBuilder(this.getName, this.getQuantity, this.getFlag);
}

class _ItemBuilder extends ObjectBuilder<Item> {
  String? name;
  int? quantity;
  bool? flag = false;

  ItemReadonlyBuilder toReadOnly() => ItemReadonlyBuilder(
        () => name,
        () => quantity,
        () => flag,
      );

  @override
  Item build() {
    try {
      final name = this.name!;
      final quantity = this.quantity!;
      final flag = this.flag!;

      return Item(
        name,
        quantity: quantity,
        flag: flag,
      );
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}

abstract class _$SubItemFactory {
  final bool isRoot;
  final ContextKey key;
  final FactoryContext context;

  _$SubItemFactory([
    FactoryContext? context,
    this.key = const ContextKey(),
  ])  : isRoot = context == null,
        context = context ?? FactoryContext();

  DateTime getCreated(FactoryContext builder, ContextKey key);
  DateTime? getUpdated(FactoryContext builder, ContextKey key) => null;

  SubItem create({DateTime? created, DateTime? updated}) {
    final builder = _SubItemBuilder();
    context.add(builder, key);
    builder.created = created ?? getCreated(context, key + 'created');
    builder.updated = updated ?? getUpdated(context, key + 'updated');
    return builder.build();
  }

  List<SubItem> batch(int length, {DateTime? created, DateTime? updated}) =>
      List.generate(
        length,
        (index) => create(
          created: created,
          updated: updated,
        ),
      );
}

class SubItemReadOnlyBuilder extends ObjectReadonlyBuilder<SubItem> {
  final ValueGetter<DateTime?> getCreated;
  final ValueGetter<DateTime?> getUpdated;

  const SubItemReadOnlyBuilder(this.getCreated, this.getUpdated);
}

class _SubItemBuilder extends ObjectBuilder<SubItem> {
  DateTime? created;
  DateTime? updated;

  SubItemReadOnlyBuilder toReadOnly() => SubItemReadOnlyBuilder(
        () => created,
        () => updated,
      );

  @override
  SubItem build() {
    try {
      final created = this.created!;
      final updated = this.updated;

      return SubItem(
        created,
        updated: updated,
      );
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}
