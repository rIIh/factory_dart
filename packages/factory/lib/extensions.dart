import 'package:analyzer/dart/element/type.dart';
import 'package:factory/utils.dart';

extension InterfaceTypeExtension on InterfaceType {
  String get plainName => getPlainTypeName(this);
}
