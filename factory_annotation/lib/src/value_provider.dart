import 'package:faker/faker.dart';

abstract class ValueProvider {
  const ValueProvider();

  int getInt();
  double getDouble();
  String getString();
  bool getBool();

  T getEnumValue<T>(List<T> values);

  bool canHandleType<TType>();
  bool canHandleEnum();
}

class FakerProvider extends ValueProvider {
  final Faker _faker;

  FakerProvider([Faker? faker]) : _faker = faker ?? Faker();

  @override
  bool getBool() => _faker.randomGenerator.boolean();

  @override
  double getDouble() => _faker.randomGenerator.decimal();

  @override
  T getEnumValue<T>(List<T> values) => _faker.randomGenerator.element(values);

  @override
  int getInt() => _faker.randomGenerator.integer(1000);

  @override
  String getString() => _faker.lorem.sentence();

  bool canHandleType<TType>() => [bool, String, double, int].contains(TType);

  bool canHandleEnum() => true;
}
