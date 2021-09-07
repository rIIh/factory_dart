part "redirected_constructor.factory.dart";

@Factory(ItemDeclaration)
class ItemFactory extends _$ItemFactory {}

class ItemDeclaration {
  ItemDeclaration._();

  factory ItemDeclaration({
    required int id,
    required String title,
    bool isPrimary,
  }) = PrivateItemInterface;
}

abstract class PrivateItemInterface extends ItemDeclaration {
  factory PrivateItemInterface({
    required int id,
    required String title,
    bool isPrimary,
  }) = PrivateItemImplementation;

  PrivateItemInterface._() : super._();

  @override
  int get id => throw StateError('Private constructor used');
  @override
  String get title => throw StateError('Private constructor used');
  @override
  bool get isPrimary => throw StateError('Private constructor used');
}

class PrivateItemImplementation extends PrivateItemInterface {
  PrivateItemImplementation({
    required this.id,
    required this.title,
    this.isPrimary = false,
  }) : super._();

  @override
  final int id;
  @override
  final String title;
  @override
  final bool isPrimary;
}
