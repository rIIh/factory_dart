import 'package:factory_annotation/factory_annotation.dart';

part 'enum_parameter.factory.dart';

enum EnumItem { a, b, c }

class EnumParameterItem {
  final EnumItem item;

  EnumParameterItem(this.item);
}

@Factory(EnumParameterItem)
class EnumParameterItemFactory extends _$EnumParameterItemFactory
    implements ObjectFactory<EnumParameterItem> {
  EnumParameterItemFactory([
    FactoryContext? context,
    ContextKey key = defaultKey,
  ]) : super(context, key);

  @override
  EnumItem getItem(FactoryContext context, ContextKey key) => EnumItem.a;
}
