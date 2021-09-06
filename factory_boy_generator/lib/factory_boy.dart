import 'package:build/build.dart';
import 'package:factory_boy_generator/factory_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
PartBuilder factory(BuilderOptions options) {
  return PartBuilder([FactoryGenerator()], '.factory.dart',
      header: '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target
    ''');
}
