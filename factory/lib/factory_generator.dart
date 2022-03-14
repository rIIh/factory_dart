import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:factory_annotation/factory_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'utils.dart';
import 'extensions.dart';

void logWarning(String message) => print(getDelimetedSection(
      message,
      32,
      title: 'Factory Generator',
    ));

class FactoryGenerator extends GeneratorForAnnotation<Factory> {
  static final _dartfmt = DartFormatter();
  static const _constructorChecker =
      TypeChecker.fromRuntime(FactoryConstructor);

  const FactoryGenerator();

  String? getDefaultValueCode(
    ParameterElement parameter,
  ) {
    final constructor = parameter.enclosingElement as ConstructorElement;
    if (parameter.hasDefaultValue) {
      return parameter.defaultValueCode;
    }
    if (constructor.redirectedConstructor != null) {
      final redirectedParameter =
          constructor.redirectedConstructor!.parameters.firstWhereOrNull(
        (element) => element.name == parameter.name,
      );

      if (redirectedParameter != null) {
        return getDefaultValueCode(redirectedParameter);
      }
    }
  }

  Future<String?> getDocumentation(
      ParameterElement parameter, BuildStep buildStep) async {
    if (parameter.documentationComment?.isNotEmpty == true) {
      return parameter.documentationComment;
    }

    final parameterDocumentation = await documentationOfParameter(
      parameter,
      buildStep,
    );
    if (parameterDocumentation.isNotEmpty == true) {
      return parameterDocumentation;
    }

    if (parameter.isInitializingFormal) {
      final classElement =
          parameter.enclosingElement!.enclosingElement as ClassElement;

      final field = classElement.fields
          .firstWhereOrNull((element) => element.name == parameter.name);

      if (field?.documentationComment != null) {
        return field!.documentationComment;
      }
    }
  }

  bool checkOptionalRecursive(ParameterElement parameter) {
    final constructor = parameter.enclosingElement as ConstructorElement;
    if (constructor.redirectedConstructor != null) {
      final redirectedConstructor = constructor.redirectedConstructor!;
      final redirectedParameter = redirectedConstructor.parameters.firstWhere(
        (element) => element.name == parameter.name,
      );
      return checkOptionalRecursive(redirectedParameter);
    }
    // TODO: remove when `analyzer: 2.0.0` dependency used.
    // Because of occasionaly missing defaultValueCode for parameter
    // we can't use `parameter.isOptional` to determine optionality.
    // Analyzer marks parameter optional regardless of missing defaultValueCode.
    // Therefore parameter can't be optional if we not have default value for it
    // or it not nullable.
    if (parameter.isOptional && !parameter.type.toString().endsWith('?')) {
      return getDefaultValueCode(parameter)?.isNotEmpty == true;
    }
    return parameter.isOptional;
  }

  String? getProviderCallCode(DartType type,
      {String contextGetter = 'context', String keyGetter = 'key'}) {
    final provider = 'valueProvider!.';
    String? method;
    if (type.isDartCoreInt) {
      method = 'getInt($contextGetter, $keyGetter)';
    } else if (type.isDartCoreDouble) {
      method = 'getDouble($contextGetter, $keyGetter)';
    } else if (type.isDartCoreString) {
      method = 'getString($contextGetter, $keyGetter)';
    } else if (type.isDartCoreBool) {
      method = 'getBool($contextGetter, $keyGetter)';
    }
    if (isEnum(type)) {
      method =
          'getEnumValue(${type.getDisplayString(withNullability: false)}.values, $contextGetter, $keyGetter)';
    }
    if (method != null) {
      return '''
      try {
        return ${provider + method};
      } catch (exception) {
        throw MissingValueProviderException();
      }
      ''';
    }
  }

