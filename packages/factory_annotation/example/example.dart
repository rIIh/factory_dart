import 'package:factory_annotation/factory_annotation.dart';
import 'package:factory_annotation/src/value_provider.dart';
import 'package:faker/faker.dart';

part 'example.factory.dart';

class Item {
  final String name;
  final int quantity;
  final bool flag;
  final SubItem? subItem;

  @factoryConstructor
  const Item(
    this.name, {
    required this.quantity,
    this.flag = false,
    this.subItem,
  });
}

class SubItem {
  final DateTime created;
  final DateTime? updated;

  SubItem(this.created, {this.updated});
}

@Factory(Item)
class ItemFactory extends _$ItemFactory {
  ItemFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);

  @override
  late ValueProvider? valueProvider = FakerProvider();

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
  SubItemFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);

  @override
  DateTime getCreated(FactoryContext context, ContextKey key) =>
      Faker().date.dateTime();
}
