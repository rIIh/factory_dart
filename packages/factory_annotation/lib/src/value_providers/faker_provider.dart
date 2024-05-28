import 'package:faker/faker.dart';

import '../../factory_annotation.dart';
import 'value_provider.dart';

mixin FakerProviderMixin {
  late ValueProvider? valueProvider = FakerProvider();
}

class FakerProvider extends ValueProvider {
  final Faker _faker;

  FakerProvider([Faker? faker]) : _faker = faker ?? Faker();

  @override
  bool getBool(FactoryContext context, ContextKey key) =>
      _faker.randomGenerator.boolean();

  @override
  double getDouble(FactoryContext context, ContextKey key) =>
      _faker.randomGenerator.decimal();

  @override
  int getInt(FactoryContext context, ContextKey key) =>
      _faker.randomGenerator.integer(1000);

  @override
  String getString(FactoryContext context, ContextKey key) =>
      _faker.lorem.sentence();

  @override
  T getEnumValue<T>(List<T> values, FactoryContext context, ContextKey key) =>
      _faker.randomGenerator.element(values);
}
