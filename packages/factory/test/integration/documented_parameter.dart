import 'package:factory_annotation/factory_annotation.dart';

part 'documented_parameter.factory.dart';

@Factory(DocumentedParameterModel)
class DocumentedParameterModelFactory
    extends _$DocumentedParameterModelFactory {
  DocumentedParameterModelFactory([
    FactoryContext? context,
    ContextKey key = defaultKey,
  ]) : super(context, key);

  @override
  String getDocumentedField(FactoryContext context, ContextKey key) {
    throw UnimplementedError();
  }

  @override
  String getDocumentedParameter(FactoryContext context, ContextKey key) {
    throw UnimplementedError();
  }

  @override
  String getNotDocumentedParameter(FactoryContext context, ContextKey key) {
    throw UnimplementedError();
  }
}

class DocumentedParameterModel {
  /// Documented field
  final String documentedField;

  DocumentedParameterModel({
    required this.documentedField,

    /// Documented parameter
    required String documentedParameter,
    required String notDocumentedParameter,
  });
}