  bool checkValueProviderAssigned(ClassElement factoryElement) {
    final fieldElement = factoryElement.fields.firstWhereOrNull(
      (element) => element.name == 'valueProvider',
    );
    if (fieldElement != null) {
      if (fieldElement.hasInitializer) {
        return true;
      }
      if (fieldElement.getter != null && !factoryElement.isAbstract) {
        logWarning(
          'You define `valueProvider` field as a getter in '
          '${factoryElement.thisType.getDisplayString(withNullability: false)}. '
          'That type of operation is not supported.\n'
          '\n'
          'Prefer to use "late ValueProvider? valueProvider = {value}" syntax.\n'
          'Or use mixin with "late ValueProvider? valueProvider = {value}" implementation.\n'
          '\n'
          'Example - `class Factory extends _\$Factory with FakerProviderMixin`',
        );
      }
    }
    if (factoryElement.mixins.isNotEmpty) {
      return factoryElement.mixins.any(
        (element) => checkValueProviderAssigned(element.element),
      );
    }
    return false;
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
      final parametersDocumentation = Map.fromEntries(
        await Future.wait(
          targetParameters.map(
            (e) async => MapEntry(
              e.name,
              await getDocumentation(e, buildStep),
            ),
          ),
        ),
      );
      final hasValueProvider = checkValueProviderAssigned(factoryElement);
      for (final targetParameter in targetParameters) {
        final element = targetParameter.type.element;
        if (element?.isAccessibleIn(factoryElement.library) != true) {
          logWarning(
            '${targetParameter.type.getDisplayString(withNullability: false)} needed by ${targetConstructor.displayName}\n'
            'but not accessible in ${factoryElement.library.displayName} file.',
          );
        }
      }

      final defaultValues = Map.fromEntries(
        targetParameters.map(
          (targetParameter) => MapEntry(
            targetParameter.name,
            getDefaultValueCode(targetParameter),
          ),
        ),
      );

      bool checkDefaultValue(ParameterElement element) =>
          defaultValues[element.name] != null;

      final factoryImplementation = Class((it) {
        it.name = '_\$${factoryElement.name}';
        it.types.addAll(
            factoryElement.typeParameters.map((type) => Reference('$type')));
        it.extend = Reference('ObjectFactory<${targetElement.thisType}>');
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
            final docs = parametersDocumentation[targetParameter.name];
            if (docs?.isNotEmpty == true) {
              it.docs.add(docs!);
            }
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

            final hasDefaultValueCode =
                defaultValues[targetParameter.name] != null;
            final isOptional = checkOptionalRecursive(targetParameter);
            final providerAssignment =
                getProviderCallCode(targetParameter.type);

            if (hasDefaultValueCode) {
              it.body = Code('return ${defaultValues[targetParameter.name]};');
            } else if (targetParameter.hasDefaultValue) {
              it.body = Code('return ${targetParameter.defaultValueCode};');
            } else if (hasValueProvider && providerAssignment != null) {
              it.body = Code(providerAssignment);
            } else if (isOptional) {
              it.body = Code('return null;');
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

          final builderTypeParameters = targetElement.thisType.typeArguments;
          final builderTypeParametersString = builderTypeParameters.isNotEmpty
              ? '<${builderTypeParameters.join(',')}>'
              : '';

          it.body = Code('''
            final _\$objectBuilder = _${targetElement.thisType.plainName}Builder$builderTypeParametersString();
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
        final typeName = targetElement.thisType.plainName;
        final genericTypes = targetElement.thisType.typeArguments;

        it.name = '${typeName}ReadonlyBuilder';
        it.types.addAll(genericTypes.map((type) => Reference('$type')));
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
        final typeName = targetElement.thisType.plainName;
        final genericTypes = targetElement.thisType.typeArguments;

        it.name = '_${typeName}Builder';
        it.types.addAll(genericTypes.map((type) => Reference('$type')));
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
              ${targetParameters.map((targetParameter) {
                  final isOptional = checkOptionalRecursive(targetParameter);
                  return 'final ${targetParameter.name} = this.${targetParameter.name}${!isOptional ? '!' : ''};';
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
