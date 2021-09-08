abstract class ObjectFactoryException implements Exception {}

abstract class ObjectBuilderException implements Exception {}

class InvalidBuilderStateException implements ObjectBuilderException {}

/// [MissingValueProviderException] thrown when generated code tries
/// to access `valueProvider`, but not it returns null.
class MissingValueProviderException implements ObjectFactoryException {
  final String message =
      'Generated code assumes that `valueProvider` is assigned. '
      'But when valueProvider was accessed it throws NullPointerException. '
      'If you removed valueProvider from factory declaration, '
      'rebuild generated code';

  @override
  String toString() => message;
}
