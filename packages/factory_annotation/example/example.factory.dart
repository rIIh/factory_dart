// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'example.dart';

// **************************************************************************
// FactoryGenerator
// **************************************************************************

abstract class _$ItemFactory extends ObjectFactory<Item> {
  _$ItemFactory([FactoryContext? context, this.key = defaultKey])
      : isRoot = context == null,
        context = context ?? FactoryContext();

  final bool isRoot;

  final FactoryContext context;

  final ContextKey key;

  String getName(FactoryContext context, ContextKey key) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  int getQuantity(FactoryContext context, ContextKey key);
  bool getFlag(FactoryContext context, ContextKey key) {
    return false;
  }

  SubItem? getSubItem(FactoryContext context, ContextKey key) {
    return null;
  }

  Item create(
      {ValueBuilder<String>? name,
      ValueBuilder<int>? quantity,
      ValueBuilder<bool>? flag,
      ValueBuilder<SubItem?>? subItem}) {
    final builder = _ItemBuilder();
    context.add(builder.toReadOnly(), key);

    builder.name = (name ?? getName)(context, key + 'name');
    builder.quantity = (quantity ?? getQuantity)(context, key + 'quantity');
    builder.flag = (flag ?? getFlag)(context, key + 'flag');
    builder.subItem = (subItem ?? getSubItem)(context, key + 'subItem');

    final object = builder.build();
    context.clear();
    return object;
  }

  List<Item> batch(int length,
      {ValueBuilder<String>? name,
      ValueBuilder<int>? quantity,
      ValueBuilder<bool>? flag,
      ValueBuilder<SubItem?>? subItem}) {
    return List.generate(
      length,
      (index) =>
          create(name: name, quantity: quantity, flag: flag, subItem: subItem),
    );
  }
}

class ItemReadonlyBuilder extends ObjectReadonlyBuilder<Item> {
  const ItemReadonlyBuilder(
      this.getName, this.getQuantity, this.getFlag, this.getSubItem);

  final ValueGetter<String?> getName;

  final ValueGetter<int?> getQuantity;

  final ValueGetter<bool> getFlag;

  final ValueGetter<SubItem?> getSubItem;
}

class _ItemBuilder extends ObjectBuilder<Item> {
  String? name;

  int? quantity;

  bool flag = false;

  SubItem? subItem;

  ItemReadonlyBuilder toReadOnly() {
    return ItemReadonlyBuilder(
        () => name, () => quantity, () => flag, () => subItem);
  }

  Item build() {
    try {
      final name = this.name!;
      final quantity = this.quantity!;
      final flag = this.flag;
      final subItem = this.subItem;

      return Item(name, quantity: quantity, flag: flag, subItem: subItem);
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}

abstract class _$SubItemFactory {
  _$SubItemFactory([FactoryContext? context, this.key = defaultKey])
      : isRoot = context == null,
        context = context ?? FactoryContext();

  final bool isRoot;

  final FactoryContext context;

  final ContextKey key;

  DateTime getCreated(FactoryContext context, ContextKey key);
  DateTime? getUpdated(FactoryContext context, ContextKey key) {
    return null;
  }

  SubItem create(
      {ValueBuilder<DateTime>? created, ValueBuilder<DateTime?>? updated}) {
    final builder = _SubItemBuilder();
    context.add(builder.toReadOnly(), key);

    builder.created = (created ?? getCreated)(context, key + 'created');
    builder.updated = (updated ?? getUpdated)(context, key + 'updated');

    final object = builder.build();
    context.clear();
    return object;
  }

  List<SubItem> batch(int length,
      {ValueBuilder<DateTime>? created, ValueBuilder<DateTime?>? updated}) {
    return List.generate(
      length,
      (index) => create(created: created, updated: updated),
    );
  }
}

class SubItemReadonlyBuilder extends ObjectReadonlyBuilder<SubItem> {
  const SubItemReadonlyBuilder(this.getCreated, this.getUpdated);

  final ValueGetter<DateTime?> getCreated;

  final ValueGetter<DateTime?> getUpdated;
}

class _SubItemBuilder extends ObjectBuilder<SubItem> {
  DateTime? created;

  DateTime? updated;

  SubItemReadonlyBuilder toReadOnly() {
    return SubItemReadonlyBuilder(() => created, () => updated);
  }

  SubItem build() {
    try {
      final created = this.created!;
      final updated = this.updated;

      return SubItem(created, updated: updated);
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}
