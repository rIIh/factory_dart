import 'package:meta/meta.dart';

typedef ValueGetter<T> = T Function();
typedef ValueBuilder<T> = T Function(FactoryContext context, ContextKey key);

ValueBuilder<T> fromValue<T>(T value) => (_, __) => value;

abstract class ObjectReadonlyBuilder<T> {
  const ObjectReadonlyBuilder();
}

abstract class ObjectBuilder<T> extends ObjectReadonlyBuilder {
  const ObjectBuilder();

  /// Create [T] object with populated properties
  T build();
}

@immutable
class ContextKey {
  final String path;

  const ContextKey([this.path = 'root']);

  ContextKey operator +(String other) {
    assert(!other.contains('.'));
    return ContextKey('$path.$other');
  }

  ContextKey up() {
    final segments = path.split('.');
    return ContextKey(segments.take(segments.length - 1).join('.'));
  }

  @override
  bool operator ==(Object other) => other is ContextKey && other.path == path;

  @override
  int get hashCode => path.hashCode;
}

class FactoryContext {
  final Map<ContextKey, ObjectReadonlyBuilder> _builders = {};

  void add(ObjectReadonlyBuilder builder, ContextKey key) =>
      _builders[key] = builder;

  TBuilder
      read<TBuilder extends ObjectReadonlyBuilder<TTargetType>, TTargetType>(
    ContextKey key,
  ) =>
          _builders[key] as TBuilder;

  void clear() {
    _builders.clear();
  }
}
