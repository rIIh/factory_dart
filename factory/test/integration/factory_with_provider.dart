import 'package:factory_annotation/factory_annotation.dart';

part 'factory_with_provider.factory.dart';

class FactoryWithProviderItem {
  final String text;

  FactoryWithProviderItem(this.text);
}

@Factory(FactoryWithProviderItem)
class FactoryWithProviderItemFactory extends _$FactoryWithProviderItemFactory
    with FakerProviderMixin {
  FactoryWithProviderItemFactory(
      [FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}
