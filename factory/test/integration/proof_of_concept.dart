import 'package:factory_annotation/factory_annotation.dart';
import 'package:faker/faker.dart';

part 'proof_of_concept.factory.dart';

class Item {
  final String name;
  final int quantity;
  final bool flag;
  final SubItem? subItem;

  @factoryConstuctor
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
  String getName(FactoryContext context, ContextKey key) =>
      Faker().person.name();

  @override
  int getQuantity(FactoryContext context, ContextKey key) =>
      Faker().randomGenerator.integer(10);

  @override
  SubItem getSubItem(FactoryContext context, ContextKey key) =>
      SubItemFactory(context, key).create();

  @override
  bool getFlag(FactoryContext context, ContextKey key) {
    return false;
  }
}

@Factory(SubItem)
class SubItemFactory extends _$SubItemFactory {
  SubItemFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);

  @override
  DateTime getCreated(FactoryContext context, ContextKey key) =>
      Faker().date.dateTime();
}
