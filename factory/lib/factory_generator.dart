import 'package:analyzer/dart/constant/value.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:factory_annotation/factory_annotation.dart';
import 'package:source_gen/source_gen.dart';

String? _convertDartObjectToCode(DartObject object) {
  final values = [
    object.toBoolValue(),
    object.toIntValue(),
    object.toDoubleValue(),
    object.toFunctionValue(),
    object.toListValue(),
    object.toSetValue(),
    object.toMapValue(),
    object.toStringValue(),
    object.toSymbolValue(),
    object.toTypeValue(),
  ];
  return values.firstWhereOrNull((element) => element != null)?.toString();
}

class FactoryGenerator extends GeneratorForAnnotation<Factory> {
  static final _dartfmt = DartFormatter();
  static const _constructorChecker =
      TypeChecker.fromRuntime(FactoryConstructor);

  String? getDefaultValueCode(
    ConstructorElement constructor,
    ParameterElement parameter,
  ) {
    final computedValue = parameter.computeConstantValue();
    if (parameter.hasDefaultValue) {
      return parameter.defaultValueCode;
    }

    if (constructor.redirectedConstructor != null) {
      final redirectedParameter = constructor.redirectedConstructor!.parameters
          .firstWhereOrNull((element) => element.name == parameter.name);

      if (redirectedParameter != null) {
        return getDefaultValueCode(
          constructor.redirectedConstructor!,
          redirectedParameter,
        );
      }
    }
    if (computedValue != null && computedValue.hasKnownValue) {
      return _convertDartObjectToCode(computedValue);
    }
  }

  bool checkOptionalRecursive(
      ConstructorElement constructor, ParameterElement parameter) {
    if (parameter.isNotOptional) {
      return false;
    }
    if (constructor.redirectedConstructor != null) {
      final redirectedConstructor = constructor.redirectedConstructor!;
      final redirectedParameter = redirectedConstructor.parameters.firstWhere(
        (element) => element.name == parameter.name,
      );
      return checkOptionalRecursive(redirectedConstructor, redirectedParameter);
    }
    return parameter.isOptional;
  }

