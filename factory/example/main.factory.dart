// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target
// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_this

part of 'main.dart';

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

  int getLeft(FactoryContext context, ContextKey key) {
    try {
      return valueProvider!.getInt(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  int getRight(FactoryContext context, ContextKey key) {
    try {
      return valueProvider!.getInt(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  Item create({ValueBuilder<int>? left, ValueBuilder<int>? right}) {
    final _$objectBuilder = _ItemBuilder();
    this.context.add(_$objectBuilder.toReadOnly(), this.key);

    _$objectBuilder.left = (left ?? getLeft)(context, key + 'left');
    _$objectBuilder.right = (right ?? getRight)(context, key + 'right');

    {
      final object = _$objectBuilder.build();
      this.context.clear();
      return object;
    }
  }

  List<Item> batch(int length,
      {ValueBuilder<int>? left, ValueBuilder<int>? right}) {
    return List.generate(
      length,
      (index) => create(left: left, right: right),
    );
  }
}

class ItemReadonlyBuilder extends ObjectReadonlyBuilder<Item> {
  const ItemReadonlyBuilder(this.getLeft, this.getRight);

  final ValueGetter<int?> getLeft;

  final ValueGetter<int?> getRight;
}

class _ItemBuilder extends ObjectBuilder<Item> {
  int? left;

  int? right;

  ItemReadonlyBuilder toReadOnly() {
    return ItemReadonlyBuilder(() => left, () => right);
  }

  Item build() {
    try {
      final left = this.left!;
      final right = this.right!;

      return Item(left, right);
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}
