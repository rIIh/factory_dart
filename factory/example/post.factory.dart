// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target
// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_this

part of 'post.dart';

// **************************************************************************
// FactoryGenerator
// **************************************************************************

abstract class _$PostFactory extends ObjectFactory<Post> {
  _$PostFactory([
    FactoryContext? context,
    this.key = defaultKey,
  ])  : isRoot = context == null,
        context = context ?? FactoryContext();

  final bool isRoot;

  final FactoryContext context;

  final ContextKey key;

  int getId(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getInt(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  String getTitle(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  String getDescription(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  Picture getImage(
    FactoryContext context,
    ContextKey key,
  );
  Author getAuthor(
    FactoryContext context,
    ContextKey key,
  );
  Post create({
    ValueBuilder<int>? id,
    ValueBuilder<String>? title,
    ValueBuilder<String>? description,
    ValueBuilder<Picture>? image,
    ValueBuilder<Author>? author,
  }) {
    final _$objectBuilder = _PostBuilder();
    this.context.add(_$objectBuilder.toReadOnly(), this.key);

    _$objectBuilder.id = (id ?? getId)(context, key + 'id');
    _$objectBuilder.title = (title ?? getTitle)(context, key + 'title');
    _$objectBuilder.description =
        (description ?? getDescription)(context, key + 'description');
    _$objectBuilder.image = (image ?? getImage)(context, key + 'image');
    _$objectBuilder.author = (author ?? getAuthor)(context, key + 'author');

    {
      final object = _$objectBuilder.build();
      this.context.clear();
      return object;
    }
  }

  List<Post> batch(
    int length, {
    ValueBuilder<int>? id,
    ValueBuilder<String>? title,
    ValueBuilder<String>? description,
    ValueBuilder<Picture>? image,
    ValueBuilder<Author>? author,
  }) {
    return List.generate(
      length,
      (index) => create(
          id: id,
          title: title,
          description: description,
          image: image,
          author: author),
    );
  }
}

class PostReadonlyBuilder extends ObjectReadonlyBuilder<Post> {
  const PostReadonlyBuilder(
    this.getId,
    this.getTitle,
    this.getDescription,
    this.getImage,
    this.getAuthor,
  );

  final ValueGetter<int?> getId;

  final ValueGetter<String?> getTitle;

  final ValueGetter<String?> getDescription;

  final ValueGetter<Picture?> getImage;

  final ValueGetter<Author?> getAuthor;
}

class _PostBuilder extends ObjectBuilder<Post> {
  int? id;

  String? title;

  String? description;

  Picture? image;

  Author? author;

  PostReadonlyBuilder toReadOnly() {
    return PostReadonlyBuilder(
        () => id, () => title, () => description, () => image, () => author);
  }

  Post build() {
    try {
      final id = this.id!;
      final title = this.title!;
      final description = this.description!;
      final image = this.image!;
      final author = this.author!;

      return Post(
          id: id,
          title: title,
          description: description,
          image: image,
          author: author);
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}

abstract class _$AuthorFactory extends ObjectFactory<Author> {
  _$AuthorFactory([
    FactoryContext? context,
    this.key = defaultKey,
  ])  : isRoot = context == null,
        context = context ?? FactoryContext();

  final bool isRoot;

  final FactoryContext context;

  final ContextKey key;

  String getFirstName(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  String getLastName(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  Author create({
    ValueBuilder<String>? firstName,
    ValueBuilder<String>? lastName,
  }) {
    final _$objectBuilder = _AuthorBuilder();
    this.context.add(_$objectBuilder.toReadOnly(), this.key);

    _$objectBuilder.firstName =
        (firstName ?? getFirstName)(context, key + 'firstName');
    _$objectBuilder.lastName =
        (lastName ?? getLastName)(context, key + 'lastName');

    {
      final object = _$objectBuilder.build();
      this.context.clear();
      return object;
    }
  }

  List<Author> batch(
    int length, {
    ValueBuilder<String>? firstName,
    ValueBuilder<String>? lastName,
  }) {
    return List.generate(
      length,
      (index) => create(firstName: firstName, lastName: lastName),
    );
  }
}

class AuthorReadonlyBuilder extends ObjectReadonlyBuilder<Author> {
  const AuthorReadonlyBuilder(
    this.getFirstName,
    this.getLastName,
  );

  final ValueGetter<String?> getFirstName;

  final ValueGetter<String?> getLastName;
}

class _AuthorBuilder extends ObjectBuilder<Author> {
  String? firstName;

  String? lastName;

  AuthorReadonlyBuilder toReadOnly() {
    return AuthorReadonlyBuilder(() => firstName, () => lastName);
  }

  Author build() {
    try {
      final firstName = this.firstName!;
      final lastName = this.lastName!;

      return Author(firstName: firstName, lastName: lastName);
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}

abstract class _$PictureFactory extends ObjectFactory<Picture> {
  _$PictureFactory([
    FactoryContext? context,
    this.key = defaultKey,
  ])  : isRoot = context == null,
        context = context ?? FactoryContext();

  final bool isRoot;

  final FactoryContext context;

  final ContextKey key;

  String getSmall(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  String getMedium(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  String getLarge(
    FactoryContext context,
    ContextKey key,
  ) {
    try {
      return valueProvider!.getString(context, key);
    } catch (exception) {
      throw MissingValueProviderException();
    }
  }

  Picture create({
    ValueBuilder<String>? small,
    ValueBuilder<String>? medium,
    ValueBuilder<String>? large,
  }) {
    final _$objectBuilder = _PictureBuilder();
    this.context.add(_$objectBuilder.toReadOnly(), this.key);

    _$objectBuilder.small = (small ?? getSmall)(context, key + 'small');
    _$objectBuilder.medium = (medium ?? getMedium)(context, key + 'medium');
    _$objectBuilder.large = (large ?? getLarge)(context, key + 'large');

    {
      final object = _$objectBuilder.build();
      this.context.clear();
      return object;
    }
  }

  List<Picture> batch(
    int length, {
    ValueBuilder<String>? small,
    ValueBuilder<String>? medium,
    ValueBuilder<String>? large,
  }) {
    return List.generate(
      length,
      (index) => create(small: small, medium: medium, large: large),
    );
  }
}

class PictureReadonlyBuilder extends ObjectReadonlyBuilder<Picture> {
  const PictureReadonlyBuilder(
    this.getSmall,
    this.getMedium,
    this.getLarge,
  );

  final ValueGetter<String?> getSmall;

  final ValueGetter<String?> getMedium;

  final ValueGetter<String?> getLarge;
}

class _PictureBuilder extends ObjectBuilder<Picture> {
  String? small;

  String? medium;

  String? large;

  PictureReadonlyBuilder toReadOnly() {
    return PictureReadonlyBuilder(() => small, () => medium, () => large);
  }

  Picture build() {
    try {
      final small = this.small!;
      final medium = this.medium!;
      final large = this.large!;

      return Picture(small: small, medium: medium, large: large);
    } on Object {
      throw InvalidBuilderStateException();
    }
  }
}
