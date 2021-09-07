class FactoryConstructor {
  const FactoryConstructor();
}

const factoryConstuctor = FactoryConstructor();

class DefaultValueBulder {
  final dynamic Function() builder;

  const DefaultValueBulder(this.builder);
}

class Factory {
  final Type target;

  const Factory(this.target);
}
