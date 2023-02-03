import 'package:factory_annotation/factory_annotation.dart';

part 'post.factory.dart';

class Post {
  final int id;
  final String title;
  final String description;
  final Picture image;
  final Author author;

  @factoryConstuctor
  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.author,
  });
}

class Picture {
  final String small;
  final String medium;
  final String large;

  const Picture({
    required this.small,
    required this.medium,
    required this.large,
  });
}

class Author {
  final String firstName;
  final String lastName;

  Author({
    required this.firstName,
    required this.lastName,
  });
}

@Factory(Post)
class PostFactory extends _$PostFactory with FakerProviderMixin {
  PostFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);

  @override
  Author getAuthor(FactoryContext context, ContextKey key) {
    return AuthorFactory(context, key).create();
  }

  @override
  Picture getImage(FactoryContext context, ContextKey key) {
    return PictureFactory(context, key).create();
  }
}

@Factory(Author)
class AuthorFactory extends _$AuthorFactory with FakerProviderMixin {
  AuthorFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}

@Factory(Picture)
class PictureFactory extends _$PictureFactory with FakerProviderMixin {
  PictureFactory([FactoryContext? context, ContextKey key = defaultKey])
      : super(context, key);
}

void main() {
  final post_manual_creation = Post(
    id: 0,
    title: "title",
    description: "description",
    author: Author(
      firstName: "John",
      lastName: "Doe",
    ),
    image: Picture(
      small: "small.png",
      medium: "medium.png",
      large: "large.png",
    ),
  );

  final post_from_factory = PostFactory().create(
    title: (_, __) => 'title override',
  );
}
