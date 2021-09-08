import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import 'test_helpers/test_generated_output.dart';
import 'utils.dart';

void main() {
  const target = 'documented_parameter';

  testOutput(target);

  test(
    'factory generator can add documentation to factory resolvers methods',
    () async {
      final library = await getIntegrationTarget(target);
      final factoryElement = library.topLevelElements.firstWhereOrNull(
        (element) =>
            element is ClassElement &&
            objectFactoryTypeChecker.isSuperOf(element),
      ) as ClassElement?;

      expect(factoryElement, isNotNull);
      factoryElement!;

      expect(
        getDocumentation(
          getMethod(factoryElement, 'getDocumentedField')!,
        ),
        equals('Documented field'),
      );

      expect(
        getDocumentation(
          getMethod(factoryElement, 'getDocumentedParameter')!,
        ),
        equals('Documented parameter'),
      );

      expect(
        getDocumentation(
          getMethod(factoryElement, 'getNotDocumentedParameter')!,
        ),
        isNull,
      );
    },
  );
}
