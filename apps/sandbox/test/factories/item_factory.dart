import 'package:factory_annotation/factory_annotation.dart';
import 'package:sandbox/entity/item.dart';

export 'package:factory_annotation/factory_annotation.dart';
part 'item_factory.factory.dart';

@Factory(Item)
class ItemFactory extends _$ItemFactory with FakerProviderMixin {
  ItemFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}
