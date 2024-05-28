import 'package:factory_annotation/factory_annotation.dart';

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
