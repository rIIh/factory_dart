class FactoryConstructor {
  const FactoryConstructor();
}

const factoryConstructor = FactoryConstructor();

class DefaultValueBuilder {
  final dynamic Function() builder;

  const DefaultValueBuilder(this.builder);
}

class Factory {
  final Type target;

  const Factory(this.target);
}
