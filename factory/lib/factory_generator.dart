import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

class FactoryGenerator extends GeneratorForAnnotation<Factory> {
  static final _dartfmt = DartFormatter();
  static const _constructorChecker =
      TypeChecker.fromRuntime(FactoryConstructor);

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
              element.isAccessibleIn(
                factoryElement.library,
              );
        },
      );
      final targetFields = targetConstructor.parameters;

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
                ..defaultTo = Code('const ContextKey()')
                ..toThis = true,
            ),
          ]);
          it.initializers.addAll([
            Code('isRoot = context == null'),
            Code('context = context ?? FactoryContext()'),
          ]);
        }));

        it.methods.addAll(targetFields.map((e) {
          return Method((it) {
            it.name = 'get${e.name.capitalize()}';
            it.returns = Reference('${e.type}');
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

            if (e.isOptional && !e.hasDefaultValue) {
              it.body = Code('return null;');
            } else if (e.hasDefaultValue) {
              it.body = Code('return ${e.defaultValueCode};');
            }
          });
        }));

        final valueBuilders = targetFields.map(
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

          final fieldsSetters = targetFields.map(
            (e) => 'builder.${e.name} = '
                '(${e.name} ?? get${e.name.capitalize()})(context, key + \'${e.name}\');',
          );

          it.body = Code('''
            final builder = _${targetElement.thisType}Builder();
            context.add(builder.toReadOnly(), key);

            ${fieldsSetters.join('\n')}

            final object = builder.build();
            context.clear();
            return object;
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
              ${targetFields.map((e) => '${e.name}: ${e.name}').join(',\n')}
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
          targetFields.map(
            (e) => Field(
              (it) => it
                ..type = Reference(
                  'ValueGetter<${e.type}${e.isOptional ? '' : '?'}>',
                )
                ..name = 'get${e.name.capitalize()}'
                ..modifier = FieldModifier.final$,
            ),
          ),
        );

        it.constructors.add(Constructor((it) {
          it.constant = true;
          it.requiredParameters.addAll(
            targetFields.map(
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
          targetFields.map(
            (e) => Field(
              (it) => it
                ..name = e.name
                ..type = Reference('${e.type}${e.isOptional ? '' : '?'}')
                ..assignment =
                    e.hasDefaultValue ? Code(e.defaultValueCode!) : null,
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
                ${targetFields.map((e) => '() => ${e.name}').join(',\n')}
              );
              ''');
            },
          ),
        );

        it.methods.add(
          Method(
            (it) {
              final parameters = targetFields.map((e) {
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
              ${targetFields.map((e) => 'final ${e.name} = this.${e.name}${e.isNotOptional ? '!' : ''};').join('\n')}

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
      print(code);
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
