import 'package:factory_boy/factory_declaration.dart';

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