  @override
  Stream<String> generateForAnnotatedElement(
    Element factoryElement,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    if (factoryElement is ClassElement) {
      final target = annotation.read('target').typeValue;
      final targetElement = target.element;
      if (targetElement is! ClassElement) {
        throw StateError('Factory target should be valid class element');
      }

      final hasAnnotatedConstructor = targetElement.constructors.any(
        _constructorChecker.hasAnnotationOf,
      );
      final targetConstructor = targetElement.constructors.firstWhere(
        (element) {
          if (hasAnnotatedConstructor) {
            return _constructorChecker.hasAnnotationOf(element);
          }
          return !element.isSynthetic &&
              !element.isPrivate &&
              element.isAccessibleIn(factoryElement.library);
        },
      );
      final targetParameters = targetConstructor.parameters;
      final defaultValues = Map.fromEntries(
        targetParameters.map(
          (targetParameter) => MapEntry(
            targetParameter.name,
            getDefaultValueCode(targetConstructor, targetParameter),
          ),
        ),
      );

      bool checkDefaultValue(ParameterElement element) =>
          defaultValues[element.name] != null;

      final factoryImplementation = Class((it) {
        it.name = '_\$${factoryElement.name}';
        it.abstract = true;
        it.fields.addAll([
          Field(
            (it) => it
              ..name = 'isRoot'
              ..type = Reference('bool')
              ..modifier = FieldModifier.final$,
          ),
          Field(
            (it) => it
              ..name = 'context'
              ..type = Reference('FactoryContext')
              ..modifier = FieldModifier.final$,
          ),
          Field(
            (it) => it
              ..name = 'key'
              ..type = Reference('ContextKey')
              ..modifier = FieldModifier.final$,
          ),
        ]);

        it.constructors.add(Constructor((it) {
          it.optionalParameters.addAll([
            Parameter((it) => it
              ..name = 'context'
              ..type = Reference('FactoryContext?')),
            Parameter(
              (it) => it
                ..name = 'key'
                ..defaultTo = Code('defaultKey')
                ..toThis = true,
            ),
          ]);
          it.initializers.addAll([
            Code('isRoot = context == null'),
            Code('context = context ?? FactoryContext()'),
          ]);
        }));

        it.methods.addAll(targetParameters.map((targetParameter) {
          return Method((it) {
            it.name = 'get${targetParameter.name.capitalize()}';
            it.returns = Reference('${targetParameter.type}');
            it.requiredParameters.addAll([
              Parameter((it) {
                it.type = Reference('FactoryContext');
                it.name = 'context';
              }),
              Parameter((it) {
                it.type = Reference('ContextKey');
                it.name = 'key';
              })
            ]);

            final targetParameterDefaultValue =
                defaultValues[targetParameter.name];

            if (targetParameterDefaultValue?.isNotEmpty == true) {
              it.body = Code('return $targetParameterDefaultValue;');
            } else if (targetParameter.isOptional &&
                !targetParameter.hasDefaultValue &&
                targetConstructor.redirectedConstructor == null) {
              it.body = Code('return null;');
            } else if (targetParameter.hasDefaultValue) {
              it.body = Code('return ${targetParameter.defaultValueCode};');
            }
          });
        }));

        final valueBuilders = targetParameters.map(
          (e) => Parameter((it) {
            it.name = e.name;
            it.named = true;
            it.type = Reference('ValueBuilder<${e.type}>?');
          }),
        );

        it.methods.add(Method((it) {
          it.name = 'create';
          it.returns = Reference('${targetElement.thisType}');
          it.optionalParameters.addAll(valueBuilders);

          final fieldsSetters = targetParameters.map(
            (e) => '_\$objectBuilder.${e.name} = '
                '(${e.name} ?? get${e.name.capitalize()})(context, key + \'${e.name}\');',
          );

          it.body = Code('''
            final _\$objectBuilder = _${targetElement.thisType}Builder();
            this.context.add(_\$objectBuilder.toReadOnly(), this.key);

            ${fieldsSetters.join('\n')}

            {
              final object = _\$objectBuilder.build();
              this.context.clear();
              return object;
            }
          ''');
        }));

        it.methods.add(Method((it) {
          it.name = 'batch';
          it.returns = Reference('List<${targetElement.thisType}>');
          it.requiredParameters.add(Parameter((it) {
            it.name = 'length';
            it.type = Reference('int');
          }));

          it.optionalParameters.addAll(valueBuilders);
          it.body = Code('''
          return List.generate(
            length,
            (index) => create(
              ${targetParameters.map((e) => '${e.name}: ${e.name}').join(',\n')}
            ),
          );
          ''');
        }));
      });

      final readonlyBulder = Class((it) {
        it.name = '${targetElement.thisType}ReadonlyBuilder';
        it.extend = Reference(
          'ObjectReadonlyBuilder<${targetElement.thisType}>',
        );

        it.fields.addAll(
          targetParameters.map(
            (e) => Field(
              (it) {
                final hasDefaultValue = checkDefaultValue(e);
                final shouldBeNullable =
                    !hasDefaultValue && !e.type.toString().endsWith('?');
                it
                  ..type = Reference(
                    'ValueGetter<${e.type}${shouldBeNullable ? '?' : ''}>',
                  )
                  ..name = 'get${e.name.capitalize()}'
                  ..modifier = FieldModifier.final$;
              },
            ),
          ),
        );

        it.constructors.add(Constructor((it) {
          it.constant = true;
          it.requiredParameters.addAll(
            targetParameters.map(
              (e) => Parameter(
                (it) => it
                  ..name = 'get${e.name.capitalize()}'
                  ..toThis = true,
              ),
            ),
          );
        }));
      });

      final builder = Class((it) {
        it.name = '_${targetElement.thisType}Builder';
        it.extend = Reference('ObjectBuilder<${targetElement.thisType}>');

        it.fields.addAll(
          targetParameters.map(
            (targetParameter) => Field(
              (it) {
                final hasDefaultValue =
                    defaultValues[targetParameter.name] != null;

                final shouldBeNullable = !hasDefaultValue &&
                    !targetParameter.type.toString().endsWith('?');

                it
                  ..name = targetParameter.name
                  ..type = Reference(
                      '${targetParameter.type}${shouldBeNullable ? '?' : ''}');

                final parameterDefaultAssignment =
                    defaultValues[targetParameter.name];

                if (parameterDefaultAssignment?.isNotEmpty == true) {
                  it.assignment = Code(parameterDefaultAssignment!);
                } else if (targetParameter.hasDefaultValue) {
                  it.assignment = Code(targetParameter.defaultValueCode!);
                }
              },
            ),
          ),
        );

        it.methods.add(
          Method(
            (it) {
              it
                ..name = 'toReadOnly'
                ..returns = Reference(readonlyBulder.name);

              it.body = Code('''
              return ${readonlyBulder.name}(
                ${targetParameters.map((e) => '() => ${e.name}').join(',\n')}
              );
              ''');
            },
          ),
        );

        it.methods.add(
          Method(
            (it) {
              final parameters = targetParameters.map((e) {
                if (e.isNamed) {
                  return '${e.name}: ${e.name}';
                }
                return '${e.name}';
              });
              final constructorHasName =
                  targetConstructor.name.isNotEmpty == true;
              final constructor =
                  '${targetElement.thisType}${constructorHasName ? '.' + targetConstructor.name : ''}';
              it
                ..name = 'build'
                ..returns = Reference('${targetElement.thisType}')
                ..body = Code('''
            try {
              ${targetParameters.map((e) {
                  final isOptional =
                      checkOptionalRecursive(targetConstructor, e);
                  return 'final ${e.name} = this.${e.name}${!isOptional ? '!' : ''};';
                }).join('\n')}

              return $constructor(
                ${parameters.join(',\n')}
              );
            } on Object {
              throw InvalidBuilderStateException();
            }
            ''');
            },
          ),
        );
      });

      final library = Library(
        (b) => b.body.addAll(
          [
            factoryImplementation,
            readonlyBulder,
            builder,
          ],
        ),
      );
      final code = '${library.accept(DartEmitter.scoped())}';
      yield _dartfmt.format(code);
    }
  }
}

extension on String {
  String capitalize() {
    if (length <= 1) {
      return toUpperCase();
    }

    return substring(0, 1).toUpperCase() + substring(1);
  }
}
