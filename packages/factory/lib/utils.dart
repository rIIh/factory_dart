import 'dart:math';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';

String getPlainTypeName(InterfaceType type) {
  return type
      .getDisplayString(withNullability: false)
      .replaceFirst(RegExp(r'<.+>'), '');
}

Future<String> documentationOfParameter(
  ParameterElement parameter,
  BuildStep buildStep,
) async {
  final builder = StringBuffer();

  final astNode = await tryGetAstNodeForElement(parameter, buildStep);

  for (Token? token = astNode.beginToken.precedingComments;
      token != null;
      token = token.next) {
    builder.writeln(token);
  }

  return builder.toString();
}

Future<AstNode> tryGetAstNodeForElement(
  Element element,
  BuildStep buildStep,
) async {
  var library = element.library!;

  while (true) {
    try {
      final result = library.session.getParsedLibraryByElement(library)
          as ParsedLibraryResult?;

      return result!.getElementDeclaration(element)!.node;
    } on InconsistentAnalysisException {
      library = await buildStep.resolver.libraryFor(
        await buildStep.resolver.assetIdForElement(element.library!),
      );
    }
  }
}

bool isEnum(DartType type) {
  final element = type.element;

  return element is EnumElement ||
      (element is ClassElement && element.isDartCoreEnum);
}

String getDelimiter(int length, {String title = ''}) {
  title = title.trim().isNotEmpty ? ' ${title.trim()} ' : title;
  length = max(length, title.length);
  length = title.length.isEven ? length : length + 1;
  final delimiter = '=' * length;
  final start = (length - title.length) ~/ 2;
  final end = (length + title.length) ~/ 2;
  return delimiter.replaceRange(start, end, title);
}

String getDelimitedSection(
  String message,
  int delimiterLength, {
  String title = '',
}) {
  final maxPart = message.split('\n').map((e) => e.length).fold(0, max);
  delimiterLength = max(delimiterLength, maxPart);

  final top = getDelimiter(delimiterLength, title: title);
  final bottom = getDelimiter(top.length);

  return [
    top,
    message,
    bottom,
  ].join('\n');
}
