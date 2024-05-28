import 'package:factory_annotation/factory_annotation.dart';

part 'redirected_constructor.factory.dart';

@Factory(ItemDeclaration)
class RedirectedItemFactory extends _$RedirectedItemFactory {
  static const kId = 1357;
  static const kTitle = 'item_with_redirected_constuctor';

  RedirectedItemFactory([
    FactoryContext? context,
    ContextKey key = defaultKey,
  ]) : super(context, key);

  @override
  int getId(FactoryContext context, ContextKey key) => kId;

  @override
  String getTitle(FactoryContext context, ContextKey key) => kTitle;

  @override
  bool getIsPrimary(FactoryContext context, ContextKey key) {
    return false;
  }

  @override
  SomeConstantObject getObject(FactoryContext context, ContextKey key) {
    return SomeConstantObject('none');
  }
}

class SomeConstantObject {
  final String text;
  const SomeConstantObject(this.text);

  @override
  bool operator ==(Object other) =>
      other is SomeConstantObject && text == other.text;
}

class ItemDeclaration with _Interface {
  static const SomeConstantObject kConstantObjectDefault =
      SomeConstantObject('hello world');

  static const bool kIsPrimaryDefault = false;

  ItemDeclaration._();

  factory ItemDeclaration({
    required int id,
    required String title,
    bool isPrimary,
    SomeConstantObject object,
    String? nullableWithDefaultValue,
  }) = PrivateItemInterface;
}

mixin _Interface {
  int get id => throw StateError('Private constructor used');
  String get title => throw StateError('Private constructor used');
  bool get isPrimary => throw StateError('Private constructor used');
  SomeConstantObject get object => throw StateError('Private constructor used');
  String? get nullableWithDefaultValue =>
      throw StateError('Private constructor used');
}

abstract class PrivateItemInterface extends ItemDeclaration {
  factory PrivateItemInterface({
    required int id,
    required String title,
    bool isPrimary,
    SomeConstantObject object,
    String? nullableWithDefaultValue,
  }) = PrivateItemImplementation;

  PrivateItemInterface._() : super._();

  @override
  int get id => throw StateError('Private constructor used');
  @override
  String get title => throw StateError('Private constructor used');
  @override
  bool get isPrimary => throw StateError('Private constructor used');
  @override
  SomeConstantObject get object => throw StateError('Private constructor used');
  @override
  String? get nullableWithDefaultValue =>
      throw StateError('Private constructor used');
}

class PrivateItemImplementation extends PrivateItemInterface {
  PrivateItemImplementation({
    required this.id,
    required this.title,
    this.isPrimary = ItemDeclaration.kIsPrimaryDefault,
    this.object = ItemDeclaration.kConstantObjectDefault,
    this.nullableWithDefaultValue = 'Hello world',
  }) : super._();

  @override
  final int id;
  @override
  final String title;
  @override
  final bool isPrimary;
  @override
  final SomeConstantObject object;
  @override
  final String? nullableWithDefaultValue;
}
