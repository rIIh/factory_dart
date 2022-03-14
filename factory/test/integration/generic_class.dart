import 'package:factory_annotation/factory_annotation.dart';

part "generic_class.factory.dart";

class GenericClass<T> {
  final T value;

  GenericClass(this.value);
}

@Factory(GenericClass)
class GenericClassFactory<T> extends _$GenericClassFactory<T> {
  final T? fallback;

  GenericClassFactory([
    this.fallback,
    FactoryContext? context,
    ContextKey key = defaultKey,
  ]) : super(context, key);

  @override
  T getValue(FactoryContext context, ContextKey key) {
    if (fallback != null) return fallback!;
    throw ArgumentError('no value can be obtained');
  }
}

// TODO: support typed generated mixin.
// @Factory(GenericClass)
// class GenericClassStringFactory extends _$GenericClassStringFactory<String> {
//   GenericClassStringFactory([FactoryContext? context, ContextKey key = defaultKey]) : super(context, key);
// }
