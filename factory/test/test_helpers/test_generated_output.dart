import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build_test/build_test.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTest
void testOutput(String target) {
  test('$target has no issue', () async {
    final main = await resolveSources(
      {
        'factory|test/integration/$target.dart': useAssetReader,
      },
      (r) => r.libraries.firstWhere(
          (element) => element.source.toString().contains('$target')),
    );

    final errorResult = await main.session.getErrors(
      '/factory/test/integration/$target.freezed.dart',
    ) as ErrorsResult;

    expect(errorResult.errors, isEmpty);
  });
}

Future<LibraryElement> getIntegrationTarget(String target) async {
  return resolveSources(
    {
      'factory|test/integration/$target.dart': useAssetReader,
    },
    (r) => r.libraries.firstWhere(
      (element) => element.source.toString().contains('$target'),
    ),
  );
}
