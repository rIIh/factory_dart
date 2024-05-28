import '../../factory_annotation.dart';

abstract class ValueProvider {
  const ValueProvider();

  int getInt(FactoryContext context, ContextKey key);

  double getDouble(FactoryContext context, ContextKey key);

  String getString(FactoryContext context, ContextKey key);

  bool getBool(FactoryContext context, ContextKey key);

  T getEnumValue<T>(List<T> values, FactoryContext context, ContextKey key);
}
