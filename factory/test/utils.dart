import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:factory_annotation/factory_annotation.dart';
import 'package:source_gen/source_gen.dart';

const objectFactoryTypeChecker = TypeChecker.fromRuntime(ObjectFactory);

MethodElement? getMethod(ClassElement classElement, String name) {
  return classElement.methods
      .firstWhereOrNull((element) => element.name == name);
}

String? getDocumentation(Element element) {
  if (element.documentationComment?.isNotEmpty == true) {
    return element.documentationComment!.replaceAll(RegExp(r'///\s?'), '');
  }
  if (element.hasOverride) {
    final classElement = element.enclosingElement as ClassElement?;
    if (classElement != null && element.name != null) {
      final superElement = getMethod(
        classElement.supertype!.element,
        element.name!,
      );
      if (superElement != null) {
        return getDocumentation(superElement);
      }
    }
  }
}
